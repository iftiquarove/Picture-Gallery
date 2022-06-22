//
//  ViewController.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import UIKit

class HomeVC: UIViewController {
    
    //MARK: - Properties
    
    ///page number indicates the page from where image will be shown, pagination happens by updating it.
    var page = 1
    lazy var photosHolderView = PhotosHolderView()
    var imageModel = [ImageModel]()
    let parsingVM = ParsingVM()

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
        parsingVM.parsePhotoByPage(page: page) { [weak self] error, imageModelArray in
            guard let strongSelf = self else {return}
            
            if error != nil{
                Utility.showAlert(strongSelf, "Error", "Something went Wrong!")
                return
            }
            for each in imageModelArray ?? []{
                strongSelf.imageModel.append(each)
            }
            DispatchQueue.main.async {
                strongSelf.photosHolderView.photoCollectionView.reloadData()
            }
        }
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photosHolderView.photoCellIdentifier, for: indexPath) as! PhotoCollectionViewCell
        cell.photoImageView.loadImageUsingCache(withUrl: imageModel[indexPath.row].thumbImageUrl, placeHolder: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("image Tapped of : ",indexPath.row)
        let vc = PreviewVC()
        vc.ratio = imageModel[indexPath.row].ratio
        vc.imageURL = imageModel[indexPath.row].previewImageUrl
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == imageModel.count - 5 {
            page = page + 1
            parseAPI(with: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: {[self] () -> UIViewController? in
            let vc = SelectViewControllerZoomed()
            vc.imageURL = imageModel[indexPath.row].previewImageUrl
            vc.preferredContentSize = vc.imageToZoom.image?.size ?? CGSize(width: 500, height: 500)
            return vc
        })
    }
}
