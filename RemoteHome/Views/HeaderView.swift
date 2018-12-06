//
//  HeaderView.swift
//  RemoteHome
//
//  Created by John Forde on 19/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia


class HeaderView: UIView {

	let deviceLabel = UILabel()
	let temperatureLabel = UILabel()
	
	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			deviceLabel.style(labelStyle),
			temperatureLabel.style(labelStyle)
		)
		backgroundColor = UIColor.controlColor
		layer.cornerRadius = 8

		layout(4,
					 |-deviceLabel-(>=8)-temperatureLabel-|,
					 4)
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.backgroundColor = UIColor.controlColor
		lbl.textColor = UIColor.white
		lbl.font = .cellFont
	}

}
