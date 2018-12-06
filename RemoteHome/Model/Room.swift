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

	init(room name: String) {
		roomName = name
	}
}

extension Room: ListDiffable {
	public func diffIdentifier() -> NSObjectProtocol {
		return roomName as NSObjectProtocol
	}

	public func isEqual(toDiffableObject object: ListDiffable?) -> Bool {
		guard let object = object as? Room else { return false }
		return self.roomName == object.roomName
	}
}
