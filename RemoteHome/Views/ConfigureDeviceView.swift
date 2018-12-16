//
//  ConfigureDeviceView.swift
//  RemoteHome
//
//  Created by John Forde on 16/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

class ConfigureDeviceView: UIView {

	var device: IoTDevice?

	let deviceIdLabel = UILabel()
	let deviceNameLabel = UILabel()
	let deviceNameEditField = UITextField()
	let saveButton = UIButton()

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			deviceIdLabel.style(labelStyle),
			deviceNameLabel.style(labelStyle),
			deviceNameEditField.style(textFieldStyle),
			saveButton.style(buttonStyle)
		)

		// Here we layout the cell.
		layout(
			8,
			|-deviceIdLabel-(>=4)-|,
			8,
			|-deviceNameLabel-8-deviceNameEditField-|,
			8,
			|-saveButton-|,
			8
		)

		// Configure visual elements
		backgroundColor = UIColor.controlColor
		deviceNameLabel.text = "Device Name"
		layer.cornerRadius = 8
	}

	private func textFieldStyle(txt: UITextField) {
		txt.borderStyle = .roundedRect
		txt.textColor = UIColor.black
		txt.backgroundColor = UIColor.white
		txt.keyboardType = .asciiCapable
		txt.keyboardAppearance = .dark
		txt.returnKeyType = .next
		txt.height(44)
		txt.width(>=200)
		txt.font = .detailFont
		//txt.delegate = self
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.textColor = .white
		lbl.font = .cellFont
	}

	private func buttonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.accentColor
		btn.tintColor = UIColor.white
		btn.height(44)
		//btn.width(>=44)
		btn.layer.cornerRadius = 8
		btn.setTitle("Save", for: .normal)
		btn.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
	}

	@objc func saveButtonPressed(_ sender: Any) {
		print("Save Button Pressed. \(device?.deviceId ?? ""): \(deviceNameEditField.text ?? "")")
		guard let device = device else { return }

		DeviceDataApi.shared.setDeviceName(of: device.deviceId, with: deviceNameEditField.text!)
	}
}
