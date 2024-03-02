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
    
    public func performRequest<T: Decodable>(
        request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        log("🚀 Starting request to \(request.url?.absoluteString ?? "unknown URL")")
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                log("📥 Received response with status code: \(httpResponse.statusCode)")
            }
            
            if let rawJSONString = String(data: data, encoding: .utf8) {
                log("📄 Received JSON: \(rawJSONString)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                if let decodedError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    log("⚠️ Server error message: \(decodedError.message)")
                    throw NetworkError.serverMessage(decodedError.message)
                } else {
                    log("❌ Failed to decode server error message.")
                    throw NetworkError.requestFailed
                }
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy
                let decodedData = try decoder.decode(T.self, from: data)
                log("✅ Successfully decoded response of type \(T.self)")
                return decodedData
            } catch {
                log("🐛 Decoding error for request to \(request.url?.absoluteString ?? "unknown URL"): \(error)")
                throw NetworkError.decodingError
            }
        } catch {
            log("💥 Network request failed: \(error)")
            throw error
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
