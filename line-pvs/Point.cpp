//
//  Point.cpp
//  line-pvs
//
//  Created by Dave Kennedy on 14/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#include "Point.h"

using namespace pvs;

Point::Point()
: _x (0), _y(0)
{
}

Point::Point(float x, float y)
: _x(x), _y(y)
{
}

Point::Point(const Point& other)
: _x(other.x()), _y(other.y())
{
}