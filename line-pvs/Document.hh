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

@interface Document : NSDocument {
    std::vector<pvs::Line> _lines;
}
- (void) startLine: (NSPoint) point;
- (void) endLine: (NSPoint) point;
- (std::vector<pvs::Line>&) lines;

@end

