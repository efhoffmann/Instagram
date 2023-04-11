//
//  ContactsRegisterViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 10/04/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class ContactsRegisterViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    var auth: Auth!
    var firestore: Firestore!
    var userLoggedId: String!
    var userLoggedEmail: String!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        if let currentUser = auth.currentUser {
            userLoggedId = currentUser.uid
            userLoggedEmail = currentUser.email
        }
        
    }
    
    
    @IBAction func registerContatcs(_ sender: Any) {
        
        if let typedEmail = emailTextField.text {
            if typedEmail == self.userLoggedEmail {
                let alert = CustomAlertController(title: "Atenção!", message: "Você está adicionando o próprio e-mail.")
                self.present(alert.showAlert(), animated: true, completion: nil)
                return
            }
            
            
            if emailTextField.text == "" {
                let alert = CustomAlertController(title: "Atenção!", message: "Campo vazio. Digite o nome válido.")
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
}

