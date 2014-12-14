//
//  Line.cpp
//  line-pvs
//
//  Created by Dave Kennedy on 14/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#include "Line.h"

using namespace pvs;

Line::Line(Point start, Point end)
: _start(start), _end(end)
{
}

Line::Line(float sx, float sy, float ex, float ey)
: _start(sx,sy), _end(ex,ey)
{
}

Line Line::normal() const
{
    Size v = vector();
    return Line(-v.cy(),v.cx(),v.cy(),-v.cx());
}

Size Line::vector() const
{
    return Size(end().x() - start().x(), end().y() - start().y());
}

bool Line::atT(float t, Point& pt) const
{
    if (t < 0 || t > 1) {
        return false;
    }
    
    float dx = _end.x() - _start.x();
    float dy = _end.y() - _start.y();
    
    pt = Point(_end.x() - (dx * t), _end.y() - (dy * t));
    
    return true;
}

bool split(const Line& pivot, const Line& target, float& t)
{
    if (pivot.vector() == target.vector()) {
        return false;
    }
    
    if (target.length()) {
        Size N = pivot.normal().vector();
        Size D = target.vector();
        float nNdD = (-N).dot(D);
        if (nNdD == 0) {
            return false;
        }
        t = (N.dot(target.start() - pivot.end())) / nNdD;
        return true;
    }
    return false;
}