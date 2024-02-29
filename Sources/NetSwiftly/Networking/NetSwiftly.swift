// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 13.0.0, *)
public final class NetSwiftly {
    
    public static let shared = NetSwiftly()
    
    private init() {}
    
    public func fetchData<T: Decodable>(from endpoint: EndpointProvider, responseType: T.Type) async throws -> T {
        let request = try endpoint.asURLRequest()
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw ApiError(errorCode: "HTTP_ERROR", message: "Non-200 HTTP response")
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(T.self, from: data)
            return decodedResponse
        } catch {
            throw ApiError(errorCode: "DECODING_ERROR", message: "Failed to decode response")
        }
    }
    
    
}
