//
//  UsersViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 04/04/23.
//

import UIKit
import FirebaseFirestore
import FirebaseStorageUI
import FirebaseAuth

class UsersViewController: UIViewController {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var userTableView: UITableView!
    
    var auth: Auth!
    var firestore: Firestore!
    var users: [Dictionary<String, Any>] = []
    var userId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        auth = Auth.auth()
        firestore = Firestore.firestore()
        self.userSearchBar.delegate = self
        
        if let userLoggedId = auth.currentUser?.uid {
            self.userId = userLoggedId
        }

    }
    
    override func viewDidAppear(_ animated: Bool) {
        recoveryUsers()
    }
    
   /* func recoveryUsers() {
        self.users.removeAll()
        self.userTableView.reloadData()
        
        firestore.collection("users").getDocuments { resultSnapshot, error in
            if let snapshot = resultSnapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self.users.append(data)
                }
                self.userTableView.reloadData()
            }
        }
    }
} */
    
    func recoveryUsers() {
        self.users.removeAll()
        self.userTableView.reloadData()
        
        firestore.collection("users")
            .document(userId)
            .collection("contacts")
            .getDocuments { resultSnapshot, error in
            if let snapshot = resultSnapshot {
                for document in snapshot.documents {
                    let data = document.data()
                    self.users.append(data)
                }
                self.userTableView.reloadData()
            }
        }
    }
}

// MARK: - Tables

extension UsersViewController: UITableViewDelegate, UITableViewDataSource  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
   /* func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
        
    } */
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let contactsTotal = self.users.count
        if contactsTotal == 0 {
            return 1
        }
        return self.users.count
        
    }
    
   /* func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       // var self.users = users.sorted { ($0["name"] as! String) < ($1["name"] as! String)}
        
        let cell = userTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        let user = self.users[indexPath.row]
        
        let name = user["name"] as? String
        let email = user["email"] as? String
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = email
        
        return cell
    } */
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell = userTableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath)
        //let user = self.users[indexPath.row]
        
        if self.users.count == 0 {
            cell.textLabel?.text = "Nenhum contato cadastrado"
            cell.detailTextLabel?.text = ""
            return cell
        }
        let index = indexPath.row
        let contactData = self.users[index]
        
        let name = contactData["name"] as? String
        let email = contactData["email"] as? String
        
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = email
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.userTableView.deselectRow(at: indexPath, animated: true)
        
       // let user = self.users[indexPath.row]
        let index = indexPath.row
        let contact = self.users[index]
        
        self.performSegue(withIdentifier: "gallerySegue", sender: contact)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "gallerySegue" {
            let destinationView = segue.destination as! GalleryCollectionViewController
            destinationView.user = sender as? Dictionary
            
        }
    }
}

//MARK: - SearchBar

extension UsersViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        guard let searchText = userSearchBar.text, searchText != "" else {
            return
        }
        searchUser(text: searchText)
    }
    
    func searchUser(text: String) {
        let filterList: [Dictionary<String, Any>] = self.users
        self.users.removeAll()
        
        for item in filterList {
            if let name = item["name"] as? String {
                if name.lowercased().contains(text.lowercased()) {
                    self.users.append(item)
                }
            }
        }
        self.userTableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            recoveryUsers()
        }
    }
    
}
