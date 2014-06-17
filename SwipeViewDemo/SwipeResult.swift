//
//  SwipeResult.swift
//  Tinder
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

enum SwipeDirection {
    case None
    case Left
    case Right
}

class SwipeResult: NSObject {
    var view : UIView?
    var translation : CGPoint
    var direction : SwipeDirection
    var onCompletion : () -> ()
    
    init() {
        translation = CGPoint(x: 0, y: 0)
        direction = SwipeDirection.None
        onCompletion = {}
    }
}
