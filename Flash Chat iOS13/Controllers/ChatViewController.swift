//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Roman Kavinskyi on 19.02.2020.
//  Copyright © 2020 Roman Kavinskyi. All rights reserved.
//

import UIKit
import Firebase
import PopupDialog


class ChatViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    
    var messages = [Message(sender: "", body: "")]
    let db = Firestore.firestore()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        messages = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        tableView.dataSource = self
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        getData()
        
    }
    func getData() {
        db.collection(K.FStore.collectionName).order(by: K.FStore.dateField).addSnapshotListener { (querySnapShot, error) in
            if let e = error {
                let errorTitle = "Error"
                let errorMessage = "\(e.localizedDescription)"
                let popUpDialod = PopupDialog(title: errorTitle, message: errorMessage)
                let buttonOne = CancelButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
                popUpDialod.addButton(buttonOne)
                self.present(popUpDialod, animated: true)
            } else {
                if let allMessages = querySnapShot?.documents {
                    self.messages = []
                    for message in allMessages {
                        if let messageBody = message[K.FStore.bodyField] as? String, let messageSender = message[K.FStore.senderField] as? String {
                            let messageToAppend = Message(sender: messageSender, body: messageBody)
                            self.messages.append(messageToAppend)
                        }
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        if self.messages.isEmpty == true {
                            return
                        } else {
                            let indexPath = IndexPath(row: self.messages.count - 1, section: 0)
                            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                        }
                        
                    }
                }
                
            }
        }
    }
    
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let e as NSError {
            let errorTitle = "Error"
            let errorMessage = "\(e.localizedDescription)"
            let popUpDialod = PopupDialog(title: errorTitle, message: errorMessage)
            let buttonOne = CancelButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
            popUpDialod.addButton(buttonOne)
            self.present(popUpDialod, animated: true)
        }
    }
    
    
    @IBAction func sendPressed(_ sender: UIButton) {
        if let senderEmail = Auth.auth().currentUser?.email, let senderBody = messageTextfield.text{
            db.collection(K.FStore.collectionName).addDocument(data: [
                K.FStore.bodyField: senderBody,
                K.FStore.senderField: senderEmail,
                K.FStore.dateField: Date().timeIntervalSince1970
            ]) { (error) in
                if let e = error {
                    let errorTitle = "Error"
                    let errorMessage = "\(e.localizedDescription)"
                    let popUpDialod = PopupDialog(title: errorTitle, message: errorMessage)
                    let buttonOne = CancelButton(title: "OK", height: 40, dismissOnTap: true, action: nil)
                    popUpDialod.addButton(buttonOne)
                    self.present(popUpDialod, animated: true)
                }else {
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""
                    }
                }
            }
        }
    }
    
    
}


extension ChatViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath) as! MessageCell
        cell.label.text = messages[indexPath.row].body
        
        if messages[indexPath.row].sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        } else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        
        
        return cell
    }
    
    
}
