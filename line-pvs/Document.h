//
//  Document.h
//  line-pvs
//
//  Created by Dave Kennedy on 12/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include <vector>
#include "Line.h"
#include "LineNode.h"
#import "LinesView.hh"
#import "BSPView.h"

@interface Document : NSDocument {
    std::vector<pvs::Line> _lines;
    const pvs::LineNode* _bspTree;
    
    IBOutlet LinesView* linesView;
    IBOutlet BSPView* bspView;
}
- (void) startLine: (NSPoint) point;
- (void) endLine: (NSPoint) point;
- (std::vector<pvs::Line>&) lines;
- (const pvs::LineNode*) bspTree;

- (IBAction)compile:(id)sender;

@end

