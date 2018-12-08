//
//  DeviceApi.swift
//  RemoteHome
//
//  Created by John Forde on 27/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import PromiseKit

public typealias HTTPHeaders = [String: String]
public typealias Parameters = [String: String]

public enum HTTPMethod: String {
	case get = "GET"
	case post = "POST"
}

public class RestClient {
	var baseURL: String

	var token: String?

	var defaultHeader: HTTPHeaders = [
		"Content-Type": "application/json",
		"Accept": "application/json"
	]

	public init(token: String?) {
		self.token = token
		let apiConfig = ApiConfig()
		baseURL = apiConfig.getBaseUrl()
	}

	private func makeUrlRequest(_ resource: Resource, headers: HTTPHeaders, parameters: Parameters) throws -> URLRequest {

		let urlComponents = NSURLComponents(string: "\(baseURL)\(resource.resource.route)")
		if !parameters.isEmpty {
			urlComponents?.queryItems = decodeParameters(parameters)
		}

		guard let components = urlComponents, let url = components.url else { fatalError("urlComponents or urlComponents.url is nil") }

		var rq = URLRequest(url: url)
		rq.httpMethod = HTTPMethod(rawValue: resource.resource.method.rawValue).map { $0.rawValue }
		rq.allHTTPHeaderFields = defaultHeader
		addHeaders(headers, request: &rq)

		if let token = token {
			rq.addValue(token, forHTTPHeaderField: "Authorization")
			print("token: \(token)")
		}
		return rq
	}

	private func decodeParameters(_ parameters: Parameters) -> [URLQueryItem] {
		var queryItems: [URLQueryItem] = []
		for (key, value) in parameters {
			queryItems.append(URLQueryItem(name: key, value: value))
		}
		return queryItems
	}

	private func addHeaders(_ headers: HTTPHeaders, request: inout URLRequest) {
		for (key, value) in headers {
			request.addValue(value, forHTTPHeaderField: key)
		}
	}

	public func request<T: Decodable>(_ resource: Resource, parameters: Parameters = [:], headers: HTTPHeaders = [:]) -> Promise<T> {
		return Promise { seal in
			URLSession.shared.dataTask(.promise, with: try makeUrlRequest(resource, headers: headers, parameters: parameters)).validate().map {
			try JSONDecoder().decode(T.self, from: $0.data)
			}.done { json in
				seal.fulfill(json)
			}.catch { error in
				seal.reject(error)
			}
		}
	}
}

public enum Resource {
	case temperature
	case aircon

	public var resource: (method: HTTPMethod, route: String) {
		switch self {
		case .temperature:
			return (.get ,"/temperature")
		case .aircon:
			return (.post, "/aircon")
		}
	}
}
