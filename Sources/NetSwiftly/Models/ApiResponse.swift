//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 01.03.24.
//

import Foundation

public struct ApiResponse<T: Decodable>: Decodable {
    public let error: Bool
    public let data: T?
    public let message: String?
}

public struct SimpleResponse: Decodable {
    public let error: Bool
    public let message: String?
}

