//
//  RoomViewController.swift
//  RemoteHome
//
//  Created by John Forde on 29/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

class RoomViewController: UIViewController {

	let v = RoomView()

	var room: Room!

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Room"

	}



}
