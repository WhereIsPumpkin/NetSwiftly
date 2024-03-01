//
//  File.swift
//  
//
//  Created by Saba Gogrichiani on 01.03.24.
//

import Foundation

public struct BackendMessage: Decodable, Error {
    public let message: String
    public let error: Bool
}
