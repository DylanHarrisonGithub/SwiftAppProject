//
//  CircleBrush.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/18/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class CircleBrush: BrushType {
    
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
        myBrushName = "Circle"
        myIcon = UIImage(named: "check-circle-outline-blank-128")!
        p0 = CGPoint(x: 0,y: 0)
        pf = CGPoint(x: 0,y: 0)
        myGestureRecognizer = CircleGesture()
        (myGestureRecognizer as! CircleGesture).setBrush(self)
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
    
    func drawCircle(fromPoint: CGPoint, toPoint: CGPoint) {
        
        let center = CGPoint(x: (fromPoint.x+toPoint.x)/2.0, y: (fromPoint.y+toPoint.y)/2.0)
        
        let xDist = (toPoint.x - fromPoint.x);
        let yDist = (toPoint.y - fromPoint.y);
        let distance = sqrt((xDist * xDist) + (yDist * yDist))/2.0
        var radius:CGFloat = 0.0
        
        //cos(arctan(x)) = 1/(1+x^2)^(1/2)
        if abs(yDist) < abs(xDist) {
                radius = (1.0 / sqrt(1.0 + (yDist/xDist)*(yDist/xDist)))*distance
        } else {
                radius = (1.0 / sqrt(1.0 + (xDist/yDist)*(xDist/yDist)))*distance
        }

        UIGraphicsBeginImageContext(myCanvas.mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        myCanvas.tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: myCanvas.mainImageView.frame.size.width, height: myCanvas.mainImageView.frame.size.height))

        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, lineThickness)
        CGContextSetStrokeColorWithColor(context, myCanvas.primaryColor!)
        CGContextSetFillColorWithColor(context, myCanvas.primaryColor!)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        CGContextAddArc(context, center.x, center.y, radius, 0, 2*CGFloat(M_PI), 0)
        
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
    
    
    class CircleGesture: UIGestureRecognizer {
        
        var myBrush: CircleBrush?
        
        func setBrush(brush: CircleBrush) {
            myBrush = brush
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            
            if let touch: UITouch = touches.first {
                if let brush: CircleBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        //print ("began touch")
                        brush.p0 = touch.locationInView(myUIView)
                        
                    }
                }
            }
            
        }
        
        
        override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?){
            
            if let touch: UITouch = touches.first {
                if let brush: CircleBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        brush.pf = touch.locationInView(myUIView)
                        
                        brush.myCanvas.tempImageView.image = nil
                        brush.drawCircle(brush.p0, toPoint: brush.pf)
                                                
                    }
                }
            }
            
        }
        
        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
            
            if let touch: UITouch = touches.first {
                if let brush: CircleBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        brush.pf = touch.locationInView(myUIView)
                        brush.myCanvas.tempImageView.image = nil
                        brush.drawCircle(brush.p0, toPoint: brush.pf)
                        
                        myBrush?.myCanvas.merge()
                        
                    }
                }
            }
        }
    }
}