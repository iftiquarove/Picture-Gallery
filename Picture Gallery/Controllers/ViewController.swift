//
//  ViewController.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    
    ///page number indicates the page from where image will be shown, pagination happens by updating it.
    var page = 1
    lazy var photosHolderView = PhotosHolderView()
    
    ///Thumnail images Url, basically small in width and height
    var thumbImageUrls = [String]()
    ///regular images Url, accurate in width and height
    var previewImageUrls = [String]()

    //MARK: - Initializers
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        parseAPI(with: page)
    }
    
    //MARK: - Functions
    private func setupSubviews(){
        view.addSubview(photosHolderView)
        photosHolderView.photoCollectionView.delegate = self
        photosHolderView.photoCollectionView.dataSource = self
        photosHolderView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 0)
    }
    
    private func parseAPI(with page : Int){
        PhotoWebServices.shared.getPhotosByPage(page: page) { status, photoElement, error in
            switch status{
            case 200:
                print("✅ Succesfully parsed page no: ", page)
                photoElement?.forEach({ [self] attributes in
                    thumbImageUrls.append(attributes.urls?.thumb ?? "")
                    previewImageUrls.append(attributes.urls?.regular ?? "")
                })

                DispatchQueue.main.async {
                    self.photosHolderView.photoCollectionView.reloadData()
                }
            default:
                print("❌ parsing Failed for page no: ", page)
                DispatchQueue.main.async {[self] in
                    Utility.showAlert(self, "Error", "Something went Wrong!")
                }
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return thumbImageUrls.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photosHolderView.photoCellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.loadImageUsingCache(withUrl: thumbImageUrls[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == thumbImageUrls.count - 5 {
            page = page + 1
            parseAPI(with: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {[self] () -> UIViewController? in
            let vc = SelectViewControllerZoomed()
            vc.imageURL = previewImageUrls[indexPath.row]
            vc.preferredContentSize = vc.imageToZoom.image?.size ?? CGSize(width: 500, height: 500)
            return vc
        })
    }
}
