//
//  RoomView.swift
//  RemoteHome
//
//  Created by John Forde on 29/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class RoomView: UIView {

	var room: Room?

	var button = UIButton()

	convenience init() {
		self.init(frame: CGRect.zero)


		render()
	}

	func render() {

		sv([button])
		backgroundColor = UIColor.controlColor
		layer.cornerRadius = 8
		button.setTitle("Press Me!", for: .normal)
		button.setTitleColor(.white, for: .normal)
		button.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)

		button.centerInContainer()
//		layout(0,
//					 |label|,
//					 0)
	}

	@objc func buttonPressed(_ sender: Any) {
		parentViewController?.dismiss(animated: true)
	}

}
