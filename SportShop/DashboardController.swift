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
import HealthKit
import Kinvey

class DashboardController: UIViewController{
    
    @IBOutlet var pieChart: PieChartView!

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
    
    lazy var stepsIndexPath = IndexPath(item: 0, section: 0)
    lazy var kcalBurnedIndexPath = IndexPath(item: 1, section: 0)
    lazy var distanceIndexPath = IndexPath(item: 2, section: 0)
    lazy var exerciseTimeIndexPath = IndexPath(item: 3, section: 0)
    
    lazy var apptStore:DataStore<Appointment> = {
        return DataStore<Appointment>.collection(.cache)
    }()

    
    var steps = 0 {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadItems(at: [self.stepsIndexPath])
            }
        }
    }
    
    var kcalBurned = 0 {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadItems(at: [self.kcalBurnedIndexPath])
            }
        }
    }
    
    var distanceInMeters = 0.0 {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadItems(at: [self.distanceIndexPath])
            }
        }
    }
    
    var exerciseTimeInMinutes = 0 {
        didSet {
            DispatchQueue.main.async {
                self.collectionView?.reloadItems(at: [self.exerciseTimeIndexPath])
            }
        }
    }
    
    var appointments = [Appointment]()
    
    lazy var healthKitStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let pageOne = Query {
            $0.limit = 3
        }

        apptStore.find (pageOne) { (items, error) in
            if let items = items {
                self.appointments = items
                self.collectionView?.reloadData()
            } else {
                print ("\(String(describing: error))")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    
        //slight hack. Should be in leftnav
        if Kinvey.sharedClient.activeUser == nil {
            let login = self.storyboard?.instantiateViewController(withIdentifier: "AccountViewController") as! AccountViewController
            present(login, animated: true, completion: {
                print("login presented")
            })
        }
        
        else {
            let typesToRead = Set<HKObjectType>([
                //            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.dateOfBirth)!,
                //            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.bloodType)!,
                //            HKObjectType.characteristicType(forIdentifier: HKCharacteristicTypeIdentifier.biologicalSex)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!,
                HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!,
                HKObjectType.activitySummaryType()
                ])
            
            healthKitStore.requestAuthorization(toShare: nil, read: typesToRead) { (succeed, error) in
                if succeed {
                    self.loadSteps()
                    self.loadKCalBurned()
                    self.loadDistance()
                    self.loadExerciseTime()
                }
            }
        }
    }
    
    var predicate: NSPredicate {
        let calendar = Calendar.current
        let now = Date()
        let dateComponents = calendar.dateComponents([.calendar, .era, .year, .month, .day], from: now)
        let startDate = calendar.date(from: dateComponents)
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: now)
        return predicate
    }
    
    func loadSteps() {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int.max, sortDescriptors: nil) { (sampleQuery, results, error) in
            let sum = results?.filter({
                $0 is HKQuantitySample
            }).map({
                $0 as! HKQuantitySample
            }).reduce(0, {
                $0 + Int($1.quantity.doubleValue(for: HKUnit.count()))
            })
            if let sum = sum {
                self.steps = sum
            }
        }
        healthKitStore.execute(query)
    }
    
    func loadKCalBurned() {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.activeEnergyBurned)!
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int.max, sortDescriptors: nil) { (sampleQuery, results, error) in
            let sum = results?.filter({
                $0 is HKQuantitySample
            }).map({
                $0 as! HKQuantitySample
            }).reduce(0, {
                $0 + Int($1.quantity.doubleValue(for: HKUnit.kilocalorie()))
            })
            if let sum = sum {
                self.kcalBurned = sum
            }
        }
        healthKitStore.execute(query)
    }
    
    func loadDistance() {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int.max, sortDescriptors: nil) { (sampleQuery, results, error) in
            let sum = results?.filter({
                $0 is HKQuantitySample
            }).map({
                $0 as! HKQuantitySample
            }).reduce(0.0, {
                $0 + $1.quantity.doubleValue(for: HKUnit.meter())
            })
            if let sum = sum {
                self.distanceInMeters = sum
            }
        }
        healthKitStore.execute(query)
    }
    
    func loadExerciseTime() {
        let sampleType = HKSampleType.quantityType(forIdentifier: HKQuantityTypeIdentifier.appleExerciseTime)!
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int.max, sortDescriptors: nil) { (sampleQuery, results, error) in
            let sum = results?.filter({
                $0 is HKQuantitySample
            }).map({
                $0 as! HKQuantitySample
            }).reduce(0, {
                $0 + Int($1.quantity.doubleValue(for: HKUnit.minute()))
            })
            if let sum = sum {
                self.exerciseTimeInMinutes = sum
            }
        }
        healthKitStore.execute(query)
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
            switch indexPath {
            case stepsIndexPath:
                cell.titleLabel.text = "STEPS"
                cell.iconImageView.image = UIImage(named: "steps")
                cell.scoreLabel.text = String(steps)
                cell.goalLabel.text = "Goal: 10,000"
                cell.ringView.ringColor = UIColor("#41D3AC")
                cell.ringView.progress = CGFloat(steps) / 10000
            case kcalBurnedIndexPath:
                cell.titleLabel.text = "kCAL BURNED"
                cell.iconImageView.image = UIImage(named: "kcal burned")
                cell.scoreLabel.text = String(kcalBurned)
                cell.goalLabel.text = "Goal: 450"
                cell.ringView.ringColor = UIColor("#D3418A")
                cell.ringView.progress = CGFloat(kcalBurned) / 450
            case distanceIndexPath:
                cell.titleLabel.text = "DISTANCE (km)"
                cell.iconImageView.image = UIImage(named: "distance")
                let distanceInKm = distanceInMeters / 1000
                
                let numberFormatter = NumberFormatter()
                numberFormatter.minimumIntegerDigits = 1
                numberFormatter.maximumFractionDigits = 1
                cell.scoreLabel.text = numberFormatter.string(for: distanceInKm)
                
                cell.goalLabel.text = "Goal: 7.5"
                cell.ringView.ringColor = UIColor("#41A0D3")
                cell.ringView.progress = CGFloat(distanceInKm) / 7.5
            case exerciseTimeIndexPath:
                cell.titleLabel.text = "EXERCISE TIME"
                cell.iconImageView.image = UIImage(named: "metric")
                cell.scoreLabel.text = String(exerciseTimeInMinutes)
                cell.goalLabel.text = "Goal: 30 minutes"
                cell.ringView.ringColor = UIColor("#E8D964")
                cell.ringView.progress = CGFloat(exerciseTimeInMinutes) / 30
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
                
                if let apptDate = appointment.apptDate {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateStyle = .medium
                    dateFormatter.timeStyle = .none
                    cell.dateLabel.text = dateFormatter.string(from: apptDate)
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateStyle = .none
                    timeFormatter.timeStyle = .short
                    cell.timeLabel.text = timeFormatter.string(from: apptDate)
                
                }
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
    @IBOutlet weak var ringView: RingView!
    
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
