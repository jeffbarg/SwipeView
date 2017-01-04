//
//  Extensions.swift
//  PileView
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

extension CGRect {
    func extendOutOfBounds(_ bounds : CGRect, translationVector : CGPoint) -> CGRect {
        var result = self;
        while (!result.intersection(bounds).isNull) {
            result = result + translationVector
        }
        
        return result
    }
}

extension CGFloat {
    var toRadians : CGFloat { return self * 3.14159265 / 180.0 }
}

func + (left : CGRect, right : CGPoint) -> CGRect {
    return left.offsetBy(dx: right.x, dy: right.y)
}

func + (left : CGPoint, right : CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left : CGPoint, right : CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
