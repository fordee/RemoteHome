//
//  PopUpLoginView.swift
//  RemoteHome
//
//  Created by John Forde on 10/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class PopUpLoginView: UIView {

	let loginView = LoginView()

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv([loginView.style(viewStyle)])
		backgroundColor = UIColor.clear
		loginView.layer.cornerRadius = 8

		loginView.backgroundColor = UIColor.accentColor

		layout(20,
					 |-loginView-|,
					 (>=20)
					)
	}

	private func viewStyle(v: UIView) {
		v.height(260)
	}

}
