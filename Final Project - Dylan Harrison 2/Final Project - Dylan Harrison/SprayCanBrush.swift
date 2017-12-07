//
//  SprayCanBrush.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/18/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class SprayCanBrush: BrushType {
    
    var myCanvas: Canvas
    var myBrushName: String
    var myGestureRecognizer: UIGestureRecognizer?
    var myIcon: UIImage
    
    var particleSize: CGFloat = 5.0
    var numParticles: CGFloat = 20.0
    var dispersion: CGFloat = 40.0
    var colorVariance: CGFloat = 0.0
    
    let minParticleSize: CGFloat = 1.0
    let maxParticleSize: CGFloat = 10.0
    let minParticles: CGFloat = 1.0
    let maxParticles: CGFloat = 50.0
    let minDispersion: CGFloat = 0.0
    let maxDispersion: CGFloat = 64.0
    let minColorVariance: CGFloat = 0.0
    let maxColorVariance: CGFloat = 1.0
    
    init(canvas: Canvas) {
        myCanvas = canvas
        myBrushName = "SprayCan"
        myIcon = UIImage(named: "spraypaint-128")!
        myGestureRecognizer = SprayCanGesture()
        (myGestureRecognizer as! SprayCanGesture).setBrush(self)
    }

    
    func spray(point: CGPoint) {
        
        var dx: CGFloat
        var dy: CGFloat
        var dc: CGFloat
        
        var newPoint: CGPoint
        
        UIGraphicsBeginImageContext(myCanvas.mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        myCanvas.tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: myCanvas.mainImageView.frame.size.width, height: myCanvas.mainImageView.frame.size.height))

        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, particleSize)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        for i in 0...Int(numParticles) {
            
            let rnd1 = CGFloat(Double(arc4random())/Double(UInt32.max))
            let rnd2 = CGFloat(Double(arc4random())/Double(UInt32.max))

            dx = rnd2*dispersion*cos(2*CGFloat(M_PI)*rnd1)
            dy = rnd2*dispersion*sin(2*CGFloat(M_PI)*rnd1) //sqrt(1-dx*dx)

            dc = 2*(CGFloat(Double(arc4random())/Double(UInt32.max)) - 0.5)

            dc = (dc*colorVariance + myCanvas.interpolated)
            if dc > 0.99 {
                dc = 0.99
            } else if dc < 0 {
                dc = 0
            }
            
            newPoint = CGPoint(x: point.x+dx, y: point.y+dy)
            
            CGContextMoveToPoint(context, newPoint.x, newPoint.y)
            CGContextAddLineToPoint(context, newPoint.x, newPoint.y)
            
            CGContextSetStrokeColorWithColor(context, myCanvas.generateInterpolatedColor(
                myCanvas.swath1Color!,
                c2: myCanvas.swath2Color!,
                t: dc))

            CGContextStrokePath(context)
            
        }
 
        myCanvas.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        myCanvas.tempImageView.alpha = myCanvas.opacity
        UIGraphicsEndImageContext()

    }
    
    func applySettingsUI(brushSettingsDelegate: BrushSettingsViewController) {
        
        brushSettingsDelegate.activateLabel(0, text: "Particles")
        brushSettingsDelegate.activateLabel(1, text: "Size")
        brushSettingsDelegate.activateLabel(2, text: "Disperse")
        brushSettingsDelegate.activateLabel(3, text: "Colors")
        
        brushSettingsDelegate.activateSlider(0, minValue: minParticles, maxValue: maxParticles, currentValue: numParticles)
        brushSettingsDelegate.activateSlider(1, minValue: minParticleSize, maxValue: maxParticleSize, currentValue: particleSize)
        brushSettingsDelegate.activateSlider(2, minValue: minDispersion, maxValue: maxDispersion, currentValue: dispersion)
        brushSettingsDelegate.activateSlider(3, minValue: minColorVariance, maxValue: maxColorVariance, currentValue: colorVariance)
        
    }
    
    func settingsUpdate(slot: Int, newValue: CGFloat) {
        
        if slot == 0 {
            numParticles = newValue
        } else if slot == 1 {
            particleSize = newValue
        } else if slot == 2 {
            dispersion = newValue
        } else if slot == 3 {
            colorVariance = newValue
        }
        
    }
    
    class SprayCanGesture: UIGestureRecognizer {
        
        var myBrush: SprayCanBrush?
        
        func setBrush(brush: SprayCanBrush) {
            myBrush = brush
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            
            if let touch: UITouch = touches.first {
                if let brush: SprayCanBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {

                        brush.spray(touch.locationInView(myUIView))
                        
                    }
                }
            }
            
        }
        
        
        override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?){
            
            if let touch: UITouch = touches.first {
                if let brush: SprayCanBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        brush.spray(touch.locationInView(myUIView))
                        
                    }
                }
            }
            
        }
        
        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
            
            if let touch: UITouch = touches.first {
                if let brush: SprayCanBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        brush.spray(touch.locationInView(myUIView))
                        myBrush?.myCanvas.merge()
                        
                    }
                }
            }
        }
    }
}