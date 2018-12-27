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
	}

}
