//
//  SelectBrushController.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/14/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation
import UIKit

class SelectBrushViewController: UIViewController {
    
    @IBOutlet weak var Pencil: UIButton!
    @IBOutlet weak var PaintBrush: UIButton!
    @IBOutlet weak var SprayCan: UIButton!
    @IBOutlet weak var PaintBucket: UIButton!
    @IBOutlet weak var Box: UIButton!
    @IBOutlet weak var Circle: UIButton!
    @IBOutlet weak var Line: UIButton!
    @IBOutlet weak var Curve: UIButton!
    @IBOutlet weak var Blur: UIButton!
    @IBOutlet weak var Words: UIButton!
    @IBOutlet weak var Eraser: UIButton!
    
    var allButtons = [UIButton]()
    var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allButtons = [Pencil, PaintBrush, SprayCan, PaintBucket, Box, Circle, Line, Curve, Blur, Words, Eraser]
        
        for button in allButtons {
            button.addTarget(self, action: #selector(SelectBrushViewController.clickButton(_:)), forControlEvents: UIControlEvents.TouchDown)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func clickButton(sender: UIButton) {
        
        if let newBrushIndex = allButtons.indexOf(sender) {
            print("you clicked a new brush!")
            if let brush: BrushType = delegate!.brushes[newBrushIndex] {
                delegate!.setBrush(brush)
            }
        }
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }

}