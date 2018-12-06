//
//  SetTemperatureView+Device.swift
//  RemoteHome
//
//  Created by John Forde on 27/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

extension SetTemperatureView {

	func render(with device: IoTDevice) {
		print("Set Temperature: \(device.hvacCommand.temperature)")
		setTemperatureSlider.value = Float(device.hvacCommand.temperature)
		setTemperatureDegrees.text = "\(device.hvacCommand.temperature)°C"
	}
}
