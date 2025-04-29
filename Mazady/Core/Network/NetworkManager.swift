//
//  NetworkManager.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

struct NetworkManager: NetworkManagerProtocol {

    static let shared = NetworkManager()
    private let logger = NetworkLogger()
    private let session = URLSession(configuration: .default)

    var logResponse: Bool = true

    // MARK: - Async/Await API

    @discardableResult
    func executeRequest<T: Decodable>(_ request: NetworkRequest) async throws -> T {
        let urlRequest = try prepareURLRequest(for: request)
        let (data, response) = try await session.data(for: urlRequest)

        if logResponse {
            logger.log(response: response, data: data, error: nil)
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            throw HTTPNetworkError.invalidResponse
        }

        var responseData = data
        if responseData.isEmpty, httpResponse.statusCode < 400 {
            responseData = Data("{}".utf8)
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(T.self, from: responseData)
        } catch {
            if let errorResponse = try? decoder.decode(ErrorResponse.self, from: data) {
                throw HTTPNetworkError.error(statusCode: httpResponse.statusCode, message: errorResponse.message)
            }
            throw HTTPNetworkError.decodingError(error)
        }
    }

    // MARK: - Completion Handler API (for backward compatibility)

    func executeRequest<T: Decodable>(_ request: NetworkRequest, completion: @escaping (Result<T, HTTPNetworkError>) -> Void) {
        Task {
            do {
                let result: T = try await executeRequest(request)
                completion(.success(result))
            } catch let error as HTTPNetworkError {
                completion(.failure(error))
            } catch {
                completion(.failure(.decodingError(error)))
            }
        }
    }

    // MARK: - Helper

    private func prepareURLRequest(for request: NetworkRequest) throws -> URLRequest {
        let fullUrl = "\(APIEndpoints.baseURL)\(request.path)"

        guard let url = URL(string: fullUrl) else {
            throw HTTPNetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30
        urlRequest.httpMethod = request.method.rawValue

        // Parameters
        switch request.parameters {
        case .body(let params):
            if let params {
                urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params, options: [.sortedKeys])
            }
        case .url(let params):
            if let params {
                guard var components = URLComponents(string: fullUrl) else {
                    throw HTTPNetworkError.decodingFailed
                }
                let queryParams = params.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
                components.queryItems = queryParams
                urlRequest.url = components.url
            }
        }

        // Headers
        request.headers?.forEach { header in
            urlRequest.addValue(header.value, forHTTPHeaderField: header.key.rawValue)
        }

        logger.log(request: urlRequest)
        return urlRequest
    }
}
