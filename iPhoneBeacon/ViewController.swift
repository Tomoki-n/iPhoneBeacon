//
//  ViewController.swift
//  iPhoneBeacon
//
//  Created by 山口将槻 on 2015/10/16.
//  Copyright © 2015年 山口将槻. All rights reserved.
//

import UIKit
import CoreBluetooth
import CoreLocation

class ViewController: UIViewController, CBPeripheralManagerDelegate {
    
    @IBOutlet weak var cover: UIView!
    @IBOutlet weak var majorLabel: UILabel!
    @IBOutlet weak var minorLabel: UILabel!
    @IBOutlet weak var majorStepper: UIStepper!
    @IBOutlet weak var minorStepper: UIStepper!
    
    var peripheralManager:CBPeripheralManager!
    var myUUID:NSUUID!
    var startLocation:CGPoint?
    
    var major:UInt16 = 0
    var minor:UInt16 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        self.myUUID = NSUUID(UUIDString: "00000000-88F6-1001-B000-001C4D2D20E6")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        print("state: \(peripheral.state)")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        self.startLocation = touch?.locationInView(self.view)
        let myRegion = CLBeaconRegion(proximityUUID: self.myUUID!, major: self.major, minor: self.minor, identifier: self.myUUID.UUIDString)
        self.peripheralManager.startAdvertising(myRegion.peripheralDataWithMeasuredPower(nil) as? [String : AnyObject])
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let location = touch?.locationInView(self.view)
        if touch?.view?.tag == 1 {
            if self.cover.frame.origin.x > -40 && location!.x - self.startLocation!.x < 0 {
                self.cover.frame.origin.x = location!.x - self.startLocation!.x
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.peripheralManager.stopAdvertising()
        UIView.animateWithDuration(0.4) { () -> Void in
            self.cover.frame.origin.x = 0
        }
    }

    @IBAction func major(sender: AnyObject) {
        let value = NSNumber(double: majorStepper.value)
        self.majorLabel.text = String(value.integerValue)
        self.major = value.unsignedShortValue
    }
    
    @IBAction func minor(sender: AnyObject) {
        let value = NSNumber(double: minorStepper.value)
        self.minorLabel.text = String(value.integerValue)
        self.minor = value.unsignedShortValue
    }
    
    
}

