//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 01.03.24.
//

import Foundation

public struct ApiResponse<T: Decodable>: ServerResponse {
    public let error: Bool
    public let data: T?
    public let message: String?
}

public struct EmptyResponse: Decodable {}
