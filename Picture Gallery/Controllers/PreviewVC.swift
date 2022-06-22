//
//  PreviewVC.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import UIKit
import Photos

class PreviewVC: UIViewController {
    
    //MARK: - Properties
    var imageURL: String!{
        didSet{
            imageView.loadImageUsingCache(withUrl: imageURL, placeHolder: false)
        }
    }
    
    /// ratio determines wheather potrait/landscape image and resize imageView accordingly
    var ratio: CGFloat!
    
    var imageViewWidthConstraint: NSLayoutConstraint!
    var imageViewHeightConstraint: NSLayoutConstraint!
    
    lazy var imageView : UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .clear
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 3
        return iv
    }()
    
    lazy var BackButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Back", for: .normal)
        btn.titleLabel?.font = UIFont(name: RUBIK_SEMIBOLD, size: Utility.convertWidthMultiplier(constant: 20))
        btn.addTarget(self, action: #selector(backButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var SaveButton : UIButton = {
        let btn = UIButton()
        btn.setTitle("Save", for: .normal)
        btn.backgroundColor = UIColor.init(hexString: "#FF69B4")
        btn.layer.cornerRadius = 4
        btn.layer.borderColor = UIColor.white.cgColor
        btn.layer.borderWidth = 2.0
        btn.titleLabel?.font = UIFont(name: RUBIK_SEMIBOLD, size: Utility.convertWidthMultiplier(constant: 20))
        btn.addTarget(self, action: #selector(saveButtonTapped(_:)), for: .touchUpInside)
        return btn
    }()
    
    lazy var shareButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "share"), for: .normal)
        btn.addTarget(self, action: #selector(shareButtonTapped(_:)), for: .touchUpInside)
        return btn
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
        view.addSubview(BackButton)
        BackButton.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: Utility.convertHeightMultiplier(constant: 70), paddingLeft: 10, width: 50, height: 20)
        
        view.addSubview(shareButton)
        shareButton.anchor(top: view.topAnchor, right: view.rightAnchor, paddingTop: Utility.convertHeightMultiplier(constant: 70), paddingRight: 10, width: 20, height: 20)
        
        view.addSubview(imageView)
        imageView.anchor(centerX: view.centerXAnchor ,centerY: view.centerYAnchor, xConstant: 0, yConstant: Utility.convertHeightMultiplier(constant: -40))
        
        
        imageViewWidthConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.width, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: Utility.convertHeightMultiplier(constant: 414))
        imageViewWidthConstraint.isActive = true
        
        
        imageViewHeightConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: Utility.convertHeightMultiplier(constant: 600))
        imageViewHeightConstraint.isActive = true
        
        //Landscape
        if ratio < 1.0 {
            self.imageViewHeightConstraint.setMultiplier(ratio, of: &self.imageViewHeightConstraint)
            self.imageViewWidthConstraint.setMultiplier(1.0, of: &self.imageViewWidthConstraint)
        }
        //Potrait
        else if ratio > 1.0{
            self.imageViewWidthConstraint.setMultiplier(ratio, of: &self.imageViewWidthConstraint)
            self.imageViewHeightConstraint.setMultiplier(1.0, of: &self.imageViewHeightConstraint)
        }
        else{
            imageView.setAspectRatio(1.0).isActive = true
        }
        
        view.addSubview(SaveButton)
        SaveButton.anchor(top: imageView.bottomAnchor, centerX: view.centerXAnchor, paddingTop: Utility.convertHeightMultiplier(constant: 50) ,width: Utility.convertHeightMultiplier(constant: 120), height: Utility.convertHeightMultiplier(constant: 50))
    }
    
    // Write to Gallery helper Function
        @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
            if error != nil {
                Utility.showAlert(self, "Error!", "Something went wrong, please try again!")
            } else {
                Utility.showAlert(self, "Saved", "Succesfully saved in your gallery!")
            }
        }

    
    //MARK: - Button Actions
    
    @IBAction @objc func backButtonTapped(_ sender: UIButton){
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction @objc func saveButtonTapped(_ sender: UIButton){
        guard let image = imageView.image else {
            showToast(message: "Wait To load The image first!")
            return
        }
        UIImageWriteToSavedPhotosAlbum(image , self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else {
            showToast(message: "Wait To load The image first!")
            return
        }
        
        // set up activity view controller
        let imageToShare = [image]
        let activityViewController = UIActivityViewController(activityItems: imageToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
    }
}
