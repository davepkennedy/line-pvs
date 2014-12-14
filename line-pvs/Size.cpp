//
//  Size.cpp
//  line-pvs
//
//  Created by Dave Kennedy on 14/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#include "Size.h"

#include <math.h>

using namespace pvs;

Size::Size(float cx, float cy)
: _cx(cx)
, _cy(cy)
{
    
}

Size::Size(const Size& other)
: _cx(other.cx())
, _cy(other.cy())
{
    
}

Size::Size(const Point& pt)
: _cx (pt.x())
, _cy (pt.y())
{
    
}

float Size::magnitude() const
{
    return sqrtf((cx() * cx()) + (cy() * cy()));
}