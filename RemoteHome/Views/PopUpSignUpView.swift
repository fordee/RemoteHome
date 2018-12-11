//
//  PopUpSignUpView.swift
//  RemoteHome
//
//  Created by John Forde on 11/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class PopUpSignUpView: UIView {

	let signUpView = SignUpView()

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv([signUpView.style(viewStyle)])
		backgroundColor = UIColor.clear
		signUpView.layer.cornerRadius = 8

		signUpView.backgroundColor = UIColor.accentColor

		layout(20,
					 |-signUpView-|,
					 (>=20)
		)
	}

	private func viewStyle(v: UIView) {
		v.height(360)
	}

}
