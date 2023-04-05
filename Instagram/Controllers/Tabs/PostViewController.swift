//
//  PostViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 04/04/23.
//

import UIKit
import FirebaseStorage

class PostViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    var imagePicker = UIImagePickerController()
    var storage: Storage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        storage = Storage.storage()
    
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
        
        let uniqueIdentifier = UUID().uuidString
        
        let selectedImage = self.photoImageView.image
        if let uploadImage = selectedImage?.jpegData(compressionQuality: 0.3) {
            let refPostImage = images
                .child("posts")
                .child("\(uniqueIdentifier).jpg")
            
            refPostImage.putData(uploadImage) { metaData, error in
                if error == nil {
                    print("Success")
                } else {
                    let alert = CustomAlertController(title: "Erro!", message: "Erro ao fazer upload da imagem.")
                    self.present(alert.showAlert(), animated: true, completion: nil)
                }
            }
        }
    }
}
