//
//  ConfigureDeviceView.swift
//  RemoteHome
//
//  Created by John Forde on 16/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia

enum DeviceType: String, CaseIterable {
	case heatPump = "Heat Pump"
	case temperatureSensor = "Temperature Sensor"
}

class ConfigureDeviceView: UIView {

	var device: IoTDevice?

	let deviceIdLabel = UILabel()
	let deviceNameLabel = UILabel()
	let deviceNameEditField = UITextField()
	let isActiveSwitch = UISwitch()
	let isActiveLabel = UILabel()
	let deviceTypeButton = UIButton()

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
			isActiveSwitch.style(switchStyle),
			isActiveLabel.style(labelStyle),
			deviceTypeButton.style(buttonStyle),
			saveButton.style(buttonStyle)
		)

		// Here we layout the cell.
		layout(
			8,
			|-deviceIdLabel-(>=8)-|,
			8,
			|-deviceNameLabel-8-deviceNameEditField-|,
			16,
			|-isActiveSwitch-8-isActiveLabel-(>=8)-deviceTypeButton-|,
			16,
			|-saveButton-|,
			8
		)

		// Configure visual elements
		backgroundColor = UIColor.controlColor
		deviceNameLabel.text = "Device Name"
		isActiveLabel.text = "Active?"
		//deviceTypeButton.setTitle("Heat Pump", for: .normal)
		deviceTypeButton.addTarget(self, action: #selector(deviceTypeButtonPressed(_:)), for: .touchUpInside)
		deviceTypeButton.width(200)
		//deviceTypeButton.titleLabel?.width(160)
		saveButton.setTitle("Save", for: .normal)
		saveButton.addTarget(self, action: #selector(saveButtonPressed(_:)), for: .touchUpInside)
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
		lbl.numberOfLines = 0
	}

	private func buttonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.accentColor
		btn.tintColor = UIColor.white
		btn.height(44)
		btn.layer.cornerRadius = 8
	}

	private func switchStyle(sw: UISwitch) {
		sw.onTintColor = UIColor.accentColor
	}

	@objc func saveButtonPressed(_ sender: Any) {
		print("Save Button Pressed. \(device?.deviceId ?? ""): \(deviceNameEditField.text ?? "")")
		guard let device = device else { return }

		DeviceDataApi.shared.setDeviceAttributes(of: device.deviceId, deviceName: deviceNameEditField.text!, deviceType: (deviceTypeButton.titleLabel!.text!), isActive: isActiveSwitch.isOn)
	}

	@objc func deviceTypeButtonPressed(_ sender: Any) {
		print("Device Type Button Pressed.")
		//guard let device = device else { return }
		let values = DeviceType.allCases
		DPPickerManager.shared.showPicker(title: "Select a Device Type", selected: values[0].rawValue, strings: values.map {$0.rawValue}) { value, index, cancel in
			if !cancel {
				guard let value = value else { return }
				self.deviceTypeButton.setTitle(value, for: .normal)
			}
		}
	}
}
