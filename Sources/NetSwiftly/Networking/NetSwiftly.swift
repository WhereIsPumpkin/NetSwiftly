// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

@available(iOS 13.0.0, *)
public final class NetSwiftly {
    
    public static let shared = NetSwiftly()
    
    /// Debug flag
    public var debugEnabled: Bool = false
    
    private init() {}
    
    public func fetchData<T: Decodable>(from urlRequest: URLRequest, decodeTo type: T.Type) async throws -> T {
        if debugEnabled {
            print("🌐 Fetching data from: \(urlRequest.url?.absoluteString ?? "Unknown URL")")
        }
        
        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        
        if let httpResponse = response as? HTTPURLResponse {
            if debugEnabled {
                print("🚦 HTTP Status Code: \(httpResponse.statusCode)")
            }
            guard httpResponse.statusCode == 200 else {
                if debugEnabled {
                    print("❌ Error: Bad Server Response (\(httpResponse.statusCode))")
                }
                throw URLError(.badServerResponse)
            }
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        do {
            let decodedData = try decoder.decode(T.self, from: data)
            if debugEnabled {
                print("✅ Successfully decoded \(T.self)")
            }
            return decodedData
        } catch {
            if debugEnabled {
                print("❌ Decoding error: \(error)")
            }
            throw error
        }
    }
    
}
