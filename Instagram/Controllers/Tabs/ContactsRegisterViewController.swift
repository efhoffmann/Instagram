//
//  ContactsRegisterViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 10/04/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorageUI

class ContactsRegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var showUsersTableView: UITableView!
    
    var auth: Auth!
    var firestore: Firestore!
    var userLoggedId: String!
    var userLoggedEmail: String!
    var user: Dictionary<String,Any>!
    
    //Extension
    var users: [Dictionary<String,Any>] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showUsersTableView.isHidden = true
        
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        if let currentUser = auth.currentUser {
            userLoggedId = currentUser.uid
            userLoggedEmail = currentUser.email
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recoveryUsers()
    }
    
    
    @IBAction func registerContatcs(_ sender: Any) {
        
        if let typedEmail = emailTextField.text {
            if typedEmail.lowercased() == self.userLoggedEmail {
                let alert = CustomAlertController(title: "Atenção!", message: "Não é permitido adicionar o próprio e-mail.")
                self.present(alert.showAlert(), animated: true, completion: nil)
                return
            }
            
            
            if emailTextField.text == "" {
                let alert = CustomAlertController(title: "Atenção!", message: "Campo vazio. Digite um e-mail válido.")
                self.present(alert.showAlert(), animated: true, completion: nil)
            } else {
                firestore.collection("users")
                    .whereField("email", isEqualTo: typedEmail)
                    .getDocuments { resultSnapshot, error in
                        if let itensTotal = resultSnapshot?.count {
                            if itensTotal == 0 {
                                    let alert = CustomAlertController(title: "Atenção!", message: "Usuário não cadastrado.")
                                    self.present(alert.showAlert(), animated: true, completion: nil)
                                    return
                            }
                        }
                        if let snapshot = resultSnapshot {
                            for document in snapshot.documents {
                                let data = document.data()
                                self.saveContacts(contactDatas: data)
                            }
                        }
                    }
            }
            
        }
    }
    
    
   /* func saveContacts(contactDatas: Dictionary<String, Any>) {
        
        if let contactUserId = contactDatas["id"] {
            firestore.collection("users")
                .document(userLoggedId)
                .collection("contacts")
                .document(String(describing: contactUserId))
                .setData(contactDatas) { error in
                    if error == nil {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        }
    } */
    
    func saveContacts(contactDatas: Dictionary<String, Any>) {
        
        if let contactUserId = contactDatas["id"] {
            firestore.collection("users")
                .document(userLoggedId)
                .collection("contacts")
                .document(String(describing: contactUserId))
                .setData(contactDatas) { error in
                    if error == nil {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
        }
    }
    
    
    @IBAction func listUsers(_ sender: UIButton) {
        self.recoveryUsers()
        showUsersTableView.isHidden = false
    }
}

// MARK: - Tables Show Users

extension ContactsRegisterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "showUsersCell", for: indexPath)
        
        let user = self.users[indexPath.row]
       
        let name = user["name"] as? String
        let email = user["email"] as? String
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showUsersTableView.deselectRow(at: indexPath, animated: true)
        if users.count == 0 {
            return
        }
        let index = indexPath.row
        let contact = self.users[index]
        
        saveContacts(contactDatas: contact)
    }
    
   
    func recoveryUsers() {
        self.users.removeAll()
        self.showUsersTableView.reloadData()
        
        firestore.collection("users").getDocuments { resultSnapshot, error in
            if let snapshot = resultSnapshot {
                for document in snapshot.documents {
                    let datas = document.data()
                    self.users.append(datas)
                }
                self.showUsersTableView.reloadData()
            }
        }
        
    }
    
}
