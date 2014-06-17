//
//  ViewController.swift
//  Tinder
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var frontCardView : SwipeImageView?
    var backCardView : SwipeImageView?
    
    var people : Person[] = [
        Person(name: "Finn", image: UIImage(named: "finn")),
        Person(name: "Jake", image: UIImage(named: "jake")),
        Person(name: "Fiona", image: UIImage(named: "fiona")),
        Person(name: "Prince", image: UIImage(named: "prince")),
    ]
    
    init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        frontCardView = self.popCardViewWithFrame(self.frontCardViewFrame())
        self.view.addSubview(frontCardView)
        
        backCardView = self.popCardViewWithFrame(self.backCardViewFrame())
        self.view.insertSubview(backCardView, belowSubview: frontCardView)
    }
    
    override func viewDidAppear(animated: Bool)  {
    }
    
    func popCardViewWithFrame(frame : CGRect) -> SwipeImageView? {
        let p : Person = people.removeLast()
        return SwipeImageView(frame: frame, image: p.image)
    }
    
    func frontCardViewFrame () -> CGRect {
        let horizontalPadding : CGFloat = 20
        let topPadding : CGFloat = 60
        let bottomPadding : CGFloat = 200

        return CGRectMake(horizontalPadding,
            topPadding,
            CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
            CGRectGetHeight(self.view.frame) - (bottomPadding))
    }
    
    func backCardViewFrame () -> CGRect {
        let frontFrame : CGRect = self.frontCardViewFrame()
        return CGRectOffset(frontFrame, 0, 10)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
