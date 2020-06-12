//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Roman Kavinskyi on 19.02.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    

    @IBAction func loginPressed(_ sender: UIButton) {
        if let userLogin = emailTextfield.text, let userPassword = passwordTextfield.text {
            Auth.auth().signIn(withEmail: userLogin, password: userPassword) { (authData, error) in
                if let e = error {
                    let errorTitle = "Error"
                    let errorMessage = "\(e.localizedDescription)"
                    let popUpDialod = PopupDialog(title: errorTitle, message: errorMessage)
                    let buttonOne = CancelButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
                    popUpDialod.addButton(buttonOne)
                    self.present(popUpDialod, animated: true)
                }else {
                    
                    self.performSegue(withIdentifier: K.loginSegue, sender: self)
                }
            }
        }
    }
    
}
