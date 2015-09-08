//
//  ColorPalette.swift
//  Kettebel
//
//  Created by Duy Bao Nguyen on 9/8/15.
//  Copyright (c) 2015 Duy Bao Nguyen. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int, _alpha: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(_alpha) / 255.0)
    }
    
    convenience init(rgba:Int) {
        if (rgba > 0xffffff) {
            self.init(red:(rgba >> 24) & 0xff, green:(rgba >> 16) & 0xff, blue:(rgba >> 8) & 0xff, _alpha : rgba & 0xff)
        }
        else {
            self.init(red:(rgba >> 16) & 0xff, green:(rgba >> 8) & 0xff, blue:rgba & 0xff, _alpha : 0xff)
        }
    }
}

struct ColorPalette {
    
    struct Green {
        static let Light = UIColor(rgba: 0x56BFB5)
        static let Dark = UIColor(rgba: 0x38817A)
    }
}