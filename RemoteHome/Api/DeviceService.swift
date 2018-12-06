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

	public func temperature() -> Promise<TempDataResponse> {
		return request(.temperature)
	}

	public func aircon(parameters: JSON) -> Promise<HvacCommandResponse> {
		return request(.aircon, parameters: parameters)
	}
}
