//
//  ViewController.swift
//  RemoteHome
//
//  Created by John Forde on 29/09/18.
//  Copyright © 2018 4DWare. All rights reserved.
//

//import UIKit
//import Charts
//import AudioToolbox


//class DashboardViewController: UIViewController {
//
//	typealias DailyEntry = (day: String, count: Double)
//
//	@IBOutlet weak var temperatureLabel: UILabel!
//	@IBOutlet weak var humidityLabel: UILabel!
//	@IBOutlet weak var temperatureChart: LineChartView!
//	@IBOutlet weak var humidityChart: LineChartView!
//
//	@IBAction func airconOnButton(_ sender: Any) {
//		//tempDataApi.issue(hvacCommand: HvacCommand(off: true/*, device: nil*/))
//		// Provide some haptic feedback
//		//AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
//		//AudioServicesPlaySystemSound(1520)
//	}
//
//	@IBAction func airconOffButton(_ sender: Any) {
//		//tempDataApi.issue(hvacCommand: HvacCommand(off: false/*, device: nil*/))
//		// Provide some haptic feedback
//		//AudioServicesPlaySystemSound(1519) // Actuate `Peek` feedback (weak boom)
//		//AudioServicesPlaySystemSound(1520)
//	}
//
//
//	//let tempDataApi = TempDataApi.shared
//	var tempData: [TempItem] = []
//	var temps: [Double] = []
//	var humids: [Double] = []
//
//	@IBAction func refreshButtonPressed(_ sender: Any) {
//		refreshTempData()
//	}
//
//	override func viewDidLoad() {
//		super.viewDidLoad()
//		// Do any additional setup after loading the view, typically from a nib.
//		refreshTempData()
//
//	}
//
//	func refreshTempData() {
//		TempDataApi.shared.getTempData {
//			tempDataDetails in
//			for device in tempDataDetails.devices {
//				print("Device: \(device.deviceid)")
//				if device.deviceid == "esp32_9B3C48" { // TODO: make generic for a number of devices
//					self.tempData.append(device.data)
//					self.temps = self.tempData.map {
//						return $0.temperatureDouble
//					}
//					self.humids = self.tempData.map {
//						return $0.humidityDouble
//					}
//					self.refreshTemperatureHumidity()
//					self.refreshTemperatureChart()
//					self.refreshHumidityChart()
//				}
//			}
//		}
//	}
//
//	func refreshTemperatureHumidity() {
//		if let temp = temps.last {
//			temperatureLabel.text = String(format: "%.01f", temp) + "°C"
//		}
//		if let humidity = humids.last {
//			humidityLabel.text = String(format: "%.0f", humidity) + "%"
//		}
//	}
//
//	func refreshTemperatureChart() {
//		print("Temps: \(self.temps)")
//		temperatureChart.data = {
//			temperatureChart.configureDefaults()
//			temperatureChart.xAxis.drawLabelsEnabled = false
//
//			let dataSet = LineChartDataSet(
//				values:
//				temps
//					.enumerated()
//					.map{
//						dayIndex, total in ChartDataEntry(
//							x: Double(dayIndex),
//							y: total
//						)
//				},
//				label: nil
//			)
//			dataSet.colors = [.white]
//			dataSet.drawCirclesEnabled = false
//
//			let gradientColors = [UIColor.blue.cgColor,
//														UIColor.red.cgColor]
//			let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//			dataSet.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//			dataSet.drawFilledEnabled = true
//			dataSet.fillAlpha = 1
//			dataSet.mode = .cubicBezier
//
//			let data = LineChartData(dataSets: [dataSet])
//			data.setDrawValues(false)
//			temperatureChart.animate(xAxisDuration: 0.5)
//			return data
//		}()
//	}
//
//	func refreshHumidityChart() {
//		print("Humids: \(self.humids)")
//		humidityChart.data = {
//			humidityChart.configureDefaults()
//			humidityChart.xAxis.drawLabelsEnabled = false
//			let dataSet = LineChartDataSet(
//				values:
//				humids
//					.enumerated()
//					.map{
//						dayIndex, total in ChartDataEntry(
//							x: Double(dayIndex),
//							y: total
//						)
//				},
//				label: nil
//			)
//			dataSet.colors = [.white]
//			dataSet.drawCirclesEnabled = false
//			dataSet.drawFilledEnabled = true
//			let gradientColors = [UIColor.green.cgColor,
//														UIColor.blue.cgColor]
//			let gradient = CGGradient(colorsSpace: nil, colors: gradientColors as CFArray, locations: nil)!
//
//			dataSet.fill = Fill(linearGradient: gradient, angle: 90) //.linearGradient(gradient, angle: 90)
//			dataSet.drawFilledEnabled = true
//			dataSet.fillAlpha = 1
//			dataSet.mode = .cubicBezier
//
//
//			let data = LineChartData(dataSets: [dataSet])
//			data.setDrawValues(false)
//			humidityChart.animate(xAxisDuration: 0.5)
//			return data
//		}()
//	}
//
//}
//
//private extension BarLineChartViewBase {
//	func configureDefaults() {
//		chartDescription?.enabled = false
//		legend.enabled = false
//		backgroundColor = .clear
//
//		for axis in [xAxis, leftAxis] {
//			axis.drawAxisLineEnabled = false
//			axis.drawGridLinesEnabled = false
//		}
//		leftAxis.labelTextColor = .white
//		rightAxis.enabled = false
//	}
//}
//
