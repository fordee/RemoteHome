//
//  FanCell+IoTDevice.swift
//  RemoteHome
//
//  Created by John Forde on 27/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

extension FanCell {

	func render(with device: IoTDevice) {
		print("Set Fan Mode: \(device.hvacCommand.fanMode)")
		if device.hvacCommand.fanMode == .fanSpeedAuto {
			setControlImages(on: true)
			fanView.setAllFanButtonsOff()
		} else {
			setControlImages(on: false)
			fanView.setImageFor(buttonIndex: device.hvacCommand.fanMode.rawValue)
		}
	}
}
