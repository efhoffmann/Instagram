//
//  HomeViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 04/04/23.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorageUI


class HomeViewController: UIViewController {
    
    @IBOutlet weak var noPostsLabel: UILabel!
    @IBOutlet weak var postsTableView: UITableView!
    
    var firestore: Firestore!
    var auth: Auth!
    var posts: [Dictionary<String, Any>] = []
    var userLoggedId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        postsTableView.separatorStyle = .none
        firestore = Firestore.firestore()
        auth = Auth.auth()
        
        if let userId = auth.currentUser?.uid {
            self.userLoggedId = userId
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        recoveryPosts()
    }
    
    func recoveryPosts() {
        self.posts.removeAll()
        self.postsTableView.reloadData()
        
        firestore.collection("posts")
            .document(userLoggedId)
            .collection("user_posts")
            .getDocuments { resultSnapshot, error in
                if let snapshot = resultSnapshot {
                    for document in snapshot.documents {
                        let data = document.data()
                        self.posts.append(data)
                    }
                    self.postsTableView.reloadData()
                }
            }
    }
}
    
    // MARK: - Tables
    
    extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
     
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            
            if self.posts.count > 0 {
                       //self.collectionView.backgroundView = nil
                       return self.posts.count
                   }else{
                       noPostsLabel.text = "Você ainda não tem postagens."
                   }
                   return 0
               }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = postsTableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
            
            let index = indexPath.row
            let post = self.posts[index]
            
            let description = post["description"] as? String
            if let url = post["url"] as? String {
                cell.postImageView.sd_setImage(with: URL(string: url))
            }
            
            cell.descriptionLabel.text = description
           
            
            return cell
        }
    }

    
    
