//
//  Extenisons.swift
//  iOS challenge
//
//  Created by Denis Prša on 8. 10. 16.
//  Copyright © 2016 Denis Prša. All rights reserved.
//

import UIKit

extension UIImageView{
    
    func blurImage(alpha: Double)
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
    
}
