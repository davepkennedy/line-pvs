//
//  Document.m
//  line-pvs
//
//  Created by Dave Kennedy on 12/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#import "Document.h"

@interface Document ()

@end


@implementation Document

NSPoint start;

- (instancetype)init {
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
        //_lines = [[NSMutableArray alloc] init];
        _bspTree = NULL;
    }
    return self;
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController {
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

+ (BOOL)autosavesInPlace {
    return YES;
}

- (NSString *)windowNibName {
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"Document";
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return nil;
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError {
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    [NSException raise:@"UnimplementedMethod" format:@"%@ is unimplemented", NSStringFromSelector(_cmd)];
    return YES;
}

- (std::vector<pvs::Line>&) lines {
    return _lines;
}

- (const pvs::LineNode*) bspTree {
    return _bspTree;
}

- (void) startLine: (NSPoint) point {
    start = point;
}

- (void) endLine: (NSPoint) point {
    _lines.push_back(pvs::Line(start.x, start.y, point.x, point.y));
    [self compile:self];
}


- (IBAction)compile:(id)sender {
    if (_bspTree) {
        delete _bspTree;
    }
    _bspTree = compile (_lines);
    [bspView setNeedsDisplay:YES];
}

@end
