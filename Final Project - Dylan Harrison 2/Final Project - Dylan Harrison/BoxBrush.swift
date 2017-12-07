//
//  BoxBrush.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/18/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class BoxBrush: BrushType {
    
    var myCanvas: Canvas
    var myBrushName: String
    var myGestureRecognizer: UIGestureRecognizer?
    var myIcon: UIImage
    var p0: CGPoint
    var pf: CGPoint
    var lineThickness: CGFloat = 8.0
    var filled: Bool = false
    
    let minLineThickness: CGFloat = 1.0
    let maxLineThickness: CGFloat = 32.0
    
    let minIsFilled: CGFloat = 0.0
    let maxIsFilled: CGFloat = 1.0
    
    init(canvas: Canvas) {
        myCanvas = canvas
        myBrushName = "Box"
        myIcon = UIImage(named: "check-box-outline-blank-128")!
        p0 = CGPoint(x: 0,y: 0)
        pf = CGPoint(x: 0,y: 0)
        myGestureRecognizer = BoxGesture()
        (myGestureRecognizer as! BoxGesture).setBrush(self)
    }
    
    func applySettingsUI(brushSettingsDelegate: BrushSettingsViewController) {
        
        brushSettingsDelegate.activateLabel(0, text: "Thickness")
        brushSettingsDelegate.activateSlider(0, minValue: minLineThickness, maxValue: maxLineThickness, currentValue: lineThickness)
        
        brushSettingsDelegate.activateLabel(1, text: "Filled")
        var isFilled: CGFloat = 0.0
        if filled == true {
            isFilled = 1.0
        }
        brushSettingsDelegate.activateSlider(1, minValue: minIsFilled, maxValue: maxIsFilled, currentValue: isFilled)
        
    }
    
    func settingsUpdate(slot: Int, newValue: CGFloat) {
        
        if slot == 0 {
            lineThickness = newValue
        } else if slot == 1 {
            let rounded = round(newValue)
            if rounded == 0 {
                filled = false
            } else {
                filled = true
            }
        }
    }
    
    
    func drawRectangle(fromPoint: CGPoint, toPoint: CGPoint) {
        
        let xDist = (toPoint.x - fromPoint.x);
        let yDist = (toPoint.y - fromPoint.y);
        
        UIGraphicsBeginImageContext(myCanvas.mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        myCanvas.tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: myCanvas.mainImageView.frame.size.width, height: myCanvas.mainImageView.frame.size.height))
        
        CGContextAddRect(context, CGRectMake(fromPoint.x, fromPoint.y, xDist, yDist))

        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, lineThickness)
        CGContextSetStrokeColorWithColor(context, myCanvas.primaryColor!)
        CGContextSetBlendMode(context, CGBlendMode.Normal)

        
        if filled {
            CGContextSetFillColorWithColor(context, myCanvas.primaryColor!)
            CGContextFillPath(context)
        } else {
            CGContextStrokePath(context)
        }
        
        myCanvas.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        myCanvas.tempImageView.alpha = myCanvas.opacity
        UIGraphicsEndImageContext()

        
    }
    
    
    class BoxGesture: UIGestureRecognizer {
        
        var myBrush: BoxBrush?
        
        func setBrush(brush: BoxBrush) {
            myBrush = brush
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            
            if let touch: UITouch = touches.first {
                if let brush: BoxBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        //print ("began touch")
                        brush.p0 = touch.locationInView(myUIView)
                        
                    }
                }
            }
            
        }
        
        
        override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?){
            
            if let touch: UITouch = touches.first {
                if let brush: BoxBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        brush.pf = touch.locationInView(myUIView)
                        
                        brush.myCanvas.tempImageView.image = nil
                        brush.drawRectangle(brush.p0, toPoint: brush.pf)
                        
                       
                    }
                }
            }
            
        }
        
        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
            
            if let touch: UITouch = touches.first {
                if let brush: BoxBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        brush.pf = touch.locationInView(myUIView)
                        brush.myCanvas.tempImageView.image = nil
                        
                        brush.drawRectangle(brush.p0, toPoint: brush.pf)
                        myBrush?.myCanvas.merge()
                        
                    }
                }
            }
        }
    }
}