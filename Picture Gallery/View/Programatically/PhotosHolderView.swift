//
//  CustomView.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import UIKit

class PhotosHolderView : UIView{
    
    //MARK:- Properties
    var titleButton: UIButton = {
        let titleButton = UIButton()
        titleButton.setTitle("Photos", for: .normal)
        titleButton.titleLabel?.textColor = .white
        titleButton.titleLabel?.font = UIFont(name: RUBIK_REGULAR, size: 0.6*Utility.convertHeightMultiplier(constant: 30))
        titleButton.titleLabel?.textAlignment = .center
        return titleButton
    }()
    
    var redBar: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 2
        return view
    }()
    
    var photoCollectionView : UICollectionView!
    var photoCellIdentifier : String = "photoPickerCell"
    
    
    //MARK:- Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Functions
    fileprivate func setUpSubviews(){
        self.backgroundColor = .black
        
        addSubview(titleButton)
        titleButton.anchor(top: self.topAnchor, centerX: self.centerXAnchor, paddingTop: Utility.convertHeightMultiplier(constant: 40), width: Utility.convertWidthMultiplier(constant: 110), height: Utility.convertWidthMultiplier(constant: 30))
        
        
        addSubview(redBar)
        redBar.anchor(top: titleButton.bottomAnchor, centerX: titleButton.centerXAnchor,
                      paddingTop: 0,width: Utility.convertWidthMultiplier(constant: 20),
                      height: Utility.convertHeightMultiplier(constant: 3))

        
        let collectionViewWidth = UIScreen.main.bounds.width - Utility.convertWidthMultiplier(constant: 34)
                
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: (collectionViewWidth/3) - Utility.convertWidthMultiplier(constant: 5), height: (collectionViewWidth/3) - Utility.convertWidthMultiplier(constant: 5))
        layout.minimumInteritemSpacing = Utility.convertWidthMultiplier(constant: 5)
        layout.minimumLineSpacing = Utility.convertWidthMultiplier(constant: 5)
        
        
        photoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        addSubview(photoCollectionView)
        
        photoCollectionView.anchor(top: redBar.bottomAnchor,
                                   left: self.leftAnchor,
                                   bottom: self.bottomAnchor,
                                   right: self.rightAnchor,
                                   paddingTop: Utility.convertHeightMultiplier(constant: 30),
                                   paddingLeft: Utility.convertWidthMultiplier(constant: 17),
                                   paddingBottom: 0,
                                   paddingRight: Utility.convertWidthMultiplier(constant: 17),
                                   width: 0, height: 0)
        
        photoCollectionView.backgroundColor = .black
        photoCollectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: photoCellIdentifier)
    }

    //MARK:- Button Actions
}



class PhotoCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    var photoImageView : UIImageView!
    var isCellSelected : Bool = false

    //MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.cornerRadius = Utility.convertHeightMultiplier(constant: 10)
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    fileprivate func setUpViews(){
        
        // Main Image View
        photoImageView = UIImageView()
        addSubview(photoImageView)
        
        photoImageView.layer.cornerRadius = 10
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        
        photoImageView.anchor(top: self.topAnchor,
                              left: self.leftAnchor,
                              bottom: self.bottomAnchor,
                              right: self.rightAnchor,
                              paddingTop: 0,
                              paddingLeft: 0,
                              paddingBottom: 0,
                              paddingRight: 0,
                              width: 0,
                              height: 0)
        
        photoImageView.image = #imageLiteral(resourceName: "placeholder")
    }

    //MARK: - Button Actions
}
