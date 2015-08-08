//
//  SwipeView.swift
//  PileView
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

class SwipeView: UIView {
    
    var options : SwipeOptions
    var viewState : SwipeViewState = SwipeViewState()
    
    var contentView : UIView
    
    //Delegate Functions
    var viewDidCancelSwipe : ((UIView) -> ())?
    var viewWasChosenWithDirection : ((UIView, SwipeDirection) -> ())?
    
    init(frame: CGRect, contentView: UIView, options : SwipeOptions) {
        contentView.frame = CGRectMake(0, 0, frame.width, frame.height)
        contentView.contentMode = .ScaleToFill
        self.options = options
        self.contentView = contentView
        
        super.init(frame: frame)

        self.setupView()
        self.setupSwipe()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupView() {
        self.backgroundColor = UIColor.clearColor()
        self.layer.cornerRadius = 5
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.clipsToBounds = true
        
        self.addSubview(self.contentView)
    }
    
    func setupSwipe() {
        self.viewState.originalCenter = self.center
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: Selector("onSwipe:"))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    func onSwipe(panGestureRecognizer : UIPanGestureRecognizer!) {
        let view = panGestureRecognizer.view!
        
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
            self.executeOnPanForTranslation(translation)
        }
    }
    
    func rotateForTranslation(translation : CGPoint, withRotationDirection rotationDirection : RotationDirection) {
        var rotation :CGFloat = (translation.x/self.options.threshold * self.options.rotationFactor).toRadians
        
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
        case .Left, .Right, .Up, .Down:
            let translation = self.center - self.viewState.originalCenter;
            self.exitSuperviewFromTranslation(translation)
        case .None:
            self.returnToOriginalCenter()
            self.executeOnPanForTranslation(CGPointZero)
        }
    }
    
    func executeOnPanForTranslation(translation : CGPoint) {
        let thresholdRatio : CGFloat = min(
            1,
            sqrt(
                pow(translation.x, 2) +
                pow(translation.y, 2)
            ) / self.options.threshold * 1.414
        )

        var direction = SwipeDirection.None
        if (translation.x > 0) {
            direction = .Right
        } else if (translation.x < 0) {
            direction = .Left
        }
        
        let state = PanState(direction: direction, view: self, thresholdRatio: thresholdRatio)
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
        
        let result = SwipeResult()
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
        let translation = self.viewState.originalCenter - self.center
        let threshold = self.options.threshold
        
        switch (translation.x, translation.y) {
        case let (x, y) where x < -threshold && abs(y) < threshold:
            return .Left
        case let (x, y) where y < -threshold && abs(x) < threshold:
            return .Down
        case let (x, y) where x > threshold && abs(y) < threshold:
            return .Right
        case let (x, y) where y > threshold && abs(x) < threshold:
            return .Up
        default:
            return .None
        }

//        if (self.center.x > (self.viewState.originalCenter.x + self.options.threshold)) {
//            return .Right
//        } else if (self.center.x < (self.viewState.originalCenter.x - self.options.threshold)) {
//            return .Left
//        } else {
//            return .None
//        }
    }
}
