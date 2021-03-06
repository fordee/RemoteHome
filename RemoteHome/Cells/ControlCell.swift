//
//  ControlCell.swift
//  RemoteHome
//
//  Created by John Forde on 12/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia
import AudioToolbox
import PromiseKit

class ControlCell: UICollectionViewCell {

	weak var delegate: ControlsSectionControllerDelegate?
	weak var heatingDelegate: HeatingViewControllerDelegate?

	var device: IoTDevice?

	var onControl = UIButton()
	var autoControl = UIButton()
	var heatControl = UIButton()
	var dryControl = UIButton()
	var fanControl = UIButton()
	var coolControl = UIButton()

	required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder)}

	override init(frame: CGRect) {
		super.init(frame: frame)
		setControlImages()
		setControlTargets()

		sv(
			onControl.style(controlButtonStyle),
			autoControl.style(controlButtonStyle),
			heatControl.style(controlButtonStyle),
			dryControl.style(controlButtonStyle),
			fanControl.style(controlButtonStyle),
			coolControl.style(controlButtonStyle)
		)

		equal(sizes: [onControl, autoControl, heatControl, dryControl, fanControl, coolControl])
		// Here we layout the cell.
		layout(
			4,
			|-4-onControl-2-autoControl-2-heatControl-4-|,
			2,
			|-4-dryControl-2-fanControl-2-coolControl-4-|,
			>=4
		)

		// Configure visual elements
		backgroundColor = UIColor.backgroundColor
	}

	private func setControlImages() {
		setImage(on: onControl, imageName: "OnButton")
		setImage(on: autoControl, imageName: "AutoButton")
		setImage(on: heatControl, imageName: "HeatButton")
		setImage(on: dryControl, imageName: "DryButton")
		setImage(on: fanControl, imageName: "FanButton")
		setImage(on: coolControl, imageName: "CoolButton")
	}

	private func setControlTargets() {
		onControl.addTarget(self, action: #selector(airconOnButton(_:)), for: .touchUpInside)
		autoControl.addTarget(self, action: #selector(setAutoButton(_:)), for: .touchUpInside)
		heatControl.addTarget(self, action: #selector(setHeatButton(_:)), for: .touchUpInside)
		dryControl.addTarget(self, action: #selector(setDryButton(_:)), for: .touchUpInside)
		fanControl.addTarget(self, action: #selector(setFanButton(_:)), for: .touchUpInside)
		coolControl.addTarget(self, action: #selector(setCoolButton(_:)), for: .touchUpInside)
	}

	func setImage(on button: UIButton, imageName: String) {
		let image = UIImage(named: imageName)
		button.setImage(image, for: .normal)
	}

	private func controlButtonStyle(btn: UIButton) {
		btn.backgroundColor = UIColor.controlColor
		btn.height(>=50)
		btn.width(>=50)
		btn.layer.cornerRadius = 8
	}

	@objc func airconOnButton(_ sender: Any) {
		guard let device = device else {return}
		device.hvacCommand.on = !device.hvacCommand.on
		setImage(on: onControl, imageName: device.hvacCommand.on ? "OnButton" : "OnButtonUnhighlighted")
		print("device.on: \(device.hvacCommand.on)")
		delegate?.refreshListController()
		sendCommand(to: device)
		// Provide some haptic feedback
		AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
		//AudioServicesPlaySystemSound(1520)
	}

	@objc func setAutoButton(_ sender: Any) {
		guard let device = device else {return}
		unhighlightAllModeButtons()
		setImage(on: autoControl, imageName: "AutoButton")
		device.hvacCommand.mode = .hvacAuto
		sendCommand(to: device)
	}

	@objc func setHeatButton(_ sender: Any) {
		guard let device = device else {return}
		unhighlightAllModeButtons()
		setImage(on: heatControl, imageName: "HeatButton")
		device.hvacCommand.mode = .hvacHot
		sendCommand(to: device)
	}

	@objc func setDryButton(_ sender: Any) {
		guard let device = device else {return}
		unhighlightAllModeButtons()
		setImage(on: dryControl, imageName: "DryButton")
		device.hvacCommand.mode = .hvacDry
		sendCommand(to: device)
	}
	@objc func setFanButton(_ sender: Any) {
		guard let device = device else {return}
		unhighlightAllModeButtons()
		setImage(on: fanControl, imageName: "FanButton")
		device.hvacCommand.mode = .hvacFan
		sendCommand(to: device)
	}

	@objc func setCoolButton(_ sender: Any) {
		guard let device = device else {return}
		unhighlightAllModeButtons()
		setImage(on: coolControl, imageName: "CoolButton")
		device.hvacCommand.mode = .hvacCold
		sendCommand(to: device)
	}

	private func sendCommand(to device: IoTDevice) {
		firstly {
			DeviceDataApi.shared.sendCommand(to: device)
		}.done { result in
			print("Success: \(result)")
		}.catch { error in
			self.heatingDelegate?.handleError(error)
		}
	}

	func unhighlightAllModeButtons() {
		setImage(on: autoControl, imageName: "AutoButtonUnhighlighted")
		setImage(on: heatControl, imageName: "HeatButtonUnhighlighted")
		setImage(on: dryControl, imageName: "DryButtonUnhighlighted")
		setImage(on: fanControl, imageName: "FanButtonUnhighlighted")
		setImage(on: coolControl, imageName: "CoolButtonUnhighlighted")
	}





}

