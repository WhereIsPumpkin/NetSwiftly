// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 13.0.0, *)
public final class NetSwiftly {
    
    public static let shared = NetSwiftly()
    
    public var debugEnabled: Bool = false
    private let urlSession: URLSession
    private var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .iso8601
    
    private init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    public func setDateDecodingStrategy(_ strategy: JSONDecoder.DateDecodingStrategy) {
        self.dateDecodingStrategy = strategy
    }
    
    public func performRequest<T: Decodable>(with urlRequest: URLRequest, decodeTo type: T.Type) async throws -> ApiResponse<T> {
        log("🌐 Making request to: \(urlRequest.url?.absoluteString ?? "Unknown URL")")
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetSwiftlyError.unknownError
            }
            
            log("🚦 HTTP Status Code: \(httpResponse.statusCode)")
            guard 200...299 ~= httpResponse.statusCode else {
                log("❌ Error: Bad Server Response (\(httpResponse.statusCode))")
                throw NetSwiftlyError.badServerResponse(httpResponse.statusCode)
            }
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = self.dateDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(ApiResponse<T>.self, from: data)
                log("✅ Successfully decoded \(T.self)")
                return decodedData
            } catch {
                log("❌ Decoding error: \(error)")
                throw NetSwiftlyError.decodingError(error)
            }
        } catch {
            log("❌ Network error: \(error)")
            throw NetSwiftlyError.networkError(error)
        }
    }
    
    public func performRequest(with urlRequest: URLRequest) async throws -> SimpleResponse {
        log("🌐 Making request to: \(urlRequest.url?.absoluteString ?? "Unknown URL")")
        
        do {
            let (data, response) = try await urlSession.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetSwiftlyError.unknownError
            }
            
            log("🚦 HTTP Status Code: \(httpResponse.statusCode)")
            guard 200...299 ~= httpResponse.statusCode else {
                log("❌ Error: Bad Server Response (\(httpResponse.statusCode))")
                throw NetSwiftlyError.badServerResponse(httpResponse.statusCode)
            }
            
            log("✅ Request successful with status code \(httpResponse.statusCode)")
            
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = self.dateDecodingStrategy
            
            do {
                let decodedData = try decoder.decode(SimpleResponse.self, from: data)
                log("✅ Successfully decoded \(SimpleResponse.self)")
                return decodedData
            } catch {
                log("❌ Decoding error: \(error)")
                throw NetSwiftlyError.decodingError(error)
            }
        } catch {
            log("❌ Network error: \(error)")
            throw NetSwiftlyError.networkError(error)
        }
    }
}

@available(iOS 13.0.0, *)
extension NetSwiftly {
    private func log(_ message: String) {
        if debugEnabled {
            print(message)
        }
    }
}
