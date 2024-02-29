//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 29.02.24.
//

import Foundation

public struct ApiError: Error {
    var statusCode: Int?
    let errorCode: String
    var message: String
}
