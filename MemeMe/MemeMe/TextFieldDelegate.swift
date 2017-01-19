//
//  TextFieldDelegate.swift
//  MemeMe
//
//  Created by Scott Knutti on 11/30/15.
//  Copyright © 2015 Scott Knutti. All rights reserved.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = (textField.text! as NSString).replacingCharacters(in: range, with: string.uppercased())
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}
