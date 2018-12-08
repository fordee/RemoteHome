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

public struct DeviceData: Decodable {
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
	let data: DeviceData
}

public struct DeviceDataResponse: Decodable {
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

final public class DeviceDataApi {
	// This is a Singleton
	static let shared = DeviceDataApi()

	// MARK: Public variables
	public var tokenString: String? {
		didSet {
			//tokenString = "eyJraWQiOiJZaTZrdjB5U2crNHlTOE1CUUdHSDZiWktOSzVvMENWQXgwV1AreFhuWENBPSIsImFsZyI6IlJTMjU2In0.eyJzdWIiOiIwODUzODM2NC02ZTlhLTQyMmYtYmQ1MS1kNTE0M2UwMWMzNDEiLCJlbWFpbF92ZXJpZmllZCI6dHJ1ZSwiaXNzIjoiaHR0cHM6XC9cL2NvZ25pdG8taWRwLnVzLWVhc3QtMS5hbWF6b25hd3MuY29tXC91cy1lYXN0LTFfZllBTnNHWUlSIiwiY29nbml0bzp1c2VybmFtZSI6IjA4NTM4MzY0LTZlOWEtNDIyZi1iZDUxLWQ1MTQzZTAxYzM0MSIsImdpdmVuX25hbWUiOiJKb2huIiwiYXVkIjoiMzJwYXBnZDQ1aGVucWpiOTRtbWVvMWlrNmMiLCJldmVudF9pZCI6IjQyMmYyODdkLWYzZWYtMTFlOC1hYTFjLTJiMWY2YjMzMmM3MyIsInRva2VuX3VzZSI6ImlkIiwiYXV0aF90aW1lIjoxNTQzNTA2OTU2LCJleHAiOjE1NDQxMTQzNzgsImlhdCI6MTU0NDExMDc3OCwiZmFtaWx5X25hbWUiOiJGb3JkZSIsImVtYWlsIjoiZm9yZGVlQG1lLmNvbSJ9.iDu_5ut5qU_QSXR_78kiZAAyOTZlbeid6wug1CCzh6Sxbg_vfra_Md0bVahp3D6wYphGtfCjonwWg_UXftaYQHpVU29ytfUSGa8aAcNgcvzEQSvsv1c5ihdNgeZfz2OoDQGvle4hDZE8RMdylEUYMlMuUq9yTkxRYRg-QF7tXvYla9b8C0BhvzsfB0jfYaJcqxYJ8Pwm3nXrxk0ucPahxMubgh_N6X4R4o_vqHtrIIW8MESzvA6j_egWSi5G83hpD9hYbcMOw9HUPZaDjdptMYqJh4o1aSUFxjHpjtuls5NvSYzOlIboDuRpPd5FDNg6j08ms3Rrp7qME1BXvWqYoA"
			service = DeviceService(token: tokenString)
		}
	}
	public var devices: [IoTDevice] = []

	// MARK: Private variables
	private var service: DeviceService?

	// MARK: Public functions
	// Send Command to aircon service
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

	// Get the device data
	public func refreshDeviceData() -> Promise<[IoTDevice]> {
		return Promise {seal in
			guard let service = service else { fatalError("DeviceService is unavailable") }

			firstly {
				service.temperature()
				}.done { deviceDataResponse in
					self.devices = self.getDeviceList(deviceDataResponse: deviceDataResponse)
					seal.fulfill(self.devices)
				}.catch { error in
					print("Error: \(error.localizedDescription)")
					seal.reject(error)
			}
		}
	}

	// MARK: Private functions
	private func getDeviceList(deviceDataResponse: DeviceDataResponse) -> [IoTDevice] {
		var iotDevces: [IoTDevice] = []
		for device in deviceDataResponse.devices {
			let iotDevice = IoTDevice(deviceName: device.deviceid)
			setDeviceAttributes(for: iotDevice, with: device.data)
			iotDevces.append(iotDevice)
		}
		return iotDevces
	}

	private func setDeviceAttributes(for device: IoTDevice, with: DeviceData) {
		device.temperature = with.temperature
		device.humidity = with.humidity
		device.dateTime = with.date_time
		device.hvacCommand.mode = with.mode
		device.hvacCommand.on = with.on
		device.hvacCommand.temperature = with.set_temperature
		device.hvacCommand.fanMode = with.fan_mode
		device.hvacCommand.vanneMode = with.vanne_mode
	}

}



