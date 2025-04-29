//
//  NetworkLogger.swift
//  Mazady
//
//  Created by eslam mohamed on 29/04/2025.
//

import Foundation

class NetworkLogger: NetworkLoggerType {

    func log(request urlRequest: URLRequest) {
        logRequest(urlRequest)
    }

    func log(response urlResponse: URLResponse?, data: Data?, error: Error?) {
        logResponse(urlResponse)
        logData(data)
        logError(error)
    }

}

// MARK: - Private helper methods
private extension NetworkLogger {

     func logRequest(_ request: URLRequest) {

        let httpMethod = request.httpMethod ?? "No HTTP method specified"
        let url = request.url?.absoluteString ?? "No URL specified"

        print("--> \(httpMethod)  \(url)")

        let headers = request.allHTTPHeaderFields ?? [:]
        for (key, value) in headers {
            print("\(key) = \(value)")
        }

        print("\(parseJSON(fromData: request.httpBody) ?? "No Body Data" )")

        print("--> END \(request.httpMethod ?? "No HTTP method" ) ")
    }

    func logResponse(_ response: URLResponse?) {
        guard let httpResponse = response as? HTTPURLResponse else {
            return
        }

        print("<-- \(httpResponse.statusCode) \(httpResponse.url?.absoluteString ?? " no URL specified")")

        let headers = httpResponse.allHeaderFields
        for (key, value) in headers {
            print("\(key) = \(value)")
        }

    }

    func logData(_ data: Data?) {
        guard let json = parseJSON(fromData: data) else {
            print("Could not parse response to JSON")
            return
        }
        print(json)
        print("<-- END HTTP ")
    }

    func logError(_ error: Error?) {
        guard let error = error else {
            return
        }
        print("\t ** Error \(error.localizedDescription)")
    }

    func parseJSON(fromData data: Data?) -> Any? {
        guard let data = data else {
            return nil
        }
        var json: Any?

        do {
            try json = JSONSerialization.jsonObject(with: data, options: [])
        } catch {
            print("JSON error: \(error.localizedDescription)")
        }

        return json
    }
}

