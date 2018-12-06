//
//  GradientView.swift
//  RemoteHome
//
//  Created by John Forde on 29/09/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

@IBDesignable
class GradientView: UIView {

	public override init(frame: CGRect) {
		super.init(frame: frame)
		setUp()
	}

	public required init?(coder decoder: NSCoder) {
		super.init(coder: decoder)
		setUp()
	}

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		setUp()
	}

	private func setUp() {
		let darkColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
		let lightColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		let gradientLayer = CAGradientLayer()
		gradientLayer.frame = bounds
		gradientLayer.colors = [darkColor.cgColor, lightColor.cgColor]
		gradientLayer.locations = [0.0, 1.0]
		layer.insertSublayer(gradientLayer, at: 0)
	}
}

