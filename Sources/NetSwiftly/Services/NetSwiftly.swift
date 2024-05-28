// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import os.log

@available(iOS 14.0.0, *)
public final class NetSwiftly {
    
    public static let shared = NetSwiftly()
    
    public var debugEnabled: Bool = false
    public var logger: Logger = Logger(subsystem: "com.default.networking", category: "Networking")

    private let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func setupLogger(subsystem: String, category: String) {
        self.logger = Logger(subsystem: subsystem, category: category)
    }

    public func performRequest<T: Decodable>(
        request: URLRequest,
        responseType: T.Type
    ) async throws -> T {
        logger.debug(" Starting request to \(request.url?.absoluteString ?? "unknown URL", privacy: .sensitive)")
        
        do {
            let (data, response) = try await urlSession.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                logger.info(" Received response with status code: \(httpResponse.statusCode)")
            }
            
            if let rawJSONObject = try? JSONSerialization.jsonObject(with: data),
               let prettyPrintedData = try? JSONSerialization.data(withJSONObject: rawJSONObject, options: .prettyPrinted),
               let jsonString = String(data: prettyPrintedData, encoding: .utf8) {
                logger.debug(" Received JSON: \(jsonString, privacy: .sensitive)")
            }
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                if let decodedError = try? JSONDecoder().decode(APIErrorResponse.self, from: data) {
                    logger.error(" Server error message: \(decodedError.message, privacy: .sensitive)")
                    throw NetworkError.serverMessage(decodedError.message)
                } else {
                    logger.error(" Failed to decode server error message.")
                    throw NetworkError.requestFailed
                }
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(T.self, from: data)
                logger.debug(" Successfully decoded response of type \(T.self)")
                return decodedData
            } catch {
                logger.error(" Decoding error for request to \(request.url?.absoluteString ?? "unknown URL", privacy: .sensitive): \(error.localizedDescription, privacy: .public)")
                throw NetworkError.decodingError
            }
        } catch {
            logger.error(" Network request failed: \(error.localizedDescription, privacy: .public)")
            throw error
        }
    }
}
