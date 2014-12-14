//
//  Point.h
//  line-pvs
//
//  Created by Dave Kennedy on 14/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#ifndef __line_pvs__Point__
#define __line_pvs__Point__

namespace pvs {
    class Point {
    private:
        float _x;
        float _y;
    public:
        Point();
        Point(float x, float y);
        Point(const Point& other);
        inline float x() const {return _x;}
        inline float y() const {return _y;}
        
        inline Point operator- (const Point& other) const {
            return Point(x() - other.x(), y() - other.y());
        }
        
        inline Point operator+ (const Point& other) const {
            return Point(x() + other.x(), y() + other.y());
        }
    };
}

#endif /* defined(__line_pvs__Point__) */
