//
//  RoomTemperatureView.swift
//  RemoteHome
//
//  Created by John Forde on 13/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia


class RoomTemperatureView: UIView {

	let roomTemperatureLabel = UILabel()
	var setTemperatureView = SetTemperatureView()
	let temperatureLabel = UILabel()
	var device: IoTDevice? {
		didSet(value) {
			setTemperatureView.device = device
		}
	}
	
	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			roomTemperatureLabel.style(labelStyle),
			temperatureLabel.style(labelStyle),
			setTemperatureView
		)
		backgroundColor = UIColor.controlColor
		layer.cornerRadius = 8

		roomTemperatureLabel.text = "Room Temperature"

		layout(4,
					 |-roomTemperatureLabel-(>=8)-temperatureLabel-|,
					 4,
					 |-setTemperatureView-|,
					 4)
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.textColor = UIColor.white
		lbl.font = .cellFont
	}

}
