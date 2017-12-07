//
//  LineBrush.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/18/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class LineBrush: BrushType {
    
    var myCanvas: Canvas
    var myBrushName: String
    var myGestureRecognizer: UIGestureRecognizer?
    var myIcon: UIImage
    var p0: CGPoint
    var pf: CGPoint
    var lineThickness: CGFloat = 8.0
    
    let minLineThickness: CGFloat = 1.0
    let maxLineThickness: CGFloat = 32.0
    
    init(canvas: Canvas) {
        myCanvas = canvas
        myBrushName = "Line"
        myIcon = UIImage(named: "button_shape_line-128")!
        p0 = CGPoint(x: 0,y: 0)
        pf = CGPoint(x: 0,y: 0)
        myGestureRecognizer = LineGesture()
        (myGestureRecognizer as! LineGesture).setBrush(self)
    }
    
    func applySettingsUI(brushSettingsDelegate: BrushSettingsViewController) {
        
        brushSettingsDelegate.activateLabel(0, text: "Thickness")
        brushSettingsDelegate.activateSlider(0, minValue: minLineThickness, maxValue: maxLineThickness, currentValue: lineThickness)
        
    }
    
    func settingsUpdate(slot: Int, newValue: CGFloat) {
        lineThickness = newValue
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
        // 1
        UIGraphicsBeginImageContext(myCanvas.mainImageView.frame.size)
        let context = UIGraphicsGetCurrentContext()
        myCanvas.tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: myCanvas.mainImageView.frame.size.width, height: myCanvas.mainImageView.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, CGLineCap.Round)
        CGContextSetLineWidth(context, lineThickness)
        CGContextSetStrokeColorWithColor(context, myCanvas.primaryColor!)
        CGContextSetBlendMode(context, CGBlendMode.Normal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        myCanvas.tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        myCanvas.tempImageView.alpha = myCanvas.opacity
        UIGraphicsEndImageContext()
        
    }
    
    
    class LineGesture: UIGestureRecognizer {
        
        var myBrush: LineBrush?
        
        func setBrush(brush: LineBrush) {
            myBrush = brush
        }
        
        override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
            
            if let touch: UITouch = touches.first {
                if let brush: LineBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        //print ("began touch")
                        brush.p0 = touch.locationInView(myUIView)
                        
                    }
                }
            }
            
        }
        
        
        override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?){
            
            if let touch: UITouch = touches.first {
                if let brush: LineBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        brush.pf = touch.locationInView(myUIView)
                        
                        brush.myCanvas.tempImageView.image = nil
                        myBrush?.drawLineFrom(brush.p0, toPoint: brush.pf)

                        
                    }
                }
            }
            
        }
        
        override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?){
            
            if let touch: UITouch = touches.first {
                if let brush: LineBrush = myBrush! {
                    if let myUIView: UIView = touch.view! {
                        
                        brush.pf = touch.locationInView(myUIView)
                        myBrush?.drawLineFrom(brush.p0, toPoint: brush.pf)
                        myBrush?.myCanvas.merge()
                        
                    }
                }
            }
        }
    }
}