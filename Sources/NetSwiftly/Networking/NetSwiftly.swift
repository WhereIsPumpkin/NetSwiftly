// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 13.0.0, *)
public final class NetSwiftly {
    
    public static let shared = NetSwiftly()
    
    private init() {}
    
    func performNetworkRequest<T: Decodable>(for endpoint: EndpointProvider, expecting: T.Type) async throws -> ApiResponse<T> {
        do {
            let request = try endpoint.asURLRequest()
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.invalidResponse
            }
            
            do {
                let decodedResponse = try JSONDecoder().decode(ApiResponse<T>.self, from: data)
                return decodedResponse
            } catch {
                throw NetworkError.decodingError
            }
        } catch {
            throw NetworkError.customError("Failed to construct the request")
        }
    }
    
}
