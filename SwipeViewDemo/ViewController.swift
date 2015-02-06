//
//  ViewController.swift
//  Tinder
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var people : [Person] = [
        Person(name: "Finn", image: UIImage(named: "finn")),
        Person(name: "Jake", image: UIImage(named: "jake")),
        Person(name: "Fiona", image: UIImage(named: "fiona")),
        Person(name: "Prince", image: UIImage(named: "prince")),
        Person(name: "Finn", image: UIImage(named: "finn")),
        Person(name: "Jake", image: UIImage(named: "jake")),
        Person(name: "Fiona", image: UIImage(named: "fiona")),
        Person(name: "Prince", image: UIImage(named: "prince")),
        Person(name: "Finn", image: UIImage(named: "finn")),
        Person(name: "Jake", image: UIImage(named: "jake")),
        Person(name: "Fiona", image: UIImage(named: "fiona")),
        Person(name: "Prince", image: UIImage(named: "prince")),
        Person(name: "Finn", image: UIImage(named: "finn")),
        Person(name: "Jake", image: UIImage(named: "jake")),
        Person(name: "Fiona", image: UIImage(named: "fiona")),
        Person(name: "Prince", image: UIImage(named: "prince")),
        Person(name: "Finn", image: UIImage(named: "finn")),
        Person(name: "Jake", image: UIImage(named: "jake")),
        Person(name: "Fiona", image: UIImage(named: "fiona")),
        Person(name: "Prince", image: UIImage(named: "prince")),
        Person(name: "Finn", image: UIImage(named: "finn")),
        Person(name: "Jake", image: UIImage(named: "jake")),
        Person(name: "Fiona", image: UIImage(named: "fiona")),
        Person(name: "Prince", image: UIImage(named: "prince")),
    ]
    
    required init(coder aDecoder: NSCoder!) {
        super.init(coder: aDecoder)
    }
    
    override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pileView = PileView(frame: self.frontCardViewFrame())
        pileView.popCardViewWithFrame = self.popCardViewWithFrame
        
        pileView.reloadContent()
        
        self.view.addSubview(pileView)
        
        self.view.backgroundColor = UIColor.whiteColor()
    }
    
    func popCardViewWithFrame(frame : CGRect) -> UIView? {
        if (people.count == 0) {
            return nil
        }
        
        let p : Person = people.removeLast()
        
        var imageView = UIImageView()
        
        imageView.image = p.image
        imageView.contentMode = UIViewContentMode.ScaleAspectFill
        imageView.clipsToBounds = true
            
        return imageView
    }
    
    func tappedImageView(sender : AnyObject) -> () {
        if let imageView = sender as? UIView {
            UIView.animateWithDuration(0.5, animations: {
                imageView.alpha = 0
                imageView.transform = CGAffineTransformMakeScale(0.01, 0.01)
            })
        }
    }
    
    func frontCardViewFrame () -> CGRect {
        let horizontalPadding : CGFloat = 15
        let topPadding : CGFloat = 120
        let bottomPadding : CGFloat = 120
        
        return CGRectMake(horizontalPadding,
            topPadding,
            CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
            CGRectGetHeight(self.view.frame) - (bottomPadding) - (topPadding))
    }
    
    override func viewDidAppear(animated: Bool)  {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
