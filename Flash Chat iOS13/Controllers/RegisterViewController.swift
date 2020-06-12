//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Roman Kavinskyi on 19.02.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    
    @IBAction func registerPressed(_ sender: UIButton) {
        
        if let userEmal = emailTextfield.text, let userPassword = passwordTextfield.text {
            Auth.auth().createUser(withEmail: userEmal, password: userPassword) { (authResult, error) in
                if let e = error {
                    let dialogTitle = "There is an error"
                    let dialogMessage = "\(e.localizedDescription)"
                    let popUpDialog = PopupDialog(title: dialogTitle, message: dialogMessage)
                    let buttonOne = CancelButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
                    popUpDialog.addButton(buttonOne)
                    self.present(popUpDialog, animated: true)
                } else {
                    
                    self.performSegue(withIdentifier: K.registerSegue, sender: self)
                }
            }
        }
    }
    
}
