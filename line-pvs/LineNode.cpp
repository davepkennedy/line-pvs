//
//  LineNode.cpp
//  line-pvs
//
//  Created by Dave Kennedy on 16/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#include "LineNode.h"
#include <cmath>

using namespace pvs;
using namespace std;

LineNode::LineNode(const Line& line, const LineNode* left, const LineNode* right)
: _line(line)
, _left(left)
, _right(right)
{
    
}

LineNode::~LineNode()
{
    if (_left)
    {
        delete _left;
    }
    
    if (_right) {
        delete _right;
    }
}


void LineNode::visit (visitor_t visitor, void* data) const {
    if (_left)
    {
        _left->visit(visitor, data);
    }
    visitor(_line, data);
    if (_right)
    {
        _right->visit(visitor, data);
    }
}

static float numerator (const Line& pivot, const Line& candidate)
{
    Size N = pivot.normal().vector();
    return N.dot(candidate.start() - pivot.start());
}

static float denominator (const Line& pivot, const Line& candidate)
{
    Size N = pivot.normal().vector();
    return (-N).dot(candidate.vector());
}

static float balance (const Line& pivot, const vector<Line>& lines)
{
    int frontLines = 1;
    int backLines = 1;
    for (vector<Line>::const_iterator line = lines.begin();
         line != lines.end(); line++)
    {
        if (pivot == (*line)) {
            continue;
        }
        float n = numerator(pivot, *line);
        float d = denominator(pivot, *line);
        if (d == 0) {
            if (n < 0.0) {
                frontLines++;
            } else {
                backLines++;
            }
        }
    }
    return fmin(frontLines, backLines) / fmax(frontLines, backLines);
}

static Line chooseSplitter (const vector<Line>& lines)
{
    Line splitter = lines[0];
    float bestBalance = balance(splitter, lines);
    
    for (vector<Line>::const_iterator line = lines.begin();
         line != lines.end(); line++) {
        float b = balance(*line, lines);
        if (b > bestBalance) {
            bestBalance = b;
            splitter = *line;
        }
    }
    return splitter;
}

const LineNode* compile (const vector<Line>& lines)
{
    if (lines.size() == 0) {
        return nullptr;
    }
    
    if (lines.size() == 0) {
        return new LineNode (lines[0], nullptr, nullptr);
    }
    
    const Line& currentLine = chooseSplitter(lines);
    vector<Line> frontLines;
    vector<Line> backLines;
    
    for (vector<Line>::const_iterator line = lines.begin();
         line != lines.end(); line++)
    {
        if (currentLine == (*line)) {
            continue;
        }
        float n = numerator(currentLine, *line);
        float d = denominator(currentLine, *line);
        if (d == 0) {
            if (n < 0.0) {
                frontLines.push_back(*line);
            } else {
                backLines.push_back(*line);
            }
        } else {
            float tintersect = n / d;
            if( tintersect > 0.0 and tintersect <1.0 ) {
                Point mid;
                line->atT(tintersect, mid);
                
                if (n < 0.0) {
                    frontLines.push_back(Line(line->start(), mid));
                    backLines.push_back(Line(mid, line->end()));
                } else {
                    backLines.push_back(Line(line->start(), mid));
                    frontLines.push_back(Line(mid, line->end()));
                }
            } else {
                if (n < 0.0) {
                    frontLines.push_back(*line);
                } else {
                    backLines.push_back(*line);
                }
            }
        }
    }
    
    return new LineNode(currentLine, compile(frontLines), compile(backLines));
}