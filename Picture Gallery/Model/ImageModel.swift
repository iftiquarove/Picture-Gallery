//
//  ImageModel.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import Foundation
import UIKit

struct ImageModel: Codable{
    ///Thumnail images Url, basically small in width and height
    var thumbImageUrl: String
    ///regular images Url, accurate in width and height
    var previewImageUrl: String
    /// ratio determines wheather potrait/landscape, less than 1.0 == Landscape, >1.0 potrait
    var ratio: CGFloat
}
