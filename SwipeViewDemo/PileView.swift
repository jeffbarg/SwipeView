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
    
    override init(frame: CGRect)  {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadContent() {
        if (swipeViews.count >= 4) {
            return
        }
        
        for position in self.swipeViews.count...3 {
            let frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
            if let view = self.popCardViewWithFrame?(frame) {
                //Wrap view in a SwipeView
                let options = self.optionsForView(view)
                
                let swipeView = SwipeView(frame: frame, contentView: view, options: options)
                swipeView.viewWasChosenWithDirection = {(view : UIView, direction : SwipeDirection) -> () in
                        if (direction == .none) {
                            //Forward to delegate
                            return
                        }
                        
                        let view = self.swipeViews[0]
                        view.removeFromSuperview()
                        self.swipeViews.remove(at: 0)
                    
                        //Forward to delegate

                        self.reloadContent()
                }
                
                //Animate insertion
                self.animateCardInsertion(swipeView, atPosition: CGFloat(position))
                
                self.insertSubview(swipeView, at: 0)
                self.swipeViews.append(swipeView)

            } else {
                return
            }
        }
    }
    
    func animateCardInsertion(_ swipeView : SwipeView, atPosition position : CGFloat) {
        let transform = self.transformForPosition(position)
        let frame = swipeView.frame
        
        let verticalOffset : CGFloat = -50
        swipeView.frame = frame.offsetBy(dx: 0, dy: verticalOffset)
        swipeView.alpha = 0
        swipeView.isOpaque = false
        
        let animationOptions = UIViewAnimationOptions.curveEaseOut
        let duration : TimeInterval = 0.3
        let delay : TimeInterval = duration * Double(4 - position) / Double(1.5)
        UIView.animate(withDuration: duration, delay: delay, options: animationOptions, animations: {
            swipeView.frame = frame
            swipeView.transform = transform
            swipeView.alpha = 1
            
            }, completion: {(finished : Bool) -> () in
                if (finished) {
                    swipeView.isOpaque = true
                }
            })
    }
    func transformForPosition(_ position : CGFloat) -> CGAffineTransform {
        var transform : CGAffineTransform = CGAffineTransform.identity
        
        if (self.swipeViews.count > 0) { //Keep transform at identity if first view
            let scale = pow(transformRatio, position)
            transform = CGAffineTransform(scaleX: scale, y: scale)
            
            transform = transform.translatedBy(x: 0, y: -15 * position)
        }
        
        return transform
    }
    
    func optionsForView(_ view : UIView) -> SwipeOptions {
        let options = SwipeOptions()
        options.onPan = {(panState : PanState) -> () in
            for i in 1 ..< self.swipeViews.count {
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
