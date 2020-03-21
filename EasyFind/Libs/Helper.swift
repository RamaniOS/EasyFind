//
//  Helper.swift
//  EasyFind
//
//  Created by Ramanpreet Singh on 2020-03-18.
//  Copyright © 2020 Ramanpreet Singh. All rights reserved.
//

import Foundation
import UIKit

/// Class responsible to perform some common functionality
class Helper {
    
    // MARK: Set gradient color for button
    static func applyGradient(to button: UIButton) {
        let layer = CAGradientLayer()
        layer.name = "CAGradientLayer"
        layer.frame.size = button.frame.size
        layer.frame.origin = CGPoint(x: 0, y: 0)
        let color0 = UIColor(red:0.01, green:0.66, blue:0.96, alpha:1.00).cgColor
        let color1 = UIColor(red:0.01, green:0.53, blue:0.82, alpha:1.00).cgColor
        layer.startPoint = CGPoint(x: 0.0, y: 0.5)
        layer.endPoint = CGPoint(x: 1.0, y: 0.5)
        layer.colors = [color0, color1]
        button.layer.insertSublayer(layer, at: 0)
    }
    
    // MARK: Set Left padding for array of UITextField
    static func setLeftPadding(textFields textF: [UITextField], _ size: CGFloat) {
        for field in textF {
            field.setLeftPading(size)
        }
    }
    
    // MARK: Set border for array of UITextField
    static func setBorder(for views: [UITextField]) {
        for view in views {
            view.addBorder(radius: 7, width: 1, color: UIColor.lightGray.cgColor)
        }
    }
}
