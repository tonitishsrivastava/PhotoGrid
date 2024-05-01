//
//  ImageCache.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import Foundation
import UIKit


class ImageCache {
    static let shared = ImageCache()
    private let memoryCache = NSCache<NSString, UIImage>()
    private let diskCacheDirectory: URL
    
    private init() {
        // Set up disk cache directory
        let diskCacheURL = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0].appendingPathComponent(AppConstant.DIRECTORY_NAME)
        diskCacheDirectory = diskCacheURL
        
        // Ensure the disk cache directory exists
        try? FileManager.default.createDirectory(at: diskCacheDirectory, withIntermediateDirectories: true, attributes: nil)
    }
    
    func storeImage(_ image: UIImage, forKey key: String) {
        // Store in memory cache
        memoryCache.setObject(image, forKey: key as NSString)
        
        // Store in disk cache
        let fileURL = diskCacheDirectory.appendingPathComponent(key)
        if let data = image.jpegData(compressionQuality: 1.0) {
            try? data.write(to: fileURL)
        }
    }
    
    func retrieveImage(forKey key: String) -> UIImage? {
        // Check memory cache first
        if let cachedImage = memoryCache.object(forKey: key as NSString) {
            return cachedImage
        }
        
        // Check disk cache
        let fileURL = diskCacheDirectory.appendingPathComponent(key)
        if let data = FileManager.default.contents(atPath: fileURL.path), let image = UIImage(data: data) {
            // Store in memory cache
            memoryCache.setObject(image, forKey: key as NSString)
            return image
        }
        
        return nil
    }
}

