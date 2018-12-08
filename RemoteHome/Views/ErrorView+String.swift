//
//  ErrorView+String.swift
//  RemoteHome
//
//  Created by John Forde on 9/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

extension ErrorView {

	func render(with message: String) {
		errorMessageLabel.text = message
	}

}
