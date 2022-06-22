//
//  ParsingVM.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import Foundation
import UIKit

protocol parsingVMDelegate: AnyObject{
    func parsePhotoByPage (page: Int, success: @escaping(_ error: String?, _ imageModel: [ImageModel]?) -> Void)
}

class ParsingVM: parsingVMDelegate{
    func parsePhotoByPage(page: Int, success: @escaping (String?, [ImageModel]?) -> Void) {
        PhotoWebServices.shared.getPhotosByPage(page: page) { status, photoElement, error in
            switch status{
            case 200:
                print("✅ Succesfully parsed page no: ", page)
                var imageModel = [ImageModel]()
                photoElement?.forEach({attributes in
                    let thumb = attributes.urls?.thumb ?? ""
                    let preview = attributes.urls?.regular ?? ""
                    var ratio: CGFloat = 1.0
                    //for potrait
                    if attributes.height ?? 1 > attributes.width ?? 1{
                    ratio = CGFloat(attributes.width ?? 1) / CGFloat(attributes.height ?? 1)
                    }
                    //For landcape
                    else if attributes.height ?? 1 < attributes.width ?? 1{
                        ratio = CGFloat(attributes.height ?? 1) / CGFloat(attributes.width ?? 1)
                    }
                    let imageProperties = ImageModel(thumbImageUrl: thumb, previewImageUrl: preview, ratio: CGFloat(ratio))
                    imageModel.append(imageProperties)
                })
                success(nil,imageModel)
            default:
                print("❌ parsing Failed for page no: ", page)
                success(error?.description,nil)
            }
        }
    }
}
