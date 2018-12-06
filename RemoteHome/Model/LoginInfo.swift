//
//  LoginInfo.swift
//  RemoteHome
//
//  Created by John Forde on 24/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

struct LoginInfo: CustomStringConvertible {

	let email: String
	let password: String

	var description: String {
		return "email: \(email), password size: \(password.count)"
	}
}
