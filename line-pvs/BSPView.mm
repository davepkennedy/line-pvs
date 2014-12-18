//
//  BSPView.m
//  line-pvs
//
//  Created by Dave Kennedy on 17/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#import "BSPView.h"
#import "Document.h"

#include "LineNode.h"
#include "Point.h"

@implementation BSPView

BOOL displayPvs = NO;
NSPoint pt;

static NSPoint toNSPoint (pvs::Point pt) {
    return CGPointMake(pt.x(), pt.y());
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (Document*) document {
    return (Document*)[[self window] delegate];
}

- (void) mouseDown:(NSEvent *)theEvent
{
    displayPvs = YES;
    [self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent *)theEvent
{
    displayPvs = NO;
    [self setNeedsDisplay:YES];
}

- (void) mouseDragged:(NSEvent *)theEvent
{
    pt = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    NSLog(@"[%f, %f]", pt.x, pt.y);
    [self setNeedsDisplay:YES];
}

- (void) drawTree:(const pvs::LineNode*) tree
{
    pvs::Point mid;
    tree->line().atT(0.5, mid);
    
    pvs::Line n = tree->line().normal();
    [NSBezierPath strokeLineFromPoint:toNSPoint(tree->line().start())
                              toPoint:toNSPoint(tree->line().end())];
    
    [NSBezierPath strokeLineFromPoint:toNSPoint(n.start() + mid)
                              toPoint:toNSPoint(n.end() + mid)];
    if (tree->left()) {
        [[NSColor blueColor] setStroke];
        [self drawTree:tree->left()];
    }
    
    if (tree->right()) {
        [[NSColor redColor] setStroke];
        [self drawTree:tree->right()];
    }
    
}

- (void) drawHierarchy:(const pvs::LineNode*) tree
{
    pvs::Point start, end;
    tree->line().atT(0.5, start);
    if (tree->left()) {
        tree->left()->line().atT(0.5, end);
        [NSBezierPath strokeLineFromPoint:toNSPoint(start)
                                  toPoint:toNSPoint(end)];

        
        [self drawHierarchy:tree->left()];
    }
    
    if (tree->right()) {
        tree->right()->line().atT(0.5, end);
        [NSBezierPath strokeLineFromPoint:toNSPoint(start)
                                  toPoint:toNSPoint(end)];
        
        [self drawHierarchy:tree->right()];
    }
}

- (void) drawFullTree {
    
    float lineWidth = [NSBezierPath defaultLineWidth];
    
    [NSBezierPath setDefaultLineWidth:4.0f];
    const pvs::LineNode* tree = [[self document] bspTree];
    if (tree) {
        [[NSColor yellowColor] setStroke];
        [self drawTree:tree];
    }
    [NSBezierPath setDefaultLineWidth:lineWidth];
    
    if (tree) {
        [self drawHierarchy:tree];
    }
}

- (void) drawVisibleTree:(const pvs::LineNode*) tree
{
    if (tree->line().isBehind(pvs::Point(pt.x, pt.y))) {
        [NSBezierPath strokeLineFromPoint:toNSPoint(tree->line().start())
                                  toPoint:toNSPoint(tree->line().end())];
    }
    
    if (tree->left()) {
        [self drawVisibleTree:tree->left()];
    }
    
    if (tree->right()) {
        [self drawVisibleTree:tree->right()];
    }
}

- (void) drawPvs {
    const pvs::LineNode* tree = [[self document] bspTree];
    if (tree) {
        [self drawVisibleTree:tree];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    if (displayPvs) {
        [self drawPvs];
    } else {
        [self drawFullTree];
    }
}

@end
