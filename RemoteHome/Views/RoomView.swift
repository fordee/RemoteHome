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

//	var room: Room? {
//		didSet {
//			roomNamelabel.text = room?.roomName
//			for deviceId in room!.deviceIds {
//				if let index = DeviceDataApi.shared.devices.firstIndex(where: {deviceId == $0.deviceId}),
//					let temperature = DeviceDataApi.shared.devices[index].temperatureDouble {
//					temperatureLabel.text = String(format: "%.01f", temperature) + "°"
//					return
//				}
//			}
//		}
//	}

	let roomNamelabel = UILabel()
	let temperatureLabel = UILabel()
	var closeButton = UIButton()

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}



	func render() {

		sv([
			closeButton,
			roomNamelabel.style(roomLabelStyle),
			temperatureLabel.style(temperatureLabelStyle),
			])
		backgroundColor = UIColor.controlColor
		layer.cornerRadius = 8
		closeButton.setTitle("Press Me!", for: .normal)
		closeButton.setTitleColor(.white, for: .normal)
		closeButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)


		temperatureLabel.centerInContainer()
		layout(32,
					 |-16-roomNamelabel-(>=8)-|,
					(>=8),
					 |-closeButton-|,
					 16)
	}

	private func labelStyle(lbl: UILabel) {
		//lbl.height(44)
		lbl.textColor = .white
		lbl.font = .cellFont
		lbl.numberOfLines = 0
	}

	private func roomLabelStyle(lbl: UILabel) {
		labelStyle(lbl: lbl)
		lbl.font = .titleFont
		lbl.text = "N/A"
	}


	private func temperatureLabelStyle(lbl: UILabel) {
		labelStyle(lbl: lbl)
		lbl.font = .cellTempFont
		lbl.text = "N/A"
	}

	@objc func buttonPressed(_ sender: Any) {
		parentViewController?.dismiss(animated: true)
	}

}
