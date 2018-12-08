//
//  PopUpErrorView.swift
//  RemoteHome
//
//  Created by John Forde on 9/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class PopUpErrorView: UIView {

	let errorView = ErrorView()

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv([errorView.style(viewStyle)])
		backgroundColor = UIColor.clear

		errorView.backgroundColor = UIColor.white

		layout((>=20),
					 |-errorView-|,
					 0)
	}

	private func viewStyle(v: UIView) {
		v.height(150)
	}
}
