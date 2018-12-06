//
//  UserSignUpInfo.swift
//  RemoteHome
//
//  Created by John Forde on 24/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

struct UserSignUpInfo: CustomStringConvertible {

	let email: String
	let firstName: String
	let lastName: String
	let password1: String
	let password2: String

	var description: String {
		return "email: \(email), name: \(firstName) \(lastName) password size: \(password1.count)"
	}
}

