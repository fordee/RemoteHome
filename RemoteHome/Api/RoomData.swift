//
//  RoomData.swift
//  RemoteHome
//
//  Created by John Forde on 27/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

public class RoomData: Decodable {
	var room_name: String
	var device_ids: [String]? = []

	init(roomName: String) {
		room_name = roomName
	}
}

public class RoomDataResponse: Decodable {
	var rooms: [RoomData] = []
}
