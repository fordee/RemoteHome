//
//  ControlsView.swift
//  RemoteHome
//
//  Created by John Forde on 13/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit
import Stevia
import IGListKit

class ControlsView: UIView {

	let listView = ListCollectionView(frame: CGRect.zero, listCollectionViewLayout: ListCollectionViewLayout(stickyHeaders: true, scrollDirection: .vertical, topContentInset: 0, stretchToEdge: true))

	convenience init() {
		self.init(frame: CGRect.zero)
		render()
	}

	func render() {
		// Here we use Stevia to make our constraints more readable and maintainable.
		sv([listView])
		backgroundColor = UIColor.backgroundColor
		listView.backgroundColor = UIColor.backgroundColor

		layout(8,
					 |-listView-|,
					 8)
	}

}
