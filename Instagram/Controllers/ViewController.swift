//
//  ViewController.swift
//  Instagram
//
//  Created by Eduardo Hoffmann on 14/04/23.
//

import UIKit

class ViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 190, height: 184))
        imageView.image = UIImage(named: "instagram-logo-2")
        
        return imageView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        DispatchQueue.main.asyncAfter(deadline: .now()+2) {
            self.performSegue(withIdentifier: "loginSegue", sender: self)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    private func animate() {
        UIView.animate(withDuration: 1) {
            let size = self.view.frame.size.width * 4
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(x: -(diffX)/2,
                                          y: diffY/2,
                                          width: size,
                                          height: size)
            self.imageView.alpha = 0
        }
        
        
    }
}
