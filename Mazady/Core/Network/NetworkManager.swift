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
    
    private var session: URLSession = URLSession(configuration: URLSessionConfiguration.default)
    var logResponse: Bool = true
    
    
    func executeRequest<T: Decodable>(_ request: NetworkRequest, completion: @escaping (Result<T, HTTPNetworkError>) -> Void) {
        requestNetwork(request, logResponse: true) { (response: NetworkResponse) in
            if case let NetworkResponse.data(statusCode, data) = response {
                let decoder = JSONDecoder()
                do {
                    var legacyData = data
                    if legacyData.isEmpty, (statusCode ?? 400) < 400 {
                        legacyData = Data("{}".utf8)
                    }
                    let returnResponse = try decoder.decode(T.self, from: legacyData)
                    completion(.success(returnResponse))
                } catch {
                    let errorResponse = try? decoder.decode(ErrorResponse.self, from: data)
                    
                    if let errorMessage = errorResponse?.message,
                       let errorStatusCode = statusCode {
                        let error = HTTPNetworkError.error(statusCode: errorStatusCode, message: errorMessage)
                        completion(.failure(error))
                        return
                    }
                    
                    completion(.failure(.decodingError(error)))
                }
            } else if case let NetworkResponse.error(_, error) = response {
                let error = HTTPNetworkError.error(statusCode: error?.code ?? 0, message: error?.localizedDescription ?? "")
                completion(.failure(error))
            }
        }
    }


    internal func requestNetwork(_ request: NetworkRequest, logResponse: Bool, completion: @escaping (NetworkResponse) -> Void) {
        guard let urlRequest = try? prepareURLRequest(for: request) else { return }
        
        let dataTask = session.dataTask(with: urlRequest) { data, urlResponse, error in
            if logResponse {
                self.logger.log(response: urlResponse, data: data, error: error)
            }
            let response = NetworkResponse((urlResponse as? HTTPURLResponse, data, error), for: request)
            completion(response)
        }
        self.logger.log(request: urlRequest)
        dataTask.resume()
    }
}

//MARK: Helper Methods
private extension NetworkManager {

    func prepareURLRequest(for request: NetworkRequest) throws -> URLRequest {
        let fullUrl = "\(APIEndpoints.baseURL)\(request.path)"
        
        guard let url = URL(string: fullUrl) else {
            throw HTTPNetworkError.invalidURL
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.timeoutInterval = 30
        
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
        
        urlRequest.httpMethod = request.method.rawValue
        return urlRequest
    }
}
