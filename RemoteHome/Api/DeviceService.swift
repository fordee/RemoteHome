//
//  DeviceService.swift
//  RemoteHome
//
//  Created by John Forde on 27/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//


import PromiseKit
public class DeviceService: RestClient {

	override init(token: String?) {
		super.init(token: token)
	}

	public func temperature() -> Promise<DeviceDataResponse> {
		return request(.temperature)
	}

	public func aircon(parameters: Parameters) -> Promise<HvacCommandResponse> {
		return request(.aircon, parameters: parameters)
	}

	public func device(parameters: Parameters) -> Promise<DeviceAttributesReturn> {
		return request(.device, parameters: parameters)
	}

	public func room() -> Promise<RoomDataResponse> {
		return request(.room)
	}

	public func addRoom(parameters: Parameters) -> Promise<RoomData> {
		return request(.addRoom, parameters: parameters)
	}

}
