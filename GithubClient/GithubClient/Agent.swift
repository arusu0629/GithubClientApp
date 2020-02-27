//
//  Agent.swift
//  GithubClient
//
//  Created by Toru Nakandakari on 2020/02/24.
//  Copyright © 2020 仲村渠亨. All rights reserved.
//

import Foundation
import Combine

struct Agent {
    struct Response<T> {
        let value: T
        let response: URLResponse
    }

    enum GithubApiError: Error {
        case network
        case cannotCastHttpResponse
        case cannotDecode
        case unknown
    }

    func run<T: Decodable>(_ request: URLRequest, onDecode: @escaping (Result<Response<T>, GithubApiError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in

            func execCompletionOnMainThread(_ result: Result<Response<T>, GithubApiError>) {
                DispatchQueue.main.async {
                    onDecode(result)
                }
            }

            if error != nil {
                execCompletionOnMainThread(.failure(.network))
                return
            }

            guard let httpResponse = urlResponse as? HTTPURLResponse else {
                execCompletionOnMainThread(.failure(.cannotCastHttpResponse))
                return
            }

            switch httpResponse.statusCode {
            case 200, 201, 204:
                do {
                    let jsonDecoder = JSONDecoder()
                    let value = try jsonDecoder.decode(T.self, from: data ?? Data())
                    let response = Response(value: value, response: httpResponse)
                    execCompletionOnMainThread(.success(response))
                } catch {
                    execCompletionOnMainThread(.failure(.cannotDecode))
                }
            default:
                execCompletionOnMainThread(.failure(.unknown))
            }
        }

        task.resume()
    }
}

enum GithubApi {
    static let agent = Agent()
    static let base = URL(string: "https://api.github.com")!
}

extension GithubApi {
    static func searchUser(name: String, completion: @escaping((Result<Agent.Response<SearchUsersResponse>, Agent.GithubApiError>) -> Void)) {
        let path = "search/users"
        let url = base.appendingPathComponent(path)
        var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: name)
        ]
        let request = URLRequest(url: urlComponents.url!)
        agent.run(request, onDecode: completion)
    }
}
