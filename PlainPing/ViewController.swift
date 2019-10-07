//
//  ViewController.swift
//  PlainPing
//
//  Created by Jonas Schoch on 02/11/2016.
//  Copyright (c) 2016 Jonas Schoch. All rights reserved.
//

import UIKit
import PlainPing

class ViewController: UIViewController {
    
    @IBOutlet weak var pingResultLabel: UILabel!
    @IBOutlet weak var connectionLabel: UILabel!
    @IBOutlet weak var IP: UILabel!
    @IBOutlet weak var deviceTypeHardCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        connectionLabel.isHidden = true
    }
    
    var timer = Timer()
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 5 seconds
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    var device = "192.168.1.184"
    
    @objc func updateCounting(){
        NSLog("counting..")
        pingDevice(device: device)
    }
    
    func pingDevice(device: String) {
        //withTimeout default : 1.0
        PlainPing.ping(device, withTimeout: 1.0, completionBlock: { (timeElapsed:Double?, error:Error?) in
            if let latency = timeElapsed {
                self.pingResultLabel.text = "latency (ms): \(latency)"
                self.connectionLabel.isHidden = false
                self.connectionLabel.text = "✅"
            }
            
            if let error = error {
                self.connectionLabel.isHidden = false
                self.connectionLabel.text = "❗️"
                self.pingResultLabel.text = "Device is Offline!"
                print("error: \(error.localizedDescription)")
            }
        })
    }
    
    @IBAction func pingButtonPressed(_ sender: UIButton) {
//        let device = "192.168.1.184"
//        pingDevice(device: device)
        scheduledTimerWithTimeInterval()
        print(device)
    }
    @IBAction func stopPingButton(_ sender: Any) {
        timer.invalidate()
    }
    
    
    @IBAction func addDevice(_ sender: UIButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Enter Device IP Address", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Enter Device IP Address", style: .default) { (action) in
            let newDevice = textField.text!
            self.device = newDevice
            self.IP.text = self.device
            self.deviceTypeHardCode.text = "Device Type: iPhone"
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Enter Device IP Address"
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func clearDevicePressed(_ sender: UIButton) {
        device = ""
        self.IP.text = "Add a Device"
        self.deviceTypeHardCode.text = "Device Type:"
        self.pingResultLabel.text = "Latency:"
        self.connectionLabel.text = "Connection:"
    }
    
}

