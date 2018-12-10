//
//  Error+Utils.swift
//  RemoteHome
//
//  Created by John Forde on 9/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation
import PromiseKit

extension Error {
	func getReason() -> String {
		if let response = self as? PMKHTTPError,
			let fr = response.failureReason,
			let jsonReason = fr.convertToDictionary(),
			let reason = jsonReason["message"] as? String {
			return reason
		} else if let response = self as? RHError {
			switch response {
			case .token(let reason):
				return reason
			}
		}
		return localizedDescription
	}
}
