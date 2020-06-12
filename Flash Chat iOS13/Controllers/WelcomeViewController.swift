//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Roman Kavinskyi on 19.02.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit


class WelcomeViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        titleLabel.text = ""
        let titleText = "⚡️FlashChat"
        var waitTime = 0.0
        for letter in titleText {
            Timer.scheduledTimer(withTimeInterval: 0.1 * waitTime, repeats: false) { (Timer) in
                self.titleLabel.text?.append(letter)
            }
            waitTime += 1
        }
        
    }
    
    
}



