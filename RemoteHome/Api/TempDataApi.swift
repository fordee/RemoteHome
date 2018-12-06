//
//  TempDataApi.swift
//  RemoteHome
//
//  Created by John Forde on 29/09/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation
import PromiseKit

enum HvacMode: Int, Decodable {
	case hvacHot = 0
	case hvacCold
	case hvacDry
	case hvacFan	 
	case hvacAuto
} // HVAC  MODE

enum HvacFanMode: Int, Decodable {
	case fanSpeed1 = 0
	case fanSpeed2
	case fanSpeed3
	case fanSpeed4
	case fanSpeed5
	case fanSpeedAuto
	case fanSpeedSilent
}  // HVAC  FAN MODE

enum HvacVanneMode: Int, Decodable {
	case vanneAuto = 0
	case vanneH1
	case vanneH2
	case vanneH3
	case vanneH4
	case vanneH5
	case vanneAutoMove
} // HVAC  VANNE MODE

enum HvacWideVanneMode: Int, Decodable {
	case wideLeftEnd = 0
	case wideLeft
	case wideMidlle
	case wideRight
	case wideRightEnd
}  // HVAC  WIDE VANNE MODE

public struct TempItem: Decodable {
	let date_time: String
	let humidity: String
	let deviceid: String
	let temperature: String
	let set_temperature: Double
	let mode: HvacMode//Int
	let on: Bool
	let fan_mode: HvacFanMode
	let vanne_mode: HvacVanneMode

	var temperatureDouble: Double {
		return Double(temperature)! // This should always work
	}

	var humidityDouble: Double {
		return Double(humidity)! // This should always work
	}
}

public struct Device: Decodable {
	let deviceid: String
	let data: TempItem//[TempItem]
}

public struct TempDataResponse: Decodable {
	//let ServiceID: String
	var devices: [Device]
		init() {
		devices = []
	}
}

public struct HvacCommand {
	var on = false
	//var device: IoTDevice?
	var mode: HvacMode = .hvacAuto
	var fanMode: HvacFanMode = .fanSpeedAuto
	var vanneMode: HvacVanneMode = .vanneAuto
	var temperature: Double = 24

	init(on: Bool, mode: HvacMode = .hvacAuto, fanMode: HvacFanMode = .fanSpeedAuto, vanneMode: HvacVanneMode = .vanneAuto, temperature: Double = 24) {
		self.on = on
		self.mode = mode
		self.fanMode = fanMode
		self.vanneMode = vanneMode
		self.temperature = temperature
	}

	init() {
		
	}
}

public struct HvacCommandResponse: Codable {
	var result: String
}

final public class TempDataApi: NSObject {

	// This is a Singleton
	static let shared = TempDataApi()

	public var tokenString: String? {
		didSet {
			service = DeviceService(token: tokenString)
		}
	}

	public var devices: [IoTDevice] = []
	public var tempDataResponse: TempDataResponse?

	private var service: DeviceService?

	public func command(to device: IoTDevice) {
		let parameters: [String: String] = [
			"command" : String(device.hvacCommand.on),
			"mode" : String(device.hvacCommand.mode.rawValue),
			"fanMode" : String(device.hvacCommand.fanMode.rawValue),
			"vanneMode" : String(device.hvacCommand.vanneMode.rawValue),
			"temperature" : String(Int(device.hvacCommand.temperature)),
			"device" : device.deviceName
		]

		guard let service = service else { fatalError("DeviceService is unavailable") }
		
		firstly {
			service.aircon(parameters: parameters)
			}.done { returnString in
				print(returnString)
			}.catch { error in
				print("Error: \(error.localizedDescription)")
		}
	}


	public func refreshTempData(completion: (() -> Void)? = nil) {

		guard let service = service else { fatalError("DeviceService is unavailable") }

		firstly {
			service.temperature()
			}.done { json in
				self.tempDataResponse = json
				//print(tempDataResponse ?? "")
			}.catch { error in
				print("Error: \(error.localizedDescription)")
		}

		guard let tempDataResponse = tempDataResponse else { return }

		for device in tempDataResponse.devices {
			// check if IoT device already in array
			let index = self.devices.firstIndex { $0.deviceName == device.deviceid }

			if index != nil {
				self.setDeviceAttributes(for: self.devices[index!], by: device.data)
			} else {
				let iotDevice = IoTDevice(deviceName: device.deviceid)
				print("Device: \(device.deviceid)")
				self.setDeviceAttributes(for: iotDevice, by: device.data)
				self.devices.append(iotDevice)
			}
		}
		if let completion = completion {
			completion()
		}
	}

	private func setDeviceAttributes(for device: IoTDevice, by: TempItem) {
		device.temperature = by.temperature
		device.humidity = by.humidity
		device.dateTime = by.date_time
		device.hvacCommand.mode = by.mode
		device.hvacCommand.on = by.on
		device.hvacCommand.temperature = by.set_temperature
		device.hvacCommand.fanMode = by.fan_mode
		device.hvacCommand.vanneMode = by.vanne_mode
	}


}



