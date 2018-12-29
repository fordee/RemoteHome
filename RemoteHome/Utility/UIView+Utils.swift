//
//  UIView+Utils.swift
//  RemoteHome
//
//  Created by John Forde on 29/12/18.
//  Copyright © 2018 4DWare. All rights reserved.
//
import UIKit

extension UIView {
	var parentViewController: UIViewController? {
		var parentResponder: UIResponder? = self
		while parentResponder != nil {
			parentResponder = parentResponder!.next
			if let viewController = parentResponder as? UIViewController {
				return viewController
			}
		}
		return nil
	}
}

