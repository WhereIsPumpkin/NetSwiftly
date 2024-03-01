//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 29.02.24.
//

import Foundation

public enum NetSwiftlyError: Error {
    case badServerResponse(Int)
    case decodingError(Error)
    case networkError(Error)
    case unknownError
}
