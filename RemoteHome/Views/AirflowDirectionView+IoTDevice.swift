//
//  AirflowDirectionView+IoTDevice.swift
//  RemoteHome
//
//  Created by John Forde on 29/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

extension AirflowDirectionView {

	func render(with device: IoTDevice) {

		setAllButtonsOff()
		print("AirflowDirectionView Render: device?.hvacCommand.vanneMode = \(device.hvacCommand.vanneMode)")

		switch device.hvacCommand.vanneMode {
		case .vanneAuto:
			setImage(on: autoButton, imageName: "AutoButton")
		case .vanneAutoMove:
			setImage(on: swingButton, imageName: "AirflowDirectionSwing")
		case .vanneH1:
			setAirflowDirectionImageFor(buttonIndex: 1)
		case .vanneH2:
			setAirflowDirectionImageFor(buttonIndex: 2)
		case .vanneH3:
			setAirflowDirectionImageFor(buttonIndex: 3)
		case .vanneH4:
			setAirflowDirectionImageFor(buttonIndex: 4)
		case .vanneH5:
			setAirflowDirectionImageFor(buttonIndex: 5)
		}

	}
}

