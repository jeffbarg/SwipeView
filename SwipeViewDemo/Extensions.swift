//
//  Extensions.swift
//  PileView
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

extension CGRect {
    func extendOutOfBounds(bounds : CGRect, translationVector : CGPoint) -> CGRect {
        var result = self;
        while (!CGRectIsNull(CGRectIntersection(result, bounds))) {
            result = result + translationVector
        }
        
        return result
    }
}

extension CGFloat {
    var toRadians : CGFloat { return self * 3.14159265 / 180.0 }
}

func + (left : CGRect, right : CGPoint) -> CGRect {
    return CGRectOffset(left, right.x, right.y)
}

func + (left : CGPoint, right : CGPoint) -> CGPoint {
    return CGPointMake(left.x + right.x, left.y + right.y)
}

func - (left : CGPoint, right : CGPoint) -> CGPoint {
    return CGPointMake(left.x - right.x, left.y - right.y)
}
