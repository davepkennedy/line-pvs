//
//  LinesView.m
//  line-pvs
//
//  Created by Dave Kennedy on 12/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#import "LinesView.hh"
#import "Document.h"
#import "Line.h"

#include <math.h>

@implementation LinesView

static NSPoint start;
static NSPoint end;

static NSPoint toNSPoint (pvs::Point pt) {
    return CGPointMake(pt.x(), pt.y());
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (void) drawGrid: (NSRect) rect {
    [[NSColor lightGrayColor] setStroke];
    
    for (int i = 0; i < rect.size.width; i += 10) {
        [NSBezierPath strokeLineFromPoint:CGPointMake(i,0) toPoint:CGPointMake(i, rect.size.height)];
    }
    for (int i = 0; i < rect.size.height; i += 10) {
        [NSBezierPath strokeLineFromPoint:CGPointMake(0,i) toPoint:CGPointMake(rect.size.width, i)];
    }
}

- (void) drawLine:(const pvs::Line&) line {
    [NSBezierPath strokeLineFromPoint:toNSPoint(line.start())
                              toPoint:toNSPoint(line.end())];
}

- (void) drawLines: (const std::vector<pvs::Line>&) lines {
    for (std::vector<pvs::Line>::const_iterator line = lines.begin();
         line != lines.end(); line++) {
        
        pvs::Line n = line->normal();
        pvs::Point pt;
        line->atT(0.5, pt);
        
        [self drawLine:(*line)];
        [self drawLine:pvs::Line(n.start() + pt, n.end() + pt)];
    }
}

- (void) drawCircle: (NSPoint) center {
    float radius = 10;
    [[NSBezierPath bezierPathWithOvalInRect:CGRectMake(
                                                      center.x - (radius/2),
                                                      center.y - (radius/2),
                                                      radius,
                                                      radius)] fill];
}

- (void) drawStart:(pvs::Point)pt {
    [[NSColor greenColor] setFill];
    [[NSColor greenColor] setStroke];
    [self drawCircle:toNSPoint(pt)];
}

- (void) drawEnd:(pvs::Point)pt {
    [[NSColor redColor] setFill];
    [[NSColor redColor] setStroke];
    [self drawCircle:toNSPoint(pt)];
}

- (void) drawDots: (const std::vector<pvs::Line>&) lines {
    for (std::vector<pvs::Line>::const_iterator line = lines.begin();
         line != lines.end(); line++) {
        [self drawStart:line->start()];
        [self drawEnd:line->end()];
        
    }
}

- (void)drawCurrentLineset {
    [[NSColor blackColor] setStroke];
    [NSBezierPath strokeLineFromPoint:start toPoint:end];
    Document* doc = (Document*)[[self window] delegate];
    [self drawLines:[doc lines]];
    
    [self drawLine:pvs::Line(start.x, start.y, end.x, end.y)];
    [self drawDots:[doc lines]];
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
    [self drawGrid:dirtyRect];
    [self drawCurrentLineset];
}

NSPoint clampPoint (NSPoint point) {
    int x = round(point.x / 10) * 10;
    int y = round(point.y / 10) * 10;
    return CGPointMake(x, y);
}

- (void) mouseDown:(NSEvent *)theEvent {
    Document* doc = (Document*)[[self window] delegate];
    start = end = clampPoint([self convertPoint:[theEvent locationInWindow] fromView:nil]);
    [doc startLine:start];
    [self setNeedsDisplay:YES];
}

- (void) mouseDragged:(NSEvent *)theEvent {
    end = clampPoint([self convertPoint:[theEvent locationInWindow] fromView:nil]);
    
    [self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent *)theEvent {
    Document* doc = (Document*)[[self window] delegate];
    //end = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    [doc endLine:end];
    [self setNeedsDisplay:YES];
}

@end
