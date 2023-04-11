//
//  PostViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 04/04/23.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var storage: Storage!
    var auth: Auth!
    var firestore: Firestore!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        storage = Storage.storage()
        auth = Auth.auth()
        firestore = Firestore.firestore()
        
        photoImageView.image = UIImage(named: "padrao")
    
        
    }

    @IBAction func selectImage(_ sender: UIButton) {
        
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let recoveryImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        self.photoImageView.image = recoveryImage
        
        imagePicker.dismiss(animated: true)
    }
    
    @IBAction func savePost(_ sender: UIButton) {
        let images = storage.reference()
                    .child("images")
        
        if self.photoImageView.image == UIImage(named: "padrao") {
            let alert = CustomAlertController(title: "Atenção!", message: "Por favor, selecione uma imagem.")
            self.present(alert.showAlert(), animated: true, completion: nil)
            return
        }
        
            let uniqueIdentifier = UUID().uuidString
            
            let selectedImage = self.photoImageView.image
                if let uploadImage = selectedImage?.jpegData(compressionQuality: 0.3) {
                    let refPostImage = images
                        .child("posts")
                        .child("\(uniqueIdentifier).jpg")
                    
                    refPostImage.putData(uploadImage) { metaData, error in
                        if error == nil {
                            
                            refPostImage.downloadURL { url, error in
                                if let imageUrl = url?.absoluteString {
                                    if let description = self.descriptionTextField.text {
                                        if let logedUser = self.auth.currentUser {
                                            
                                            let userID = logedUser.uid
                                            
                                            self.firestore.collection("posts")
                                                .document(userID)
                                                .collection("user_posts")
                                                .addDocument(data: [
                                                    "description": description,
                                                    "url": imageUrl
                                                ]) { error
                                                    in
                                                    if error == nil {
                                                        self.navigationController?.popViewController(animated: true)
                                                    }
                                                }
                                        }
                                    }
                                }
                            }
                            print("Success")
                        } else {
                            let alert = CustomAlertController(title: "Erro!", message: "Erro ao fazer upload da imagem.")
                            self.present(alert.showAlert(), animated: true, completion: nil)
                        }
                    }
                }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
