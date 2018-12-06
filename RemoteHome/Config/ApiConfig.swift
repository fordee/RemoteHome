//
//  ApiConfig.swift
//  RemoteHome
//
//  Created by John Forde on 6/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

class ApiConfig {

	var keys: Dictionary<String, Any>?

	init() {
		keys = readPropertyList()
		guard keys != nil else {
			fatalError("You must include a ApiConfig.plist file with the necesary values for your api")
		}
	}

	private func readPropertyList() -> Dictionary<String, Any>? {
		if let path = Bundle.main.path(forResource: "ApiConfig", ofType: "plist") {
			let keys = NSDictionary(contentsOfFile: path)
			return keys as? Dictionary<String, Any>
		}
		return nil
	}

	func getBaseUrl() -> String {
		guard let baseUrl = keys?["baseUrl"] as? String else {
			fatalError("You must specify a baseUrl in your ApiConfig.plist file")
		}
		return baseUrl
	}
	
}
