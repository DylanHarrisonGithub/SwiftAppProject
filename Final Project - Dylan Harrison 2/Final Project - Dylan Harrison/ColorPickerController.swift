//
//  ColorPickerController.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/14/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation
import UIKit

class ColorPickerViewController: UIViewController {
    
    @IBOutlet weak var primaryColor: UIView!
    @IBOutlet weak var swath1: UIView!
    @IBOutlet weak var swath2: UIView!
    
    @IBOutlet weak var interpolater: UISlider!
    @IBOutlet weak var opacity: UISlider!
    
    @IBOutlet weak var s1r: UISlider!
    @IBOutlet weak var s1g: UISlider!
    @IBOutlet weak var s1b: UISlider!
    
    @IBOutlet weak var s2r: UISlider!
    @IBOutlet weak var s2g: UISlider!
    @IBOutlet weak var s2b: UISlider!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    var delegate: ViewController?
    var colorComponentSliders = [UISlider]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dismissButton.addTarget(self, action: #selector(ColorPickerViewController.dismiss(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        colorComponentSliders = [s1r,s1g,s1b,s2r,s2g,s2b]
        
        //initialize sliders
        interpolater.maximumValue = 0.9999
        interpolater.minimumValue = 0.0
        opacity.maximumValue = 1.0
        opacity.minimumValue = 0.0
        
        s1r.maximumValue = 1.0
        s1r.minimumValue = 0.0
        s1g.maximumValue = 1.0
        s1g.minimumValue = 0.0
        s1b.maximumValue = 1.0
        s1b.minimumValue = 0.0
        
        s2r.maximumValue = 1.0
        s2r.minimumValue = 0.0
        s2g.maximumValue = 1.0
        s2g.minimumValue = 0.0
        s2b.maximumValue = 1.0
        s2b.minimumValue = 0.0
        
        let swath1Components = CGColorGetComponents(delegate!.myCanvas!.swath1Color)
        let swath2Components = CGColorGetComponents(delegate!.myCanvas!.swath2Color)
        
        interpolater.value = Float(delegate!.myCanvas!.interpolated)
        opacity.value = Float(delegate!.myCanvas!.opacity)
        
        s1r.value = Float(swath1Components[0])
        s1g.value = Float(swath1Components[1])
        s1b.value = Float(swath1Components[2])

        s2r.value = Float(swath2Components[0])
        s2g.value = Float(swath2Components[1])
        s2b.value = Float(swath2Components[2])

        //initialize color swatches
        primaryColor.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.primaryColor!)
        swath1.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.swath1Color!)
        swath2.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.swath2Color!)
        
        //add targets to sliders
        interpolater.addTarget(self, action: #selector(ColorPickerViewController.interpolaterAction(_:)), forControlEvents: .ValueChanged)
        opacity.addTarget(self, action: #selector(ColorPickerViewController.opacityAction(_:)), forControlEvents: .ValueChanged)
        for component in colorComponentSliders {
            component.addTarget(self, action: #selector(ColorPickerViewController.componentAction(_:)), forControlEvents: .ValueChanged)
        }
        
    }
    
    func interpolaterAction(sender: UISlider) {
        delegate!.myCanvas!.interpolated = CGFloat(sender.value)
        delegate!.myCanvas!.primaryColor = delegate!.myCanvas!.generateInterpolatedColor(
            swath1.backgroundColor!.CGColor,
            c2: swath2.backgroundColor!.CGColor,
            t: CGFloat(delegate!.myCanvas!.interpolated))
        primaryColor.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.primaryColor!)
    }
    
    func opacityAction(sender: UISlider) {
        delegate!.myCanvas!.opacity = CGFloat(sender.value)
        let oldCGColorComponents = CGColorGetComponents(delegate!.myCanvas!.primaryColor!)
        delegate!.myCanvas!.primaryColor = delegate!.myCanvas!.generateColorARGB(
            oldCGColorComponents[3],
            r: oldCGColorComponents[0],
            g: oldCGColorComponents[1],
            b: oldCGColorComponents[2])
        primaryColor.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.primaryColor!)
    }
    
    func componentAction(sender: UISlider) {
        let index = colorComponentSliders.indexOf(sender)
        let component = index! % 3
        
        let oldSwath1Components = CGColorGetComponents(delegate!.myCanvas!.swath1Color!)
        let oldSwath2Components = CGColorGetComponents(delegate!.myCanvas!.swath2Color!)
        
        if index < 3 {
            if component == 0 {
                delegate!.myCanvas!.swath1Color = delegate!.myCanvas!.generateColorARGB(
                    oldSwath1Components[3],
                    r: CGFloat(sender.value),
                    g: oldSwath1Components[1],
                    b: oldSwath1Components[2])
            } else if component == 1 {
                delegate!.myCanvas!.swath1Color = delegate!.myCanvas!.generateColorARGB(
                    oldSwath1Components[3],
                    r: oldSwath1Components[0],
                    g: CGFloat(sender.value),
                    b: oldSwath1Components[2])
            } else if component == 2 {
                delegate!.myCanvas!.swath1Color = delegate!.myCanvas!.generateColorARGB(
                    oldSwath1Components[3],
                    r: oldSwath1Components[0],
                    g: oldSwath1Components[1],
                    b: CGFloat(sender.value))
            }
            swath1.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.swath1Color!)
        } else {
            if component == 0 {
                delegate!.myCanvas!.swath2Color = delegate!.myCanvas!.generateColorARGB(
                    oldSwath2Components[3],
                    r: CGFloat(sender.value),
                    g: oldSwath2Components[1],
                    b: oldSwath2Components[2])
            } else if component == 1 {
                delegate!.myCanvas!.swath2Color = delegate!.myCanvas!.generateColorARGB(
                    oldSwath2Components[3],
                    r: oldSwath2Components[0],
                    g: CGFloat(sender.value),
                    b: oldSwath2Components[2])
            } else if component == 2 {
                delegate!.myCanvas!.swath2Color = delegate!.myCanvas!.generateColorARGB(
                    oldSwath2Components[3],
                    r: oldSwath2Components[0],
                    g: oldSwath2Components[1],
                    b: CGFloat(sender.value))
            }
            swath2.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.swath2Color!)
        }
        
        delegate!.myCanvas!.primaryColor = delegate!.myCanvas!.generateInterpolatedColor(
            swath1.backgroundColor!.CGColor,
            c2: swath2.backgroundColor!.CGColor,
            t: CGFloat(delegate!.myCanvas!.interpolated))
        primaryColor.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.primaryColor!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func dismiss(sender: AnyObject) {
        delegate!.ColorView.backgroundColor = UIColor(CGColor: delegate!.myCanvas!.primaryColor!)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}