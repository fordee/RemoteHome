//
//  UIViewController+Utils.swift
//  RemoteHome
//
//  Created by John Forde on 12/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

extension UIViewController {
	public func showErrorDialog(_ message: String) {
		print("presentedViewController: \(presentedViewController == nil)")
		if presentedViewController == nil { // If another vc is alreadey being presented (e.g. login vc), don't present
			let vc = ErrorViewController()
			vc.message = message
			self.present(vc, animated: true, completion:  nil)
		}
	}
}
