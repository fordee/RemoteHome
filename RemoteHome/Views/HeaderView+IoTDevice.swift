//
//  HeaderView+IoTDevice.swift
//  RemoteHome
//
//  Created by John Forde on 19/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

extension HeaderView {

	func render(with: IoTDevice) {

		deviceLabel.text = with.deviceName
		
//		switch with.deviceId {
//		case "esp32_9AD3B4":
//			deviceLabel.text = "Hallway"
//		case "esp32_9B3C48":
//			deviceLabel.text = "Computer Room"
//		default:
//			deviceLabel.text = with.deviceId
//		}

		if let temp = with.temperatureDouble {
			temperatureLabel.text = String(format: "%0.1f°C", temp)
		} else {
			temperatureLabel.text = with.temperature
		}

		print(with.dateDiffFromNow)

		// Set color to orange if older than 10 minutes
		if with.dateDiffFromNow >= 10 * 60 {
			temperatureLabel.textColor = .orange
		}

		// Set color to red if older than 1 hour
		if with.dateDiffFromNow > 60 * 60 {
			temperatureLabel.textColor = .red
		}

		// Set color vack to white if not older than 10 minutes
		if with.dateDiffFromNow < 10 * 60 {
			temperatureLabel.textColor = .white
		}


	}

}
