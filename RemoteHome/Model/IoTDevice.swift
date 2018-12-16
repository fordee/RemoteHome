//
//  Device.swift
//  RemoteHome
//
//  Created by John Forde on 18/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation
import IGListKit

public class IoTDevice {
	let dateFormatter = DateFormatter()
	var deviceId = ""
	var temperature = ""
	var humidity = ""
	var dateTime = ""
	var deviceName = ""


	var hvacCommand = HvacCommand()

	var temperatureDouble: Double? {
		return Double(temperature)
	}

	var humidityDouble: Double? {
		return Double(humidity)
	}

	var dateTimeDate: Date? {
		let date = dateFormatter.date(from: dateTime)
		return date
	}

	var dateDiffFromNow: TimeInterval {
		let now = Date(timeIntervalSinceNow: 0)
		return now.timeIntervalSince1970 - dateTimeDate!.timeIntervalSince1970
	}

	public convenience init(deviceId: String, temperature: String) {
		self.init(deviceId: deviceId)
		self.temperature = temperature
	}

	public init(deviceId: String) {
		self.deviceId = deviceId
		dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'SSSSSS"
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")//.current
	}

	// MARK: Equatable Protocol
	static func == (lhs: IoTDevice, rhs: IoTDevice) -> Bool {
		return lhs.deviceId == rhs.deviceId
	}

}

extension IoTDevice: ListDiffable {
	public func diffIdentifier() -> NSObjectProtocol {
		return deviceId as NSObjectProtocol
	}

	public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard let object = object as? IoTDevice else { return false }
		return self.deviceId == object.deviceId
	}
}
