//
//  File.swift
//  Picture Gallery
//
//  Created by Iftiquar Ahmed Ove on 22/6/22.
//

import Foundation

typealias Photo = [PhotoElement]

// MARK: - PhotoElement
struct PhotoElement: Codable {
    let id: String?
    let createdAt, updatedAt: String?
    let width, height: Int?
    let color, blurHash: String?
    let urls: Urls?
    let links: Links?

    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case width, height, color
        case blurHash = "blur_hash"
        case urls, links
    }
}

// MARK: - Links
struct Links: Codable {
    let linksSelf, html, download, downloadLocation: String?

    enum CodingKeys: String, CodingKey {
        case linksSelf = "self"
        case html, download
        case downloadLocation = "download_location"
    }
}

// MARK: - Urls
struct Urls: Codable {
    let raw, full, regular, small: String?
    let thumb, smallS3: String?

    enum CodingKeys: String, CodingKey {
        case raw, full, regular, small, thumb
        case smallS3 = "small_s3"
    }
}
