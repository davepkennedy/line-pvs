//
//  Line.h
//  line-pvs
//
//  Created by Dave Kennedy on 14/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#ifndef __line_pvs__Line__
#define __line_pvs__Line__

#include "Line.h"
#include "Point.h"
#include "Size.h"

namespace pvs
{
    class Line {
    private:
        Point _start;
        Point _end;
    private:
        float numerator (const Line& target) const;
        float denominator(const Line& target) const;
    public:
        inline bool operator == (const Line& other) const {
            return (start() == other.start()) &&
                    (end() == other.end());
        }
    public:
        Line (Point start, Point end);
        Line (float sx, float sy, float ex, float ey);
        inline Point start() const {return _end;}
        inline Point end() const {return _start;}
        Line normal() const;
        Size vector() const;
        Line unit() const;
        float length() const {
            return vector().magnitude();
        }
        bool atT(float t, Point& pt) const;
        
        bool split(const pvs::Line& target, float& t) const;
        bool isBehind(const Point& pt) const;
    };
}

#endif /* defined(__line_pvs__Line__) */
