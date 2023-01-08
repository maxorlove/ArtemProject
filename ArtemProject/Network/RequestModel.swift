//
//  RequestModel.swift
//  AviasalesTest
//
//  Created by Ivan Berkut on 01.05.2021.
//

import Foundation

enum RequestHTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

class RequestModel: NSObject {

    // MARK: - Properties
    var path: String {
        return ""
    }
    var parameters: [String: Any?] {
        return [:]
    }
    var headers: [String: String] {
        return [:]
    }
    var method: RequestHTTPMethod {
        return body.isEmpty ? RequestHTTPMethod.get : RequestHTTPMethod.post
    }
    var body: [String: Any?] {
        return [:]
    }

}

extension RequestModel {

    func urlRequest() -> URLRequest {
        var endpoint: String = ServiceManager.shared.baseURL.appending(path)

        if !parameters.isEmpty {
            endpoint.append("?")
        }
        for parameter in parameters {
            if let value = parameter.value {
                endpoint.append("\(parameter.key)=\(value)&")
            }
        }
        let urlString = endpoint.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)!
        let url = URL(string: urlString)!
        var request: URLRequest = URLRequest(url: url)

        request.httpMethod = method.rawValue

        for header in headers {
            request.addValue(header.value, forHTTPHeaderField: header.key)
        }

        if method == RequestHTTPMethod.post {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: JSONSerialization.WritingOptions.prettyPrinted)
            } catch let error {
                print(error)
            }
        }

        return request
    }
    
}
