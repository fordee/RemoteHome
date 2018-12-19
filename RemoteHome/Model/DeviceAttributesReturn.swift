//
//  DeviceAttributesReturn.swift
//  RemoteHome
//
//  Created by John Forde on 20/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import Foundation

public struct DeviceAttributesReturn: Codable {
	let deviceid: String
	let device_name: String
	let device_type: String
	let is_active: String
}
