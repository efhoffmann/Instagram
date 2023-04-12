//
//  LoginViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 04/04/23.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var auth: Auth!
    
    /* private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("logIn", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }() */
    
    private let facebookLoginButton = FBLoginButton()
    

    
    
 /*   private let facebookLoginButton: FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email, public_profile"]
        return button
    }() */
    
   
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
       // facebookLoginButton.permissions = ["email, public_profile"]
        facebookLoginButton.center = view.center
        facebookLoginButton.frame = CGRect(x: 50, y: 480, width: 292, height: 37)
        view.addSubview(facebookLoginButton)
        
       NotificationCenter.default.addObserver(forName: .AccessTokenDidChange, object: nil, queue: OperationQueue.main) { (notification) in
            print("FB Access Token: \(String(describing: AccessToken.current?.tokenString))")
        }
        
        facebookLoginButton.delegate = self
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

extension LoginViewController: LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User failed to log in with facebook")
            return
        }
        
        let credential = FacebookAuthProvider.credential(withAccessToken: token)
        
       FirebaseAuth.Auth.auth().signIn(with: credential) { [weak self] authresult, error in
            
           guard let strongSelf = self else {
               return
           }
           guard let result = authresult, error == nil else {
                print("facebook credential login failed")
                return
            }
                print("sucess")
                strongSelf.navigationController?.dismiss(animated: true)
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginKit.FBLoginButton) {
        //no operation
    }
    
    
}
