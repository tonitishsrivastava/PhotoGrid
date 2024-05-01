//
//  HttpError.swift
//  PhotoGrid
//
//  Created by Nitish Srivastava on 01/05/24.
//

import Foundation

enum HttpError: Error, CustomStringConvertible {
    case jsonDecoding
    case noData
    case nonSuccessStatusCode
    case serverError
    case emptyCollection
    case emptyObject
    case invalidData
    case badURL
    
    var description: String {
        switch self {
        case .jsonDecoding:
            return AppConstant.JSON_DECODING
        case .noData:
            return AppConstant.NO_DATA
        case .nonSuccessStatusCode:
            return AppConstant.NON_SUCCESS_STATUS
        case .serverError:
            return AppConstant.SERVER_ERROR
        case .emptyCollection:
            return AppConstant.EMPTY_COLLECTION
        case .emptyObject:
            return AppConstant.EMPTY_OBJECT
        case .invalidData:
            return AppConstant.INVALID_DATA
        case .badURL:
            return AppConstant.BAD_URL
        }
    }
}
