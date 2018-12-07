//
//  String+Utils.swift
//  RemoteHome
//
//  Created by John Forde on 8/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

extension String {
	func convertToDictionary() -> [String: Any]? {
		if let data = self.data(using: .utf8) {
			do {
				return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
			} catch {
				print(error.localizedDescription)
			}
		}
		return nil
	}
}
