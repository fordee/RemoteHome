//
//  ControlCell+Device.swift
//  RemoteHome
//
//  Created by John Forde on 27/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

extension ControlCell {

	func render(with device: IoTDevice) {
		print("On: \(device.hvacCommand.on), Mode: \(device.hvacCommand.mode)")

		if device.hvacCommand.on {
			setImage(on: onControl, imageName: "OnButton")
		} else {
			setImage(on: onControl, imageName: "OnButtonUnhighlighted")
		}
		unhighlightAllModeButtons()
		switch device.hvacCommand.mode {
		case .hvacHot:
			setImage(on: heatControl, imageName: "HeatButton")
		case .hvacCold:
			setImage(on: coolControl, imageName: "CoolButton")
		case .hvacDry:
			setImage(on: dryControl, imageName: "DryButton")
		case .hvacFan:
			setImage(on: fanControl, imageName: "FanButton")
		case .hvacAuto:
			setImage(on: autoControl, imageName: "AutoButton")
		}
	}
}

