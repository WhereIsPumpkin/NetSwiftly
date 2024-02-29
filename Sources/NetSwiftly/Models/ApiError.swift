//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 29.02.24.
//

import Foundation

public struct ApiError: Error {
    public var statusCode: Int?
    public let errorCode: String
    public var message: String
}
