//
//  LinesView.m
//  line-pvs
//
//  Created by Dave Kennedy on 12/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#import "LinesView.hh"
#import "Document.hh"
#import "Line.h"

#include <math.h>

@implementation LinesView

static NSPoint start;
static NSPoint end;

NSPoint toNSPoint (pvs::Point pt) {
    return CGPointMake(pt.x(), pt.y());
}

- (BOOL) acceptsFirstResponder {
    return YES;
}

- (void) drawGrid: (NSRect) rect {
    NSLog(@"Start [%f,%f], End [%f,%f]", start.x, start.y, end.x, end.y);
    [[NSColor lightGrayColor] setStroke];
    
    for (int i = 0; i < rect.size.width; i += 10) {
        [NSBezierPath strokeLineFromPoint:CGPointMake(i,0) toPoint:CGPointMake(i, rect.size.height)];
    }
    for (int i = 0; i < rect.size.height; i += 10) {
        [NSBezierPath strokeLineFromPoint:CGPointMake(0,i) toPoint:CGPointMake(rect.size.width, i)];
    }
}

- (void) drawLines: (const std::vector<pvs::Line>&) lines {
    for (std::vector<pvs::Line>::const_iterator line = lines.begin();
         line != lines.end(); line++) {
        
        [NSBezierPath strokeLineFromPoint:toNSPoint(line->start())
                                  toPoint:toNSPoint(line->end())];
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

- (void) drawDots: (const std::vector<pvs::Line>&) lines {
    [[NSColor greenColor] setFill];
    [[NSColor greenColor] setStroke];
    for (std::vector<pvs::Line>::const_iterator line = lines.begin();
         line != lines.end(); line++) {
        [self drawCircle:toNSPoint(line->start())];
    }
    
    [[NSColor redColor] setFill];
    [[NSColor redColor] setStroke];
    for (std::vector<pvs::Line>::const_iterator line = lines.begin();
         line != lines.end(); line++) {

        [self drawCircle:toNSPoint(line->end())];
    }
}

- (void) drawLine: (const pvs::Line&) pivot
        splitting: (const std::vector<pvs::Line>&) lines
{
    [[NSColor orangeColor] setFill];
    [[NSColor orangeColor] setStroke];
    
    for (std::vector<pvs::Line>::const_iterator line = lines.begin();
         line != lines.end(); line++) {
        float t;
        pvs::Point pt;
        if (split(pivot, *line, t)) {
            NSLog(@"Pivot split a line");
            if (line->atT(t, pt)) {
                NSLog(@"T-point lies on line");
                [self drawCircle:toNSPoint(pt)];
            }
        }
        [self drawCircle:toNSPoint(line->start())];
    }
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSLog(@"Dirty rect: [%f,%f,%f,%f]", dirtyRect.origin.x, dirtyRect.origin.y, dirtyRect.size.width, dirtyRect.size.height);
    
    // Drawing code here.
    [self drawGrid:dirtyRect];
    
    [[NSColor blackColor] setStroke];
    [NSBezierPath strokeLineFromPoint:start toPoint:end];
    Document* doc = (Document*)[[self window] delegate];
    [doc lines];
    [self drawLines:[doc lines]];
    [self drawDots:[doc lines]];
    
    [self drawLine: pvs::Line(start.x, start.y, end.x, end.y)
         splitting: [doc lines]];
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
    NSLog(@"Start(%f,%f)", start.x, start.y);
    [self setNeedsDisplay:YES];
}

- (void) mouseDragged:(NSEvent *)theEvent {
    end = clampPoint([self convertPoint:[theEvent locationInWindow] fromView:nil]);
    
    NSLog(@"Move(%f,%f)", end.x, end.y);
    [self setNeedsDisplay:YES];
}

- (void) mouseUp:(NSEvent *)theEvent {
    Document* doc = (Document*)[[self window] delegate];
    //end = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    
    NSLog(@"Move(%f,%f)", end.x, end.y);
    [doc endLine:end];
    [self setNeedsDisplay:YES];
}

@end
