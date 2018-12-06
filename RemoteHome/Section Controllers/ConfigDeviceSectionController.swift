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

	enum CellClass: Int, CaseIterable {
		case header = 0
		case type
		case room
	}

	var iotDevice: IoTDevice?
	var expanded = false

	override init() {
		super.init()
		NotificationCenter.default.addObserver(self, selector: #selector(collapseCells), name: .collapseCells, object: nil)
	}

	override func numberOfItems() -> Int {
		if expanded {
			return CellClass.allCases.count
		} else {
			return 1
		}
	}

	override func didUpdate(to object: Any) {
		precondition(object is IoTDevice)
		iotDevice = (object as? IoTDevice)!
	}

	override func cellForItem(at index: Int) -> UICollectionViewCell {

		let cellClass: AnyClass

		guard let cc = CellClass(rawValue: index) else { fatalError("Couldn't get Cell Class from index: \(index)")	}

		switch cc {
		case .header:
			cellClass = HeaderCell.self
		case .type:
			cellClass = ControlCell.self // TODO: Change cell type
		case .room:
			cellClass = TemperatureCell.self // TODO: Change cell type
		}

		let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)

		guard let iotDevice = iotDevice else { return cell }

		if let cell = cell as? TemperatureCell {
			cell.device = iotDevice
			cell.roomTemperatureView.render(with: iotDevice)
			cell.roomTemperatureView.setTemperatureView.render(with: iotDevice)
		} else if let cell = cell as? HeaderCell {
			cell.headerView.render(with: iotDevice)
		} else if let cell = cell as? ControlCell {
			cell.device = iotDevice
			cell.delegate = self
			cell.render(with: iotDevice)
		}
		return cell
	}

	override func sizeForItem(at index: Int) -> CGSize {
		guard let context = collectionContext else { return .zero}
		let width = context.containerSize.width

		guard let cc = CellClass(rawValue: index) else { fatalError("Couldn't get Cell Class from index: \(index)")	}

		switch cc {
		case .header:
			return CGSize(width: width, height: 56)
		case .type:
			return CGSize(width: width, height: 100)
		case .room:
			return CGSize(width: width, height: 150)
		}
	}

	override func didSelectItem(at index: Int) {
		//print("index: \(index)")
		if index == 0 {
			expanded = !expanded
			collectionContext?.performBatch(animated: true, updates: { batchContext in
				batchContext.reload(self)
			})
			if let deviceid = iotDevice?.deviceName, expanded == true {
				// Send notification to collapse all other cells
				NotificationCenter.default.post(name: .collapseCells, object: nil, userInfo: ["deviceid" : deviceid])
			}
		}
	}

	@objc func collapseCells(_ notification: Notification) {
		// Notification to collapse this cell if it isn't the cell that sent it (deteremined by the deviceid).
		if let deviceid = notification.userInfo?["deviceid"] as? String, let thisDeviceid = iotDevice?.deviceName, deviceid != thisDeviceid {
			expanded = false
			collectionContext?.performBatch(animated: true, updates: { batchContext in
				batchContext.reload(self)
			})
		}
	}

}

extension ConfigDeviceSectionController: ControlsSectionControllerDelegate {
	func refreshListController() {
		collectionContext?.performBatch(animated: true, updates: { batchContext in
			batchContext.reload(self)
		})
	}
}

