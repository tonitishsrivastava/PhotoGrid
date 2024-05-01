//
//  ImageModel.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import Foundation


struct Thumbnail: Codable {
    let id: String
    let version: Int?
    let domain: String
    let basePath: String
    let key: String
    let qualities: [Int]
    let aspectRatio: Int
}

struct BackupDetails: Codable {
    let pdfLink: String
    let screenshotURL: String
}

struct ImageModel: Codable {
    let id: String
    let title: String
    let language: String
    let thumbnail: Thumbnail
    let mediaType: Int
    let coverageURL: String
    let publishedAt: String
    let publishedBy: String
    let backupDetails: BackupDetails?
    var imageUrl: String {
        return "\(thumbnail.domain)/\(thumbnail.basePath)/0/\(thumbnail.key)"
    }
}
