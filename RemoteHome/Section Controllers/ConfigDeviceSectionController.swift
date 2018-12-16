//
//  ConfigDeviceSectionController.swift
//  RemoteHome
//
//  Created by John Forde on 9/11/18.
//  Copyright © 2018 4DWare. All rights reserved.
//
import UIKit
import IGListKit

class ConfigDeviceSectionController: ListSectionController {

	var iotDevice: IoTDevice?

	override init() {
		super.init()
	}

	override func numberOfItems() -> Int {
		return 1
	}

	override func didUpdate(to object: Any) {
		precondition(object is IoTDevice)
		iotDevice = (object as? IoTDevice)!
	}

	override func cellForItem(at index: Int) -> UICollectionViewCell {

		let cell = collectionContext!.dequeueReusableCell(of: ConfigureDeviceCell.self, for: self, at: index) as! ConfigureDeviceCell
		cell.configureDeviceView.device = iotDevice
		cell.configureDeviceView.render(with: iotDevice!)
		return cell
	}

	override func sizeForItem(at index: Int) -> CGSize {
		guard let context = collectionContext else { return .zero}
		let width = context.containerSize.width
		return CGSize(width: width, height: 150)
	}

//	override func didSelectItem(at index: Int) {
//		//print("index: \(index)")
//		if index == 0 {
//			expanded = !expanded
//			collectionContext?.performBatch(animated: true, updates: { batchContext in
//				batchContext.reload(self)
//			})
//			if let deviceid = iotDevice?.deviceName, expanded == true {
//				// Send notification to collapse all other cells
//				NotificationCenter.default.post(name: .collapseCells, object: nil, userInfo: ["deviceid" : deviceid])
//			}
//		}
//	}

//	@objc func collapseCells(_ notification: Notification) {
//		// Notification to collapse this cell if it isn't the cell that sent it (deteremined by the deviceid).
//		if let deviceid = notification.userInfo?["deviceid"] as? String, let thisDeviceid = iotDevice?.deviceName, deviceid != thisDeviceid {
//			expanded = false
//			collectionContext?.performBatch(animated: true, updates: { batchContext in
//				batchContext.reload(self)
//			})
//		}
//	}

}

extension ConfigDeviceSectionController: ControlsSectionControllerDelegate {
	func refreshListController() {
		collectionContext?.performBatch(animated: true, updates: { batchContext in
			batchContext.reload(self)
		})
	}
}

