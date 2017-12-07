//
//  BrushProtocol.swift
//  drawingTest
//
//  Created by Dylan James Harrison on 10/18/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

protocol BrushType {
    
    var myBrushName: String { get set }
    var myGestureRecognizer: UIGestureRecognizer? {get}
    var myIcon: UIImage {get set}
    var myCanvas: Canvas {get set}
    func applySettingsUI(brushSettingsDelegate: BrushSettingsViewController)
    func settingsUpdate(slot: Int, newValue: CGFloat)
    
}