//
//  ViewController.swift
//  BlueToothSample
//
//  Created by Sivakumar on 01/03/19.
//  Copyright © 2019 Sivakumar. All rights reserved.
//

import UIKit
import CoreBluetooth
struct  PeripheralBO {
    var objCBPeripheral: CBPeripheral?
    var RSSI: NSNumber?
}

class ViewController: UIViewController, CBCentralManagerDelegate {

    @IBOutlet weak var tblView: UITableView!
    var peripherals:[PeripheralBO] = []
    var arrCBPeripheral: [CBPeripheral] = []
    var manager:CBCentralManager? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        manager = CBCentralManager(delegate: self, queue: DispatchQueue.main);

        
        let nib = UINib(nibName: "DeviceTableViewCell", bundle: nil)
        self.tblView.register(nib, forCellReuseIdentifier: "DeviceTableViewCell");
    }
    override func viewDidAppear(_ animated: Bool) {
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    @IBAction func btnScanTouchUpInside(_ sender: UIButton) {
        scanBLEDevices()
    }
    
    // MARK: BLE Scanning
    func scanBLEDevices() {
        //manager?.scanForPeripherals(withServices: [CBUUID.init(string: parentView!.BLEService)], options: nil)
        
        //if you pass nil in the first parameter, then scanForPeriperals will look for any devices.
        manager?.scanForPeripherals(withServices: nil, options: nil)
        
        //stop scanning after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            //            self.stopScanForBLEDevices()
            //           self.scanBLEDevices();
        }
    }
    
    func stopScanForBLEDevices() {
        manager?.stopScan()
    }
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("### we are checking the state");
        print(central.state)
        
        switch central.state{
        case .poweredOn:
            central.scanForPeripherals(withServices: nil, options: nil)
        default:
            central.stopScan()
        }
    }
    
    // MARK: - CBCentralManagerDelegate Methods
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        
        if(!arrCBPeripheral.contains(peripheral)){
            arrCBPeripheral.append(peripheral)
           
            var obj = PeripheralBO()
            obj.objCBPeripheral = peripheral
            obj.RSSI = RSSI;

            peripherals.append(obj)

        }
//        print(peripheral.discoverServices(nil))
        print("\(advertisementData)");
        self.tblView.reloadData()
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("-- didConnect -- ")
        print("Connected to " +  peripheral.name!)

    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
       print("---- didFailToConnect -----")
        print(error!)
    }
    

    

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : DeviceTableViewCell = (tableView.dequeueReusableCell(withIdentifier: "DeviceTableViewCell") as? DeviceTableViewCell)!
        cell.selectionStyle = .none
        let obj = peripherals[indexPath.row]
        
        cell.lblID.text = obj.objCBPeripheral?.identifier.description
        cell.lblRssiVal.text = obj.RSSI?.description
        cell.lblNameVal.text = obj.objCBPeripheral?.name ?? "No Name"

        return cell;
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let objPeri = peripherals[indexPath.row].objCBPeripheral;
        
        manager?.connect(objPeri!, options: nil)

    }

}

