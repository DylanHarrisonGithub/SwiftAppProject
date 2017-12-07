//
//  FileController.swift
//  Final Project - Dylan Harrison
//
//  Created by Dylan James Harrison on 12/14/16.
//  Copyright © 2016 Dylan James Harrison. All rights reserved.
//

import Foundation

import Foundation
import UIKit

class FileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var dismissButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    var delegate: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        
        delegate?.myCanvas?.mainImageView.image = imageView.image
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismiss(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func new(sender: AnyObject) {
        delegate?.myCanvas?.clear()
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func load(sender: AnyObject) {
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
        
    }

    @IBAction func save(sender: AnyObject) {
        
        UIImageWriteToSavedPhotosAlbum((delegate?.myCanvas?.mainImageView.image)!, nil, nil, nil)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}