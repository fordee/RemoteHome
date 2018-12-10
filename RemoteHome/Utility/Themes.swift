//
//  Themes.swift
//  RemoteHome
//
//  Created by John Forde on 13/10/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

import UIKit

extension UIColor {
	static var backgroundColor: UIColor { return UIColor(named: "Background")!	}
	static var controlColor: UIColor {	return UIColor(named: "Control")!	}
	static var accentColor: UIColor { return UIColor(named: "Accent")! }
	//static var darkColor: UIColor {	return UIColor(named: "DarkColor")!	}
	static var textColor: UIColor { return UIColor.white }
}

extension UIFont {
	static var titleFont: UIFont { return UIFont(name: "Roboto-Bold", size: 22)! }
	static var headerFont: UIFont { return UIFont(name: "Roboto-Bold", size: 18)! }
	static var backButtonFont: UIFont { return UIFont(name: "Roboto-Regular", size: 16)! }
	static var cellFont: UIFont { return UIFont(name: "Roboto-Bold", size: 18)! }
	static var mainFont: UIFont { return UIFont(name: "Roboto-Regular", size: 20)! }
	static var menuFont: UIFont { return UIFont(name: "Roboto-Regular", size: 14)! }
	static var detailFont: UIFont { return UIFont(name: "Roboto-Regular", size: 18)! }
	static var buttonFont: UIFont { return UIFont(name: "Roboto-Bold", size: 12)! }

	//	static var mainFont: UIFont { return UIFont(name: "AppleGothic", size: 18)! }
}

extension Date {
	func convertToTimeZone(initTimeZone: TimeZone, timeZone: TimeZone) -> Date {
		let delta = TimeInterval(timeZone.secondsFromGMT() - initTimeZone.secondsFromGMT())
		return addingTimeInterval(delta)
	}
}
