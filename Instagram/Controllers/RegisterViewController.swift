//
//  RegisterViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 04/04/23.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    
    var auth: Auth!
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
        firestore = Firestore.firestore()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //self.navigationItem.leftBarButtonItem?.isEnabled = false
    }
    
    @IBAction func register(_ sender: UIButton) {
        
        guard let name = nameTextField.text?.lowercased(), !name.isEmpty else {
            let alert = CustomAlertController(title: "Atenção!", message: "Preencha o campo com seu nome.")
            self.present(alert.showAlert(), animated: true, completion: nil)
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            let alert = CustomAlertController(title: "Atenção!", message: "Preencha seu e-mail.")
            self.present(alert.showAlert(), animated: true, completion: nil)
            return
        }
        
        guard let password = passwordTextfield.text, !password.isEmpty else {
            let alert = CustomAlertController(title: "Atenção!", message:"Preencha a senha.")
            self.present(alert.showAlert(), animated: true, completion: nil)
            return
        }
        
        guard let repassword = repasswordTextField.text, !repassword.isEmpty else {
            let alert = CustomAlertController(title: "Atenção!", message: "Repita a senha.")
            self.present(alert.showAlert(), animated: true, completion: nil)
            return
        }
        
        if password.count >= 6 {
            if password == repassword {
                auth.createUser(withEmail: email, password: password) { userData, error in
                    if error == nil {
                       
                        if let userId = userData?.user.uid {
                            self.firestore.collection("users")
                                .document(userId)
                                .setData([
                                    "name": name,
                                    "email": email,
                                    "id": userId
                                ])
                        }
                        
                    } else {
                        print("Erro ao cadastrar")
                        let errorType = error! as NSError
                        
                        self.error(type: errorType)
                        
                    }
                }
                
            } else {
                let alert = CustomAlertController(title: "Erro!", message: "As senhas devem ser iguais!")
                self.present(alert.showAlert(), animated: true, completion: nil)
            }
        } else {
            let alert = CustomAlertController(title: "Erro!", message: "A senha deve ter no mínimo 6 caracteres.")
            self.present(alert.showAlert(), animated: true, completion: nil)
        }
    }
    
    // MARK: - Error Handling
    
    func error(type: NSError) {
        if let errorCode = type.userInfo["FIRAuthErrorUserInfoNameKey"]{
            
            let textError = errorCode as! String
            var errorMessage = ""
            
            switch textError {
            case "ERROR_INVALID_EMAIL" :
                errorMessage = "E-mail inválido. Digite um e-mail válido."
                //break
            case "ERROR_EMAIL_ALREADY_IN_USE":
                errorMessage = "E-mail já existe. Cadastre um e-mail diferente."
                //break
            default:
                errorMessage = "Dados digitados incorretamente."
            }
            let alert = CustomAlertController(title: "Erro!", message: errorMessage)
            self.present(alert.showAlert(), animated: true, completion: nil)
            
        }
    }
    
}
