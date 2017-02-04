//
//  Extension.swift
//  MarsArchive
//
//  Created by Haven Barnes on 2/4/17.
//  Copyright © 2017 Azing. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    func instantiate(_ storyboard: String, identifier: String) -> UIViewController {
        
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: identifier)
        return viewController
        
    }
    
}

extension UIColor {
    /**
     Converts a color hex code in String form to a UIColor object
     
     To use it, simply call UIColor.from(#FFFFFF) or UIColor.from(FFFFFF)
     
     - parameter hex: The input value representing the hex value of the color desired
     
     - returns:   UIColor The representation of the hex color input
     */
    static func from(string hex:String) -> UIColor {
        var cString: String = hex
        if (cString.hasPrefix("#")) {
            cString = cString.substring(from: cString.characters.index(cString.startIndex, offsetBy: 1))
        }
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    /**
     Converts a UIColor object to a string with it's hex code representation
     
     
     - parameter color: The input UIColor object representing the desired color
     
     - returns:   String The representation of the color in hexadecimal
     */
    static func hexFrom(_ color: UIColor) -> String {
        let hexString = String(format: "%02X%02X%02X",
                               Int((color.cgColor.components?[0])! * 255.0),
                               Int((color.cgColor.components?[1])! * 255.0),
                               Int((color.cgColor.components?[2])! * 255.0))
        return hexString
    }
    
    func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        } else {
            return nil
        }
    }
    
    /**
     Adjusts the hue of the UIColor by the desired value and returns a new UIColor
     
     - Parameter degree: Amount (in degrees) to adjust hue.
     
     - Returns: Color with adjusted hue.
     */
    func adjustHue(by degree: CGFloat) -> UIColor {
        var hue: CGFloat = 0.0, sat: CGFloat = 0.0, brightness: CGFloat = 0.0, alpha: CGFloat = 0.0
        var adjustedHue = degree / 360
        
        self.getHue(&hue, saturation: &sat, brightness: &brightness, alpha: &alpha)
        
        adjustedHue = hue + adjustedHue
        
        if !((0.0..<1.0).contains(adjustedHue)) {
            adjustedHue = abs(1 - abs(adjustedHue))
        }
        
        return UIColor(hue: adjustedHue, saturation: sat, brightness: brightness, alpha: alpha)
    }
    
    /**
     Creates a three color gradient from a single color.
     
     - Parameter bounds: The bounds of the gradent.
     
     - Returns: CAGradientLayer with three colors.
     */
    func gradientFromColor(bounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        
        
        let color1 = self.adjustHue(by: 30)
        let color2 = self
        let color3 = self.adjustHue(by: -30)
        gradient.colors = [color1.cgColor, color2.cgColor, color3.cgColor]
        
        //        gradient.startPoint = CGPoint(x: 0, y: 0)
        //        gradient.endPoint = CGPoint(x: 1, y: 1)
        
        gradient.startPoint = CGPoint(x: 0, y: 0.3)
        gradient.endPoint = CGPoint(x: 1, y: 0.8)
        
        gradient.frame = bounds
        
        return gradient
    }
}
