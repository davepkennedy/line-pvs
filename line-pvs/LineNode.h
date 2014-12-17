//
//  LineNode.h
//  line-pvs
//
//  Created by Dave Kennedy on 16/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#ifndef __line_pvs__LineNode__
#define __line_pvs__LineNode__

#include "Line.h"
#include <vector>

namespace pvs {
    typedef void(*visitor_t)(const Line&, void*);
    class LineNode {
    private:
        Line _line;
        const LineNode* _left;
        const LineNode* _right;
    public:
        LineNode(const Line& line, const LineNode* left, const LineNode* right);
        ~LineNode();
        const Line& line() const {return _line;}
        const LineNode* left() const {return _left;}
        const LineNode* right() const {return _right;}
        void visit (visitor_t visitor, void* data) const;
    };
}

const pvs::LineNode* compile (const std::vector<pvs::Line>& lines);

#endif /* defined(__line_pvs__LineNode__) */
