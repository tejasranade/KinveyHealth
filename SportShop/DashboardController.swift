//
//  DashboardController.swift
//  KinveyHealth
//
//  Created by Tejas on 5/1/17.
//  Copyright © 2017 Kinvey. All rights reserved.
//

import UIKit
import Foundation
import Charts

class DashboardController: UIViewController{
    @IBOutlet var pieChart: PieChartView!
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //pieChart.data = data

        let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        let unitsSold = [20.0, 4.0, 6.0, 3.0, 12.0, 16.0]
        
        setChart(dataPoints: months, values: unitsSold)
        
    }
    
    func setChart(dataPoints: [String], values: [Double]) {
        
        var dataEntries: [PieChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i])
            dataEntries.append(dataEntry)
        }
        
        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "Units Sold")
//        pieChart.data = PieChartData(dataSet: pieChartDataSet)
        
        
        var colors: [UIColor] = []
        
        for _ in 0..<dataPoints.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        
        pieChartDataSet.colors = colors
        

    }
}

class DashboardCollectionViewController: UICollectionViewController {
    
    var appointments = [Appointment]()
    
    @IBAction func leftButtonTapped(_ sender: Any) {
        let appDelegate:AppDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.drawerController?.toggleLeftView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appointment1 = Appointment()
        appointment1.doctor = "Personal training"
        appointment1.title = "Boston, MA"
        appointment1.apptDate = Date(timeIntervalSinceNow: 86400)
        appointments.append(appointment1)
        
        let appointment2 = Appointment()
        appointment2.doctor = "Dr. Dolittle"
        appointment2.title = "Boston, MA"
        appointment2.apptDate = Date(timeIntervalSinceNow: 86400 * 5)
        appointments.append(appointment2)
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 4
        case 1:
            return 1 + appointments.count
        case 2:
            return 2
        default:
            return 0
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Progress", for: indexPath) as! DashboardCollectionViewCell
            switch indexPath.item {
            case 0:
                cell.titleLabel.text = "STEPS"
                cell.iconImageView.image = UIImage(named: "steps")
                cell.scoreLabel.text = "7,500"
                cell.goalLabel.text = "Goal: 10,000"
            case 1:
                cell.titleLabel.text = "kCAL BURNED"
                cell.iconImageView.image = UIImage(named: "kcal burned")
                cell.scoreLabel.text = "203"
                cell.goalLabel.text = "Goal: 450"
            case 2:
                cell.titleLabel.text = "DISTANCE (km)"
                cell.iconImageView.image = UIImage(named: "distance")
                cell.scoreLabel.text = "4.25"
                cell.goalLabel.text = "Goal: 7.5"
            case 3:
                cell.titleLabel.text = "METRIC"
                cell.iconImageView.image = UIImage(named: "metric")
                cell.scoreLabel.text = "###"
                cell.goalLabel.text = "Goal: ###"
            default:
                fatalError()
            }
            return cell
        case 1:
            switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Upcoming Appointments", for: indexPath)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Appointment", for: indexPath) as! AppointmentCollectionViewCell
                let appointment = appointments[indexPath.item - 1]
                cell.doctorLabel.text = appointment.doctor
                cell.locationLabel.text = appointment.title
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .medium
                dateFormatter.timeStyle = .none
                cell.dateLabel.text = dateFormatter.string(from: appointment.apptDate!)
                
                let timeFormatter = DateFormatter()
                timeFormatter.dateStyle = .none
                timeFormatter.timeStyle = .short
                cell.timeLabel.text = timeFormatter.string(from: appointment.apptDate!)
                return cell
            }
        case 2:
            switch indexPath.item {
            case 0:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Expense Tracker", for: indexPath)
                return cell
            default:
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Expense Chart", for: indexPath) as! ExpenseChartCollectionViewCell
                let data: [(String, Double)] = [
                    ("Jan", 35),
                    ("Feb", 20),
                    ("Mar", 50),
                    ("Apr", 12.5),
                    ("May", 12.5),
                    ("Jun", 25),
                    ("Jul", 37.5)
                ]
                cell.data = data
                return cell
            }
        default:
            fatalError()
        }
    }
    
}

extension DashboardCollectionViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            return CGSize(width: 164, height: 192)
        case 1:
            return CGSize(width: collectionView.bounds.size.width - 32, height: 52)
        case 2:
            switch indexPath.item {
            case 0:
                return CGSize(width: collectionView.bounds.size.width - 32, height: 52)
            case 1:
                return CGSize(width: collectionView.bounds.size.width - 32, height: 172)
            default:
                return CGSize.zero
            }
        default:
            return CGSize.zero
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch section {
        case 1:
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        default:
            return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        switch section {
        case 0:
            return 10
        default:
            return 0
        }
    }
    
}

class DashboardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
}

class AppointmentCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var doctorLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}

class ExpenseChartCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var value1Label: UILabel!
    @IBOutlet weak var value2Label: UILabel!
    @IBOutlet weak var value3Label: UILabel!
    @IBOutlet weak var value4Label: UILabel!
    @IBOutlet weak var value5Label: UILabel!
    
    lazy var valueLabels: [UILabel] = {
        return [
            self.value5Label,
            self.value4Label,
            self.value3Label,
            self.value2Label,
            self.value1Label
        ]
    }()
    
    @IBOutlet weak var month1Label: UILabel!
    @IBOutlet weak var month2Label: UILabel!
    @IBOutlet weak var month3Label: UILabel!
    @IBOutlet weak var month4Label: UILabel!
    @IBOutlet weak var month5Label: UILabel!
    @IBOutlet weak var month6Label: UILabel!
    @IBOutlet weak var month7Label: UILabel!
    
    lazy var monthLabels: [UILabel] = {
        return [
            self.month1Label,
            self.month2Label,
            self.month3Label,
            self.month4Label,
            self.month5Label,
            self.month6Label,
            self.month7Label
        ]
    }()
    
    @IBOutlet weak var bar1LayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar2LayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar3LayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar4LayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar5LayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar6LayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var bar7LayoutConstraint: NSLayoutConstraint!
    
    subscript(index: Int) -> NSLayoutConstraint {
        get {
            switch index {
            case 0:
                return bar1LayoutConstraint
            case 1:
                return bar2LayoutConstraint
            case 2:
                return bar3LayoutConstraint
            case 3:
                return bar4LayoutConstraint
            case 4:
                return bar5LayoutConstraint
            case 5:
                return bar6LayoutConstraint
            case 6:
                return bar7LayoutConstraint
            default:
                fatalError()
            }
        }
        set {
            switch index {
            case 0:
                bar1LayoutConstraint = newValue
            case 1:
                bar2LayoutConstraint = newValue
            case 2:
                bar3LayoutConstraint = newValue
            case 3:
                bar4LayoutConstraint = newValue
            case 4:
                bar5LayoutConstraint = newValue
            case 5:
                bar6LayoutConstraint = newValue
            case 6:
                bar7LayoutConstraint = newValue
            default:
                fatalError()
            }
        }
    }
    
    @IBOutlet weak var bar1View: UIView!
    @IBOutlet weak var bar2View: UIView!
    @IBOutlet weak var bar3View: UIView!
    @IBOutlet weak var bar4View: UIView!
    @IBOutlet weak var bar5View: UIView!
    @IBOutlet weak var bar6View: UIView!
    @IBOutlet weak var bar7View: UIView!
    
    lazy var barViews: [UIView] = {
        return [
            self.bar1View,
            self.bar2View,
            self.bar3View,
            self.bar4View,
            self.bar5View,
            self.bar6View,
            self.bar7View
        ]
    }()
    
    var data = [(String, Double)]() {
        didSet {
            guard data.count == 7 else {
                fatalError("data must have 7 items")
            }
            
            let maxValue = data.map { (_, value) in
                return value
            }.max()!
            let bracketIncremental = Int(round((maxValue / 5) / 5) * 5)
            
            for (i, valueLabel) in valueLabels.enumerated() {
                valueLabel.text = String((i + 1) * bracketIncremental)
            }
            
            for ((key, _), monthLabel) in zip(data, monthLabels) {
                monthLabel.text = key.uppercased()
            }
            
            for (i, ((_, value), barView)) in zip(data, barViews).enumerated() {
                let barLayoutConstraint = self[i]
                let newBarLayoutConstraint = NSLayoutConstraint(
                    item: barLayoutConstraint.firstItem,
                    attribute: barLayoutConstraint.firstAttribute,
                    relatedBy: barLayoutConstraint.relation,
                    toItem: barLayoutConstraint.secondItem,
                    attribute: barLayoutConstraint.secondAttribute,
                    multiplier: CGFloat(value / maxValue),
                    constant: barLayoutConstraint.constant
                )
                let superview = barView.superview!
                superview.removeConstraint(barLayoutConstraint)
                superview.addConstraint(newBarLayoutConstraint)
                self[i] = newBarLayoutConstraint
            }
        }
    }
    
}
