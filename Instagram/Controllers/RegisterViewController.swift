//
//  RegisterViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 04/04/23.
//

import UIKit
import FirebaseAuth

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var repasswordTextField: UITextField!
    
    var auth: Auth!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        auth = Auth.auth()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true )
        
    }
    
    @IBAction func register(_ sender: UIButton) {
        
        guard let name = nameTextField.text, !name.isEmpty else {
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
                auth.createUser(withEmail: email, password: password) { user, error in
                    if error == nil {
                        print("cadastro com sucesso")
                    } else {
                        print("Erro ao cadastrar")
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
}
