//
//  RoomsViewController.swift
//  RemoteHome
//
//  Created by John Forde on 27/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import PromiseKit
import MagazineLayout

class RoomsViewController: UIViewController {

	let v = RoomsView()

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		navigationItem.title = "Rooms"
		navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed(_:)))
		v.delegate = self
	}


	@objc func addButtonPressed(_ sender: Any) {
		print("Add Button Pressed.")
		//v.listView.dataSource.insert(Room("Fred"), atIndex: 0	, inSectionAtIndex: 0)

		let room = Room(room: "Fred")

		firstly {
			DeviceDataApi.shared.addRoom(room)
		}.done { roomReturnData in
			print(roomReturnData)
		}.catch { error in
			let reason = error.getReason()
			print(reason)
			self.showErrorDialog(reason)
		}

		if let dataSource = v.listView.dataSource as? RoomDataSource {
			dataSource.insert(room, atIndex: 0	, inSectionAtIndex: 0)
			v.listView.reloadData()
		}
	}
}

protocol RoomsViewControllerDelegate: AnyObject	{
	func handleCellPressed(indexPath: IndexPath)
}

extension RoomsViewController: RoomsViewControllerDelegate {
	func handleCellPressed(indexPath: IndexPath) {
		print("Delegate handleCellPressed called.")
		present(RoomViewController(), animated: true)
	}


}
