//
//  GalleryCollectionViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 05/04/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorageUI

class GalleryCollectionViewController: UICollectionViewController {
    
    var user: Dictionary<String,Any>!
    var posts: [Dictionary<String, Any>] = []
    var firestore: Firestore!
    var userSelectedId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        firestore = Firestore.firestore()
        
        if let id = user["id"] as? String {
            userSelectedId = id
        }
        
        if let name = user["name"] as? String {
            self.navigationItem.title = name
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        recoveryPosts()
    }
    
    func recoveryPosts() {
        self.posts.removeAll()
        self.collectionView.reloadData()
        
        firestore.collection("posts")
            .document(userSelectedId)
            .collection("user_posts")
            .getDocuments { resultSnapshot, error in
                if let snapshot = resultSnapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        self.posts.append(data)
                    }
                    self.collectionView.reloadData()
                }
            }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        return self.posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCollectionViewCell
        
        let index = indexPath.row
        let post = self.posts[index]
        
        let description = post["description"] as? String
        if let url = post["url"] as? String {
            cell.galleryImageView.sd_setImage(with: URL(string: url))
        }
        
        cell.descriptionLabel.text = description
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
        }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        
    }
    
}
