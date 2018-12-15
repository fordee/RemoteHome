//
//  PopupForgotPasswordView.swift
//  RemoteHome
//
//  Created by John Forde on 15/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class PopUpForgotPasswordView: UIView {

	let forgotPasswordView = ForgotPasswordView()

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv([forgotPasswordView.style(viewStyle)])
		backgroundColor = UIColor.clear
		forgotPasswordView.layer.cornerRadius = 8

		forgotPasswordView.backgroundColor = UIColor.accentColor

		layout(20,
					 |-forgotPasswordView-|,
					 (>=20)
		)
	}

	private func viewStyle(v: UIView) {
		v.height(320)
	}

}
