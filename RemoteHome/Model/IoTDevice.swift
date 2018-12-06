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
	var deviceName = ""
	var temperature = ""
	var humidity = ""
	var dateTime = ""

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

	public convenience init(deviceName: String, temperature: String) {
		self.init(deviceName: deviceName)
		self.temperature = temperature
	}

	public init(deviceName: String) {
		self.deviceName = deviceName
		dateFormatter.dateFormat = "yyyy'-'MM'-'dd' 'HH':'mm':'ss'.'SSSSSS"
		dateFormatter.timeZone = TimeZone(abbreviation: "GMT")//.current
	}

	// MARK: Equatable Protocol
	static func == (lhs: IoTDevice, rhs: IoTDevice) -> Bool {
		return lhs.deviceName == rhs.deviceName
	}

}

extension IoTDevice: ListDiffable {
	public func diffIdentifier() -> NSObjectProtocol {
		return deviceName as NSObjectProtocol
	}

	public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard let object = object as? IoTDevice else { return false }
		return self.deviceName == object.deviceName
	}
}
