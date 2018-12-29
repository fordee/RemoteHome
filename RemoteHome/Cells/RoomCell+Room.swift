//
//  RoomCell+Room.swift
//  RemoteHome
//
//  Created by John Forde on 28/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

extension RoomCell {

	func render(with room: Room) {
		roomNamelabel.text = room.roomName

		for deviceId in room.deviceIds {
			if let index = DeviceDataApi.shared.devices.firstIndex(where: {deviceId == $0.deviceId}),
				let temperature = DeviceDataApi.shared.devices[index].temperatureDouble {
				temperatureLabel.text = String(format: "%.01f", temperature) + "°"
				return
			}
		}
	}

}
