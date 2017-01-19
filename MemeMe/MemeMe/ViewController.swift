//
//  ViewController.swift
//  MemeMe
//
//  Created by Scott Knutti on 11/30/15.
//  Copyright © 2015 Scott Knutti. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var topLabel: UITextField!
    @IBOutlet weak var bottomLabel: UITextField!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var navBar: UINavigationBar!
    @IBOutlet weak var toolBar: UIToolbar!
    
    let textFieldDelegate = TextFieldDelegate()
    
    var defaultTextAttributes = [
        NSStrokeColorAttributeName : UIColor.black,
        NSForegroundColorAttributeName : UIColor.white,
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -1.0 ] as [String : Any]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)
        let image: UIImage? = imageView.image
        if (image == nil) {
            shareButton.isEnabled = false
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeTextField(topLabel, text: "TOP")
        initializeTextField(bottomLabel, text: "BOTTOM")
    }
    
    func initializeTextField(_ textField: UITextField, text: String) {
        textField.text = text
        textField.textAlignment = .center
        textField.defaultTextAttributes = defaultTextAttributes
        textField.delegate = textFieldDelegate
    }

    @IBAction func pickAnImageFromCamera(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func pickAnImageFromAlbum(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func shareMeme(_ sender: AnyObject) {
        let memedImage = generateMemedImage()
        
        let controller = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        controller.completionWithItemsHandler = {
            (activity, success, items, error) in
            print("Activity: \(activity) Success: \(success) Items: \(items) Error: \(error)")
            if (success) {
                self.save(memedImage)
            }
            self.dismiss(animated: true, completion: nil)
        }
        present(controller, animated: true, completion: nil)
    }
    
    @IBAction func cancelCurrentMeme(_ sender: AnyObject) {
        imageView.image = nil
        topLabel.text = "TOP"
        bottomLabel.text = "BOTTOM"
        shareButton.isEnabled = false
    }
    
    func save(_ memedImage: UIImage) {
        //Create the meme
        var meme = Meme(topText: topLabel.text!, bottomText: bottomLabel.text!, image: imageView.image!, memedImage: memedImage)
    }
    
    // Create a UIImage that combines the Image View and the Textfields
    func generateMemedImage() -> UIImage {
        // Hide toolbar and navbar
        navBar.isHidden = true
        toolBar.isHidden = true
        
        // render view to an image
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar and navbar
        navBar.isHidden = false
        toolBar.isHidden = false
        
        return memedImage
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        let image: UIImage? = imageView.image
        if (image != nil) {
            shareButton.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func keyboardWillShow(_ notification: Notification) {
        if bottomLabel.isFirstResponder {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
}

