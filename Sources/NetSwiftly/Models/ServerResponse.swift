//
//  ServerResponsec.swift
//
//
//  Created by Saba Gogrichiani on 01.03.24.
//

import Foundation

protocol ServerResponse: Decodable {
    var error: Bool { get }
    var message: String? { get }
}
