//
//  ImageGridManager.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import Foundation
import UIKit


class ImageGridManager {
    static let shared = ImageGridManager()
    private var images: [ImageModel] = []
    private var isLoadingImages = false
    
    private init() {}
    
    func loadImagesIfNeeded(completion: @escaping ([ImageModel]?, HttpError?) -> Void) {
        guard !isLoadingImages else { return }
        isLoadingImages = true
        
        NetworkManager.shared.fetchImages { [weak self] result in
            guard let self = self else { return }
            self.isLoadingImages = false
            
            switch result {
            case .success(let images):
                self.images.append(contentsOf: images)
                completion(images, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    func getImage(at index: Int, completion: @escaping (Result<UIImage, HttpError>) -> Void) {
        guard index >= 0 && index < images.count else {
            completion(.failure(.invalidData))
            return
        }
        
        guard let imageUrl = URL(string: images[index].imageUrl) else {
            return completion(.failure(.badURL))
        }
        
        ImageLoader.shared.loadImage(from: imageUrl) { result in
            switch result {
            case .success(let imageData):
                completion(.success(imageData))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
