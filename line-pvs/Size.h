//
//  Size.h
//  line-pvs
//
//  Created by Dave Kennedy on 14/12/2014.
//  Copyright (c) 2014 Dave Kennedy. All rights reserved.
//

#ifndef __line_pvs__Size__
#define __line_pvs__Size__

#include "point.h"

namespace pvs
{
    class Size {
    private:
        float _cx;
        float _cy;
    public:
        Size(float cx, float cy);
        Size(const Size& other);
        Size(const Point& pt);
        inline float cx() const {return _cx;}
        inline float cy() const {return _cy;}
        inline float dot (const Size& other) const
        {
            return (cx() * other.cx()) + (cy() * other.cy());
        }
        inline bool operator== (const Size& other) {
            return ((cx() == other.cx()) && (cy() == other.cy()));
        }
        
        float magnitude() const;
        Size operator- () const {return Size(-cx(), -cy());}
    };
}
#endif /* defined(__line_pvs__Size__) */
