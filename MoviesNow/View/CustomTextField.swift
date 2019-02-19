//
//  CustomTextField.swift
//  MoviesNow
//
//  Created by Gunasai Garapati on 2/5/19.
//  Copyright © 2019 Gunasai Garapati. All rights reserved.
//

import Foundation
import JVFloatLabeledTextField
import UIKit

extension JVFloatLabeledTextField {
    func bottomBorder(textFieldWidth: CGFloat){
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.lightGray.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: textFieldWidth, height: self.frame.size.height)
        border.borderWidth = width
        border.opacity = 0.5
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
}


extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            textField.resignFirstResponder()
            loginTapped(self)
        }
        return true
    }
}
