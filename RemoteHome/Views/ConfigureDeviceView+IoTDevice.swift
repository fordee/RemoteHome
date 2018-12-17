//
//  ConfigureDeviceView+IoTDevice.swift
//  RemoteHome
//
//  Created by John Forde on 16/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

extension ConfigureDeviceView {

	func render(with device: IoTDevice) {
		deviceIdLabel.text = "Device ID: \(device.deviceId)"
		deviceNameEditField.text = device.deviceName
		deviceTypeButton.setTitle(device.deviceType, for: .normal)
		isActiveSwitch.setOn(device.isActive, animated: true)
	}

}
