//
//  PanState.swift
//  PileView
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

class PanState {
    var direction : SwipeDirection
    var view : UIView
    var thresholdRatio : CGFloat
    
    init(direction: SwipeDirection, view: UIView, thresholdRatio : CGFloat) {
        self.direction = direction
        self.view = view
        self.thresholdRatio = thresholdRatio
    }
}