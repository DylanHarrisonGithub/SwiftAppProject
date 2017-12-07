//
//  ViewController.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/13/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var canvasView: UIView!
    
    @IBOutlet weak var BrushTool: UIButton!
    @IBOutlet weak var BrushSettings: UIButton!
    @IBOutlet weak var Pallet: UIButton!
    @IBOutlet weak var File: UIButton!
    
    @IBOutlet weak var ColorView: UIView!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var tempImageView: UIImageView!
    
    var brushes = [BrushType?]()
    var myCanvas: Canvas?
    var currentBrush: BrushType?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        myCanvas = Canvas(main: mainImageView, temp: tempImageView)
        
        brushes = [PencilBrush(canvas: myCanvas!)]
        brushes.append(nil) //paintbrush placeholdr
        brushes.append(SprayCanBrush(canvas: myCanvas!))
        brushes.append(nil) //paint bucket placeholder
        brushes.append(BoxBrush(canvas: myCanvas!))
        brushes.append(CircleBrush(canvas: myCanvas!))
        brushes.append(LineBrush(canvas: myCanvas!))
        brushes.append(CurveBrush(canvas: myCanvas!)) //curve
        brushes.append(nil) //blur
        brushes.append(nil) //words
        brushes.append(nil) //eraser

        setBrush(brushes[0]!)
        
        ColorView.backgroundColor = UIColor(CGColor: myCanvas!.primaryColor!)
                
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setBrush(brush: BrushType) {
        
        //remove old gesture recognizers
        if let oldGestures = canvasView.gestureRecognizers {
            for gesture in oldGestures {
                if let g:UIGestureRecognizer = gesture {
                    canvasView.removeGestureRecognizer(g)
                }
            }
        }
        
        currentBrush = brush
        canvasView.addGestureRecognizer(brush.myGestureRecognizer!)
        BrushTool.imageView?.image = brush.myIcon

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SelectBrushSegue" {
            
            let dest = segue.destinationViewController as! SelectBrushViewController
            dest.delegate = self
            
        } else if segue.identifier == "BrushSettingsSegue" {
            
            let dest = segue.destinationViewController as! BrushSettingsViewController
            dest.delegate = self
            
        } else if segue.identifier == "ColorPickerSegue" {
            
            let dest = segue.destinationViewController as! ColorPickerViewController
            dest.delegate = self
            
        } else if segue.identifier == "FileSegue" {
            
            let dest = segue.destinationViewController as! FileViewController
            dest.delegate = self
            
        }
        
    }

}

