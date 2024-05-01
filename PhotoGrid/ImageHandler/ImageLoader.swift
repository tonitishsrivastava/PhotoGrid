//
//  ImageLoader.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import Foundation
import UIKit


class ImageLoader {
    static let shared = ImageLoader()
    private let cache = ImageCache.shared
    private var activeTasks: [URL: URLSessionDataTask] = [:]
    private let maxConcurrentTasks = 20 // Adjust as needed
    private let queue = DispatchQueue(label: "com.interview.photo-grid.PhotoGrid.ImageLoaderQueue")
    
    private init() {}
    
    func loadImage(from url: URL, completion: @escaping (Result<UIImage, HttpError>) -> Void) {
        // Check cache first
        if let cachedData = cache.retrieveImage(forKey: url.absoluteString) {
            completion(.success(cachedData))
            return
        }
        
        queue.sync {
            // If task is already active, don't start a new one
            if activeTasks[url] != nil {
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
                defer {
                    self?.queue.async {
                        self?.activeTasks.removeValue(forKey: url)
                    }
                }
                
                if error != nil {
                    completion(.failure(.serverError))
                    return
                }
                
                guard let data = data, let image = UIImage(data: data) else {
                    completion(.success(.placeholder!))
                    return
                }
                
                self?.cache.storeImage(image, forKey: url.absoluteString)
                completion(.success(image))
            }
            
            // Limit concurrent tasks
            if activeTasks.count >= maxConcurrentTasks {
                // Cancel the oldest task
                if let oldestTask = activeTasks.first {
                    oldestTask.value.cancel()
                    activeTasks.removeValue(forKey: oldestTask.key)
                }
            }
            
            // Start new task
            task.resume()
            activeTasks[url] = task
        }
    }
}
