//
//  Room.swift
//  RemoteHome
//
//  Created by John Forde on 9/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

public class Room {
	var roomName: String
	var deviceIds: [String] = []
	
	init(room name: String) {
		roomName = name
	}

	convenience init(room name: String, deviceIds: [String]) {
		self.init(room: name)
		self.deviceIds = deviceIds
	}

	convenience init(with roomData: RoomData) {
		self.init(room: roomData.room_name)
		guard let device_ids = roomData.device_ids else { return } // No devices
		for device_id in device_ids {
			deviceIds.append(device_id)
		}
	}

}
