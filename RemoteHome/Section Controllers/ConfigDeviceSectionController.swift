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
		iotDevice = (object as! IoTDevice)
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
		return CGSize(width: width, height: 220)
	}
}

extension ConfigDeviceSectionController: ControlsSectionControllerDelegate {
	func refreshListController() {
		collectionContext?.performBatch(animated: true, updates: { batchContext in
			batchContext.reload(self)
		})
	}
}

