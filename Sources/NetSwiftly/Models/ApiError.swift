//
//  NetworkError.swift
//
//
//  Created by Saba Gogrichiani on 29.02.24.
//

import Foundation

public enum NetworkError: Error {
    case badURL
    case requestFailed
    case decodingError
    case serverMessage(String)
}
