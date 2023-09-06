//
//  ViewController.swift
//  PedometerApp
//
//  Created by Tauseef Kamal on 05/09/2023.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    @IBOutlet weak var pedoDataLabel: UILabel!
    
    private var numberOfSteps: Int = 0
    private var distanceWalked: Double = 0
    private var pace: Double = 0
    
    private let pedometer = CMPedometer()

    override func viewDidLoad() {
        super.viewDidLoad()
        startPedometerUpdates()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopPedometerUpdates()
    }
        
    func startPedometerUpdates() {
        guard CMPedometer.isStepCountingAvailable() else {
            print("Step counting is not available on this device.")
            return
        }

        let startOfDay = Calendar.current.startOfDay(for: Date())

        pedometer.startUpdates(from: startOfDay) { (data, error) in
            //get the steps from the start of the day
            if let steps = data?.numberOfSteps.intValue {
                DispatchQueue.main.async {
                    self.numberOfSteps = steps
                    self.updateLabel()
                }
            }

            //get the distance walked in meters and then convert to KM
            if let distance = data?.distance?.doubleValue {
                DispatchQueue.main.async {
                    let distanceKM = distance / 1000.00
                    self.distanceWalked = distanceKM
                    self.updateLabel()
                }
            }
                
            //get the average active pace in seconds per meter
            if let paceData = data?.averageActivePace?.doubleValue {
                DispatchQueue.main.async {
                    self.pace = paceData
                    self.updateLabel()
                }
            }

            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
        
    func updateLabel() {
        pedoDataLabel.text = """
            Steps taken today: \(numberOfSteps)
            Distance Walked: \(String(format:"%.3f",distanceWalked)) km
            Average Pace: \(String(format:"%.3f",pace)) secs/m
            """
    }
        
    func stopPedometerUpdates() {
        pedometer.stopUpdates()
    }
}
