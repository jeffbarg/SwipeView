//
//  SwipeViewState.swift
//  PileView
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

enum RotationDirection {
    case rotationTowardsCenter
    case rotationAwayFromCenter
}

class SwipeViewState {
    var originalCenter : CGPoint
    
    /*
    * When the pan gesture originates at the top half of the view, the view rotates
    * away from its original center, and this property takes on a value of 1.
    *
    * When the pan gesture originates at the bottom half, the view rotates toward its
    * original center, and this takes on a value of -1.
    */
    var rotationDirection : RotationDirection;
    
    init() {
        self.originalCenter = CGPoint(x: 0, y: 0)
        self.rotationDirection = .rotationTowardsCenter
    }
}
