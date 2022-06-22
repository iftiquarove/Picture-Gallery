//
//  zoomVC.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import UIKit
import Photos

class SelectViewControllerZoomed: UIViewController {
    
    //MARK: - Properties
    var imageURL: String!
    lazy var imageToZoom : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.backgroundColor = .clear
        return iv
    }()
  
    
    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        handle_appearance()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Functions
    
    private func handle_appearance(){
        self.view.backgroundColor = .black
        if imageURL != nil{
            view.addSubview(imageToZoom)
            imageToZoom.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
            imageToZoom.loadImageUsingCache(withUrl: imageURL)
        }
    }
}

