//
//  Line.cpp
//  line-pvs
//
//  Created by Dave Kennedy on 14/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#include "Line.h"
#include <iostream>

using namespace pvs;
using namespace std;

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
    //return Line(-v.cy(),v.cx(),v.cy(),-v.cx());
    return Line(0,0,v.cy(),-v.cx());
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

Line Line::unit() const {
    float dx = _end.x() - _start.x();
    float dy = _end.y() - _start.y();
    float l = length() / 2.0;
    
    return Line(_start.x(), _start.y(),
                _start.x() + (dx / l), _start.y() + (dy / l));
}

float Line::denominator(const Line& target) const {
    return (-normal().vector()).dot(target.vector());
}

float Line::numerator (const Line& target) const {
    return (normal().vector().dot(target.start() - end()));
}

bool Line::split(const Line& target, float& t) const
{
    if (vector() == target.vector()) {
        return false;
    }
    
    if (target.length()) {
        float numer = numerator(target);
        float denom = denominator(target);
        if (denom == 0) {
            return false;
        }
        t = numer / denom;
        return true;
    }
    return false;
}

bool Line::isBehind(const Point& pt) const {
    float b = numerator(Line(start(), pt));
    cerr << "Behindness of (" << pt.x() << "," << pt.y() << ")r is " << b << endl;
    return b < 0;
}