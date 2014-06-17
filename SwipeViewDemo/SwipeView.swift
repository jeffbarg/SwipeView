//
//  SwipeView.swift
//  Tinder
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

class SwipeView: UIView {
    
    var options : SwipeOptions = SwipeOptions()
    var viewState : SwipeViewState = SwipeViewState()
    
    //Delegate Functions
    var viewDidCancelSwipe : ((UIView) -> ())?
    var viewWasChosenWithDirection : ((UIView, SwipeDirection) -> ())?
    
    init(frame: CGRect, options : SwipeOptions) {

        super.init(frame: frame)
        
        self.options = options
        
        self.setupView()
        self.setupSwipe()
    }

    func setupView() {
        self.backgroundColor = UIColor.whiteColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.clipsToBounds = true
    }
    
    func setupSwipe() {
        self.viewState.originalCenter = self.center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("onSwipe:"))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    func onSwipe(panGestureRecognizer : UIPanGestureRecognizer!) {
        let view = panGestureRecognizer.view
        
        switch (panGestureRecognizer.state) {
        case UIGestureRecognizerState.Began:
            if (panGestureRecognizer.locationInView(view).y < view.center.y) {
                self.viewState.rotationDirection = .RotationAwayFromCenter
            } else {
                self.viewState.rotationDirection = .RotationTowardsCenter
            }
        case UIGestureRecognizerState.Ended:
            self.finalizePosition()
        default:
            let translation : CGPoint = panGestureRecognizer.translationInView(view)
            view.center = self.viewState.originalCenter + translation
            self.rotateForTranslation(translation, withRotationDirection: self.viewState.rotationDirection)
        }
    }
    
    func rotateForTranslation(translation : CGPoint, withRotationDirection rotationDirection : RotationDirection) {
        var rotation :CGFloat = (translation.x/100 * self.options.rotationFactor).toRadians
        
        switch (rotationDirection) {
        case .RotationAwayFromCenter:
            rotation *= 1
        case .RotationTowardsCenter:
            rotation *= -1
        }
        
        self.transform = CGAffineTransformRotate(CGAffineTransformIdentity, rotation);
    }
    
    func finalizePosition() {
        let direction = self.directionOfExceededThreshold();
        
        switch (direction) {
        case .Left, .Right:
            let translation = self.center - self.viewState.originalCenter;
            self.exitSuperviewFromTranslation(translation)
        case .None:
            self.returnToOriginalCenter()
            self.executeOnPanForTranslation(CGPointZero)
        }
    }
    
    func executeOnPanForTranslation(translation : CGPoint) {
        let thresholdRatio : CGFloat = min(1, fabsf(translation.x)/self.options.threshold);

        var direction = SwipeDirection.None
        if (translation.x > 0) {
            direction = .Right
        } else if (translation.x < 0) {
            direction = .Left
        }
        
        var state = PanState(direction: direction, view: self, thresholdRatio: thresholdRatio)
        self.options.onPan(state)
    }
    
    func returnToOriginalCenter() {
        UIView.animateWithDuration(self.options.swipeCancelledAnimationDuration,
            delay: 0.0,
            options: self.options.swipeCancelledAnimationOptions,
            animations: {
                self.transform = CGAffineTransformIdentity;
                self.center = self.viewState.originalCenter;
            }, completion: {(finished : Bool) -> () in
                if (finished) {
                    self.viewDidCancelSwipe?(self)   
                }
            })
    }

    func exitSuperviewFromTranslation(translation : CGPoint) {
        let direction = self.directionOfExceededThreshold()
        
        var result = SwipeResult()
        result.view = self
        result.translation = translation
        result.direction = direction
        result.onCompletion = {
            self.viewWasChosenWithDirection?(self, direction)
            return
        }
        
        self.options.onChosen(result)
    }

        
    func directionOfExceededThreshold() -> SwipeDirection {
        if (self.center.x > (self.viewState.originalCenter.x + self.options.threshold)) {
            return .Right
        } else if (self.center.x < (self.viewState.originalCenter.x - self.options.threshold)) {
            return .Left
        } else {
            return .None
        }
    }
}
