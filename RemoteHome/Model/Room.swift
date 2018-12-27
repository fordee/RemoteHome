//
//  Room.swift
//  RemoteHome
//
//  Created by John Forde on 9/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import IGListKit

class Room {
	var roomName: String
	var devices: [IoTDevice] = []
	
	init(room name: String) {
		roomName = name
	}

}
