//
//  ViewController.swift
//  MeBe
//
//  Created by Vahan's MBP on 8/29/19.
//  Copyright © 2019 Vahan's MBP. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate, UITextFieldDelegate {
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [ .strokeColor : UIColor.black, .foregroundColor: UIColor.white, NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,  NSAttributedString.Key.strokeWidth: -5.0]
    var textFieldY: CGFloat = 0
    var meme: Meme?
    var memedImage: UIImage?
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var buttomTextField: UITextField!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var buttomToolBar: UIToolbar!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        shareButton.isEnabled = false
        subscribeToKeyboardNotifications()
        keyboardWillHide()
        topTextField.delegate = self
        buttomTextField.delegate = self
        
        topTextField.text = "TOP"
        topTextField.backgroundColor = .black
        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.textAlignment = .center
        
        buttomTextField.text = "BUTTOM"
        buttomTextField.backgroundColor = .black
        buttomTextField.defaultTextAttributes = memeTextAttributes
        buttomTextField.textAlignment = .center
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePickerView.image = image
        }
        shareButton.isEnabled = true
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
        textFieldY = textField.frame.maxY
    }
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func keyboardWillHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification:Notification) {
        if textFieldY > self.view.center.y {
            if self.view.frame.origin.y == 0   {
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        if self.view.frame.origin.y != 0 {
            view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func save() {
        // create the memes
        let meme = Meme(topText: topTextField.text!, bottomText: buttomTextField.text!, originalImage: imagePickerView.image!, memedImage: memedImage!)
        
        self.meme = meme
        
        // Add it to the memes array in the Application Delegate
        
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    func generateMemedImage() -> UIImage {
        // TODO: Hide toolbar and navbar
        topToolBar.isHidden = true
        buttomToolBar.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.memedImage = memedImage
        save()
        // TODO: Show toolbar and navbar
        topToolBar.isHidden = false
        buttomToolBar.isHidden = false
        return memedImage
    }
    
    @IBAction func pickAnImage(_ sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        switch sender.tag {
        case 1:
            present(imagePicker, animated: true, completion: nil)
        case 2:
            if (UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)) {
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = true
                present(imagePicker, animated: true, completion: nil)
            } else {
                let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        default:
            return
        }
    }
    
    @IBAction func shareItem(_ sender: Any) {
        let items = [generateMemedImage()]
        let ac = UIActivityViewController(activityItems: items, applicationActivities: nil)
        present(ac, animated: true)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        topTextField.text = "TOP"
        buttomTextField.text = "BOTTOM"
        imagePickerView.image = nil
    }
    
    
    
    
    
}





