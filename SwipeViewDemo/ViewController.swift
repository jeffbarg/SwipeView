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
        Person(name: "Finn", image: UIImage(named: "finn")!),
        Person(name: "Jake", image: UIImage(named: "jake")!),
        Person(name: "Fiona", image: UIImage(named: "fiona")!),
        Person(name: "Prince", image: UIImage(named: "prince")!),
        Person(name: "Finn", image: UIImage(named: "finn")!),
        Person(name: "Jake", image: UIImage(named: "jake")!),
        Person(name: "Fiona", image: UIImage(named: "fiona")!),
        Person(name: "Prince", image: UIImage(named: "prince")!),
        Person(name: "Finn", image: UIImage(named: "finn")!),
        Person(name: "Jake", image: UIImage(named: "jake")!),
        Person(name: "Fiona", image: UIImage(named: "fiona")!),
        Person(name: "Prince", image: UIImage(named: "prince")!),
        Person(name: "Finn", image: UIImage(named: "finn")!),
        Person(name: "Jake", image: UIImage(named: "jake")!),
        Person(name: "Fiona", image: UIImage(named: "fiona")!),
        Person(name: "Prince", image: UIImage(named: "prince")!),
        Person(name: "Finn", image: UIImage(named: "finn")!),
        Person(name: "Jake", image: UIImage(named: "jake")!),
        Person(name: "Fiona", image: UIImage(named: "fiona")!),
        Person(name: "Prince", image: UIImage(named: "prince")!),
        Person(name: "Finn", image: UIImage(named: "finn")!),
        Person(name: "Jake", image: UIImage(named: "jake")!),
        Person(name: "Fiona", image: UIImage(named: "fiona")!),
        Person(name: "Prince", image: UIImage(named: "prince")!),
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pileView = PileView(frame: self.frontCardViewFrame())
        pileView.popCardViewWithFrame = self.popCardViewWithFrame
        
        pileView.reloadContent()
        
        self.view.addSubview(pileView)
        
        self.view.backgroundColor = UIColor.white
    }
    
    func popCardViewWithFrame(_ frame : CGRect) -> UIView? {
        if (people.count == 0) {
            return nil
        }
        
        let p : Person = people.removeLast()
        
        let imageView = UIImageView()
        
        imageView.image = p.image
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.clipsToBounds = true
            
        return imageView
    }
    
    func tappedImageView(_ sender : AnyObject) -> () {
        if let imageView = sender as? UIView {
            UIView.animate(withDuration: 0.5, animations: {
                imageView.alpha = 0
                imageView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
            })
        }
    }
    
    func frontCardViewFrame () -> CGRect {
        let horizontalPadding : CGFloat = 15
        let topPadding : CGFloat = 120
        let bottomPadding : CGFloat = 120
        
        return CGRect(x: horizontalPadding,
            y: topPadding,
            width: self.view.frame.width - (horizontalPadding * 2),
            height: self.view.frame.height - (bottomPadding) - (topPadding))
    }
    
    override func viewDidAppear(_ animated: Bool)  {
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
