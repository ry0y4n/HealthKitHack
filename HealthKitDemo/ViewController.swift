//
//  ViewController.swift
//  HealthKitDemo
//
//  Created by momosuke on 2020/07/07.
//  Copyright © 2020 momosuke. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController {

    let healthStore = HKHealthStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        authorizeHealthKit()
    }
    func authorizeHealthKit() {
        let read = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        let share = Set([HKObjectType.quantityType(forIdentifier: .heartRate)!])
        healthStore.requestAuthorization(toShare: share, read: read) { (chk, error) in
            if (chk) {
                print("permission granted")
                self.latestHeartRate()
            }
        }
    }

    func latestHeartRate() {
        
        guard let sampleType = HKObjectType.quantityType(forIdentifier: .heartRate) else {
            return
        }
        let startDate = Calendar.current.date(byAdding: .month, value: -1, to: Date())
        
        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictEndDate)
        
        let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
        
        let query = HKSampleQuery(sampleType: sampleType, predicate: predicate, limit: Int(HKObjectQueryNoLimit), sortDescriptors: [sortDescriptor]) { (sample, result, error ) in
            
            guard error == nil else {
                return
            }
//            let data = result![0] as! HKQuantitySample
//            let unit = HKUnit(from: "count/min")
//            let latestHr = data.quantity.doubleValue(for: unit)
//            print("Data Count \(result!.count)")
//            print("Latest Hr\(latestHr) BPM")
            
            for i in 0...result!.count-1 {
                let data = result![i] as! HKQuantitySample
                let unit = HKUnit(from: "count/min")
                let Hr = data.quantity.doubleValue(for: unit)
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy hh:mm s"
                let StartDate = dateFormatter.string(from: data.startDate)
                let EndDate = dateFormatter.string(from: data.endDate)
                
                print("Heart Rate[\(i)] = \(Hr) BPM. Start: \(StartDate), End: \(EndDate)")
            }
            
//            for data in result! {
//                let HeartRate = data.quantity.doubleValue(for: unit)
//                print("HeartRate \(HeartRate) BPM")
//            }
            
//            let dataFormatter = DateFormatter()
//            dataFormatter.dateFormat = "dd/MM/yyyy hh:mm s"
//            let StartDate = dataFormatter.string(from: data.startDate)
//            let EndDate = dataFormatter.string(from: data.endDate)
//            print("StartDate \(StartDate) : EndDate \(EndDate)")
        }
        healthStore.execute(query)
    }

}

