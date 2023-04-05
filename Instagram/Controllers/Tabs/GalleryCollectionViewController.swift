//
//  GalleryCollectionViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 05/04/23.
//

import UIKit


class GalleryCollectionViewController: UICollectionViewController {
    
    var user: Dictionary<String,Any>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "galleryCell", for: indexPath) as! GalleryCollectionViewCell
        
        cell.galleryImageView.image = UIImage(named: "padrao")
        cell.descriptionLabel.text = "Texto"
        
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
}
