//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 01.03.24.
//

import Foundation

struct ApiResponse<T: Decodable>: Decodable {
    let error: Bool
    let message: String
    let data: T?
}
