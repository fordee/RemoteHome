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

	let transition = PopAnimator()
	var selectedView: UIView?

	override func loadView() {
		view = v
	}

	override func viewDidLoad() {
		super.viewDidLoad()

		transition.dismissCompletion = {
			self.selectedView!.isHidden = false
		}

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

extension RoomsViewController: UIViewControllerTransitioningDelegate {
	func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.originFrame = selectedView!.superview!.convert(selectedView!.frame, to: nil)

		transition.presenting = true
		selectedView!.isHidden = true

		return transition
	}

	func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
		transition.presenting = false
		return transition
	}
}



protocol RoomsViewControllerDelegate: AnyObject	{
	func handleCellPressed(indexPath: IndexPath, selectedView: UIView)
}

extension RoomsViewController: RoomsViewControllerDelegate {
	func handleCellPressed(indexPath: IndexPath, selectedView: UIView) {
		print("Delegate handleCellPressed called.")
		self.selectedView = selectedView

		let vc = RoomViewController()
		//vc.modalPresentationStyle = .formSheet
		if let cell = v.listView.cellForItem(at: indexPath) as? RoomCell {
			vc.v.roomNamelabel.text = cell.roomNamelabel.text
			vc.v.temperatureLabel.text = cell.temperatureLabel.text
		}
		vc.transitioningDelegate = self
		present(vc, animated: true)
	}
}
