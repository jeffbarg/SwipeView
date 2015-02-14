//
//  PileView.swift
//  PileView
//
//  Created by Jeff Barg on 6/17/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

class PileView : UIView {
    
    var popCardViewWithFrame : ((CGRect) -> UIView?)?
    var swipeViews : [SwipeView] = []
    
    let transformRatio : CGFloat = 0.96


    
    func reloadContent() {
        if (swipeViews.count >= 4) {
            return
        }
        
        var count = self.swipeViews.count
        for position in count...4{
            let frame = CGRectMake(0, 0, self.frame.width, self.frame.height)
            
            if let view = self.popCardViewWithFrame?(frame) {
                //Wrap view in a SwipeView
                let options = self.optionsForView(view)
                
                let swipeView = SwipeView(frame: frame, contentView: view, options: options)
                swipeView.viewWasChosenWithDirection = {(view : UIView, direction : SwipeDirection) -> () in
                        if (direction == .None) {
                            //Forward to delegate
                            return
                        }
                        
                        let view = self.swipeViews[0]
                        view.removeFromSuperview()
                        self.swipeViews.removeAtIndex(0)
                    
                        //Forward to delegate

                        self.reloadContent()
                }
                
                //Animate insertion
                self.animateCardInsertion(swipeView, atPosition: CGFloat(position))
                
                self.insertSubview(swipeView, atIndex: 0)
                self.swipeViews.append(swipeView)

            } else {
                return
            }
        }
    }
    
    func animateCardInsertion(swipeView : SwipeView, atPosition position : CGFloat) {
        let prevCount : CGFloat = 0
        
        let transform = transformForPosition(position)
        let frame = swipeView.frame
        
        let verticalOffset : CGFloat = -50
        swipeView.frame = CGRectOffset(frame, 0, verticalOffset)
        swipeView.alpha = 0
        swipeView.opaque = false
        
        let animationOptions = UIViewAnimationOptions.CurveEaseOut
        let duration : NSTimeInterval = 0.3
        let delay : NSTimeInterval = duration * Double(4 - position) / Double(1.5)
        UIView.animateWithDuration(duration, delay: delay, options: animationOptions, animations: {
            swipeView.frame = frame
            swipeView.transform = transform
            swipeView.alpha = 1
            
            }, completion: {(finished : Bool) -> () in
                if (finished) {
                    swipeView.opaque = true
                }
            })
    }
    func transformForPosition(position : CGFloat) -> CGAffineTransform {
        var transform : CGAffineTransform = CGAffineTransformIdentity
        
        if (self.swipeViews.count > 0) { //Keep transform at identity if first view
            let count = self.swipeViews.count
            
            let scale = CGFloat(powf(Float(transformRatio), Float(position)))

            transform = CGAffineTransformMakeScale(scale, scale)
            
            transform = CGAffineTransformTranslate(transform, 0, -15 * position)
        }
        
        return transform
    }
    
    func optionsForView(view : UIView) -> SwipeOptions {
        var options = SwipeOptions()
        options.onPan = {(panState : PanState) -> () in
            var count = self.swipeViews.count
            for i in 1...count - 1 {
                let swipeView = self.swipeViews[i]
                let ratio = panState.thresholdRatio
                let position = CGFloat(i) - ratio
                let transform = self.transformForPosition(position)
                swipeView.transform = transform
            }
        }
        return options
    }
    
    
}