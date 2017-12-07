//
//  canvas.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/18/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import UIKit

class Canvas {
    
    var mainImageView: UIImageView
    var tempImageView: UIImageView

    var primaryColor: CGColor?
    var swath1Color: CGColor?
    var swath2Color: CGColor?
    var interpolated: CGFloat = 0.999
    var opacity: CGFloat = 1.0
    
    init(main: UIImageView, temp: UIImageView) {
        mainImageView = main
        tempImageView = temp
        
        swath1Color = generateColorARGB(1.0, r: 1.0, g: 1.0, b: 1.0)
        swath2Color = generateColorARGB(1.0, r: 0.0, g: 0.0, b: 0.0)
        primaryColor = generateInterpolatedColor(swath1Color!, c2: swath2Color!, t: interpolated)

    }
    
    func merge() {
        // Merge tempImageView into mainImageView
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: mainImageView.frame.size.width, height: mainImageView.frame.size.height), blendMode: CGBlendMode.Normal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
    }
    
    func clear() {
        mainImageView.image = nil
        mainImageView.setNeedsDisplay()
    }
    
    func generateInterpolatedColor(c1: CGColor, c2: CGColor, t: CGFloat) -> CGColor {
        
        var tPrime: CGFloat = t - floor(t)
        if (tPrime < 0) {
            tPrime += 1.0
        }
        
        let components1 = CGColorGetComponents(c1)
        let components2 = CGColorGetComponents(c2)
        
        let components: [CGFloat] = [
            components1[0] + tPrime*(components2[0] - components1[0]),
            components1[1] + tPrime*(components2[1] - components1[1]),
            components1[2] + tPrime*(components2[2] - components1[2]),
            components1[3] + tPrime*(components2[3] - components1[3]),
            ]
        
        return CGColorCreate(CGColorGetColorSpace(c1), components)!
        
    }
    
    func generateColorARGB(alpha: CGFloat, r: CGFloat, g: CGFloat, b: CGFloat) -> CGColor {
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let components: [CGFloat] = [r, g, b, alpha]
        return CGColorCreate(colorSpace, components)!
        
    }
    
}
