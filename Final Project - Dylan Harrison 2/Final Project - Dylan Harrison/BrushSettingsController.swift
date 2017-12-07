//
//  BrushSettingsController.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/14/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation
import UIKit

class BrushSettingsViewController: UIViewController {
    
    @IBOutlet weak var L1: UILabel!
    @IBOutlet weak var L2: UILabel!
    @IBOutlet weak var L3: UILabel!
    @IBOutlet weak var L4: UILabel!
    @IBOutlet weak var L5: UILabel!
    @IBOutlet weak var L6: UILabel!
    @IBOutlet weak var L7: UILabel!
    @IBOutlet weak var L8: UILabel!
    @IBOutlet weak var L9: UILabel!
    @IBOutlet weak var L10: UILabel!
    
    @IBOutlet weak var S1: UISlider!
    @IBOutlet weak var S2: UISlider!
    @IBOutlet weak var S3: UISlider!
    @IBOutlet weak var S4: UISlider!
    @IBOutlet weak var S5: UISlider!
    @IBOutlet weak var S6: UISlider!
    @IBOutlet weak var S7: UISlider!
    @IBOutlet weak var S8: UISlider!
    @IBOutlet weak var S9: UISlider!
    @IBOutlet weak var S10: UISlider!
    
    @IBOutlet weak var DismissButton: UIButton!
    @IBOutlet var MainView: UIView!
    
    var delegate: ViewController?
    var labels = [UILabel]()
    var sliders = [UISlider] ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labels = [L1,L2,L3,L4,L5,L6,L7,L8,L9,L10]
        sliders = [S1,S2,S3,S4,S5,S5,S6,S7,S8,S9,S10]
        DismissButton.addTarget(self, action: #selector(BrushSettingsViewController.dismiss(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        resetAll()
        delegate!.currentBrush?.applySettingsUI(self)
        
        MainView.setNeedsDisplay()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetAll() {
        for l in labels {
            l.hidden = true
        }
        for s in sliders {
            s.hidden = true
            s.removeTarget(nil, action: nil, forControlEvents: .AllEvents)
        }
    }
    
    func activateLabel(slot: Int, text: String) {
        if ((slot >= 0) && (slot < 10)) {
            labels[slot].hidden = false
            labels[slot].text = text
        }
    }
    
    func activateSlider(slot: Int, minValue: CGFloat, maxValue: CGFloat, currentValue: CGFloat) {
        if ((slot >= 0) && (slot < 10)) {
            sliders[slot].hidden = false
            sliders[slot].maximumValue = Float(maxValue)
            sliders[slot].minimumValue = Float(minValue)
            sliders[slot].setValue(Float(currentValue), animated: true)
            sliders[slot].addTarget(self, action: #selector(BrushSettingsViewController.sliderChanged(_:)), forControlEvents: .ValueChanged)
        }
    }

    func sliderChanged(sender: UISlider) {
        delegate!.currentBrush?.settingsUpdate(sliders.indexOf(sender)!, newValue: CGFloat(sender.value))
    }
    
    func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}