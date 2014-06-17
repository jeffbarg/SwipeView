//
//  ChoosePersonView.swift
//  Tinder
//
//  Created by Jeff Barg on 6/16/14.
//  Copyright (c) 2014 Fructose Tech. All rights reserved.
//

import UIKit

class SwipeImageView: SwipeView {
    var imageView : UIImageView = UIImageView()
    
    init(frame: CGRect, image : UIImage) {
        super.init(frame: frame, options: SwipeOptions())
        
        self.autoresizingMask = UIViewAutoresizing.FlexibleHeight |
            UIViewAutoresizing.FlexibleWidth

        
        self.imageView.image = image
        self.imageView.frame = CGRectMake(0,0,self.frame.width, self.frame.width)
        self.imageView.autoresizingMask = self.autoresizingMask;
        self.imageView.clipsToBounds = true
        
        self.addSubview(self.imageView)
    }
}