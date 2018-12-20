//
//  SetTemperatureView.swift
//  RemoteHome
//
//  Created by John Forde on 13/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia
import PromiseKit

class SetTemperatureView: UIView {

	let setTemperatureLabel = UILabel()
	let setTemperatureSlider = UISlider()
	let setTemperatureDegrees = UILabel()

	weak var delegate: HeatingViewControllerDelegate?

	var device: IoTDevice?
	
	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv(
			setTemperatureLabel.style(labelStyle),
			setTemperatureSlider.style(sliderStyle),
			setTemperatureDegrees.style(labelStyle)
		)
		backgroundColor = UIColor.backgroundColor
		layer.cornerRadius = 8
		setTemperatureLabel.text = "Set Temperature"
		setTemperatureDegrees.text = "24°C"


		layout(4,
					 |-setTemperatureLabel-(>=8)-setTemperatureDegrees-|,
					 4,
					 |-setTemperatureSlider-|,
					 4)
	}

	private func labelStyle(lbl: UILabel) {
		lbl.height(44)
		lbl.backgroundColor = UIColor.backgroundColor
		lbl.textColor = UIColor.white
		lbl.font = .cellFont
	}

	private func sliderStyle(sld: UISlider) {
		sld.maximumValue = 32
		sld.minimumValue = 16
		sld.value = 24
		//sld.isContinuous = false
		sld.addTarget(self, action: #selector(sliderValueChanged(_:)), for: UIControl.Event.valueChanged)
		sld.addTarget(self, action: #selector(sliderFinishedEditing(_:)), for: [UIControl.Event.touchUpInside, UIControl.Event.touchUpOutside])
	}

	@objc func sliderValueChanged(_ slider: UISlider) {
		print("slider.value \(slider.value)")
		let setTemp = Double(Int(slider.value))
		setTemperatureDegrees.text = String(setTemp) + "°C"
		device?.hvacCommand.temperature = setTemp
	}

	@objc func sliderFinishedEditing(_ slider: UISlider) {
		print("slider editing did end.")
		guard let device = device else {return}
		firstly {
			DeviceDataApi.shared.sendCommand(to: device)
		}.done { result in
			print("Success: \(result)")
		}.catch { error in
			self.delegate?.handleError(error)
		}
	}

}
