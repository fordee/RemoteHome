//
//  RoomTemperatureView+RoomTemperature.swift
//  RemoteHome
//
//  Created by John Forde on 13/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

extension RoomTemperatureView {

	func render(with: IoTDevice) {
		if let temp = with.temperatureDouble {
			temperatureLabel.text = String(format: "%0.1f°C", temp)
		} else {
			temperatureLabel.text = with.temperature
		}
	}
}
