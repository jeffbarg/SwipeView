//
//  PileView.swift
//  SwipeViewDemo
//
//  Created by Jeff Barg on 6/17/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

class PileView : UIView {
    
    var popCardViewWithFrame : ((CGRect) -> UIView?)?
    var swipeViews : SwipeView[] = []
    
    let transformRatio : CGFloat = 0.96
    
    init(frame: CGRect)  {
        super.init(frame: frame)
    }
    
    func reloadContent() {
        if (swipeViews.count >= 4) {
            return
        }
        
        for i in swipeViews.count..4 {
            let frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
            
            if let view = self.popCardViewWithFrame?(frame) {
                //Wrap view in a SwipeView
                var options = SwipeOptions()
                options.onPan = {(panState : PanState) -> () in
                    for i in 1..self.swipeViews.count {
                        let swipeView = self.swipeViews[i]
                        let ratio = panState.thresholdRatio
                        let position = CGFloat(i) - ratio
                        
                        println(ratio)
                        
                        let scale = powf(self.transformRatio, CGFloat(position))
                        var transform = CGAffineTransformMakeScale(scale, scale)
                        
                        transform = CGAffineTransformTranslate(transform, 0, CGFloat(-15 * position))
                        swipeView.transform = transform
                    }
                }
                
                let swipeView = SwipeView(frame: frame, contentView: view, options: options)
                swipeView.viewWasChosenWithDirection = {(view : UIView, direction : SwipeDirection) -> () in
                        if (direction == .None) {
                            return
                        }
                        
                        println(self.swipeViews)
                        
                        let view = self.swipeViews[0]
                        view.removeFromSuperview()
                        self.swipeViews.removeAtIndex(0)
                        
                        self.reloadContent()
                }
                
                var transform : CGAffineTransform = CGAffineTransformIdentity
                
                if (self.swipeViews.count > 0) { //Keep transform at identity if first view
                    let count = self.swipeViews.count

                    let scale = powf(transformRatio, CGFloat(count))
                    transform = CGAffineTransformMakeScale(scale, scale)
                    
                    transform = CGAffineTransformTranslate(transform, 0, CGFloat(-15 * count))


                }
                
                //Animate insertion
                let verticalOffset : CGFloat = -50
                swipeView.frame = CGRectOffset(frame, 0, verticalOffset)
                swipeView.alpha = 0
                swipeView.opaque = false
                
                let animationOptions = UIViewAnimationOptions.CurveEaseOut
                let duration : NSTimeInterval = 0.3
                let delay : NSTimeInterval = duration * Double(4 - i) / Double(1.5)
                UIView.animateWithDuration(duration, delay: delay, options: animationOptions, animations: {
                    swipeView.frame = frame
                    swipeView.transform = transform
                    swipeView.alpha = 1

                }, completion: {(finished : Bool) -> () in
                    if (finished) {
                        swipeView.opaque = true
                    }
                })
                
                self.insertSubview(swipeView, atIndex: 0)
                self.swipeViews.append(swipeView)

            } else {
                return
            }
        }
        
//        let lastSwipeView = self.swipeViews[self.swipeViews.count - 1]
//        let frame = lastSwipeView.frame
    }
}