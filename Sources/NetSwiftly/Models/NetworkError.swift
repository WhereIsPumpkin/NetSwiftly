//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 01.03.24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case decodingError
    case customError(String)
}
