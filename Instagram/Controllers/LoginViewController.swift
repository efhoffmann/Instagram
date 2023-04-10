//
//  LoginViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 04/04/23.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var auth: Auth!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        auth.addStateDidChangeListener { autentication, user in
            if user != nil {
                self.performSegue(withIdentifier: "segueAutomaticLogin", sender: nil)
            } else {
                print("Usuário não logado")
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: true )
    }
    
    @IBAction func unwindToLogin(_ unwindSegue: UIStoryboardSegue) {
        do {
            try auth.signOut()
        } catch {
            print("Erro ao deslogar usuário")
        }
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        guard let email = emailTextField.text, !email.isEmpty else {
            let alert = CustomAlertController(title: "Atenção!", message: "Digite seu e-mail.")
            self.present(alert.showAlert(), animated: true, completion: nil)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            let alert = CustomAlertController(title: "Atenção!", message: "Você deve digitar a senha!")
            self.present(alert.showAlert(), animated: true, completion: nil)
            return
        }

        auth.signIn(withEmail: email, password: password) { user, error in
            if error == nil {
                print("Sucesso ao logar")
            } else {
                let alert =  CustomAlertController(title: "Erro!", message: "Usuário ou senha inválidos.")
                self.present(alert.showAlert(), animated: true, completion: nil)
            }
        }
    }
}
