//
//  ValidationProtocols.swift
//  RemoteHome
//
//  Created by John Forde on 12/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

protocol ValidatesEmail {
	func isEmailValid(_ email: String) -> Bool
}

protocol ValidatesPassword {
	func isPasswordValid(_ password: String) -> Bool
}

protocol ValidatesUserInfoField {
	func isUserInfoFieldValid(_ userInfoField: String) -> Bool
}

extension ValidatesEmail {
	func isEmailValid(_ email: String) -> Bool {

		let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
		let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
		return emailTest.evaluate(with: email)
	}
}

extension ValidatesPassword {
	func isPasswordValid(_ password: String) -> Bool {
		if password.count < 8 {
			return false
		} else {
			return true
		}
	}
}

extension ValidatesUserInfoField {
	func isUserInfoFieldValid(_ userInfoField: String) -> Bool {
		if userInfoField.count < 3 {
			return false
		} else {
			return true
		}
	}
}
