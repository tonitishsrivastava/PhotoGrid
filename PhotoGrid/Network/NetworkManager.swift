//
//  NetworkManager.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import Foundation



// MARK: - API Manager

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = URL(string: AppConstant.IMAGE_LIST_URL)
    private var currentTask: URLSessionDataTask?
    
    private init() {}
    
    func fetchImages(completion: @escaping (Result<[ImageModel], HttpError>) -> Void) {
        // Cancel the previous task if it exists
        currentTask?.cancel()
        
        guard let baseURL = baseURL else {
            
            return completion(.failure(.badURL))
        }
        
        let request = URLRequest(url: baseURL)
        
        currentTask = URLSession.shared.dataTask(with: request) { data, response, error in
            defer { self.currentTask = nil }
            
            // check for error
            guard error == nil else { return completion(.failure(HttpError.serverError)) }
            
            // check for success staus code
            guard let httpStausCode = (response as? HTTPURLResponse)?.statusCode,
                  (200...299).contains(httpStausCode) else {
                      return completion(.failure(HttpError.nonSuccessStatusCode))
                  }
            guard let data = data else {
                completion(.failure(HttpError.invalidData))
                return
            }
            // check if serverData is not empty
            guard data.isEmpty == false else {
                return completion(.failure(HttpError.noData))
                
            }
            
            // decode the result
            do {
                let imageModel = try JSONDecoder().decode([ImageModel].self, from: data)
                completion(.success(imageModel)) // return success
            }catch {
                // return decode error
                completion(.failure(.jsonDecoding))
            }
        }
        
        currentTask?.resume()
    }
}
