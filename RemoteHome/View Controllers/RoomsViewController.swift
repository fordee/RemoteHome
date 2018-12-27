//
//  RoomsViewController.swift
//  RemoteHome
//
//  Created by John Forde on 27/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

class RoomsViewController: UIViewController {

	let v = RoomsView()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Rooms"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
	}


	@objc func addButtonPressed(_ sender: Any) {
		print("Add Button Pressed.")
	}
}
