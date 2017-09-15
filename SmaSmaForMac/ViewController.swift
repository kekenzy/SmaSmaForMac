//
//  ViewController.swift
//  SmaSmaForMac
//
//  Created by ADK114019 on 2016/12/27.
//  Copyright © 2016年 ADK114019. All rights reserved.
//

import Cocoa
import BleFormatterForMac

let SERVICE_UUID = "0BF806E9-F1FE-4326-AB21-CEAFDEAFE0E0"
let CHR_UUID_1 = "F5A6373E-B756-4B55-BE51-F8BD9A4A3193"
//let CHR_UUID_2 = "BC24FB53-E185-4C05-8221-FFF92242914F"

class ViewController: NSViewController {

    var bleManager:BleManager!;
    var dataFormat:[BleDataFormat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.bleManager = BleManager.sharedInstance;
        self.bleManager.setUUID(serviceUUID: SERVICE_UUID)
        self.dataFormat.append(BleDataFormat(uuid: CHR_UUID_1, dataType: .String))
//        self.dataFormat.append(BleDataFormat(uuid: CHR_UUID_2, dataType: .String))
        self.bleManager.setReadDataFormat(bleDataFormat: self.dataFormat)
        
        // observer登録
        self.bleManager.addObserver(self, withRead: #selector(ViewController.readNotification(_:)))
        self.bleManager.addObserver(self, withWrite: #selector(ViewController.writeNotification(_:)))
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func onClickButton(_ sender: Any) {
        bleManager.write(withString: "test", dataFormat: &self.dataFormat[0])

    
    
    }

    @IBAction func onClickSendHTTP(_ sender: Any) {
//        sendSmartDeviceData()

    }
    
    func sendSmartDeviceData(_ message:String) {
        let request: Request = Request()
        
        
//        no=C93057&user=kenji&used=false
        let urlTmp = "http://localhost:8000/insertEnginSpeed.php" + message
        let url: URL = URL(string: urlTmp)!
        let body: NSMutableDictionary = NSMutableDictionary()
        body.setValue("value", forKey: "key")
        
        do {

            try request.get(url: url, completionHandler: { data, response, error in
                if let dataValue = data {
                    print("\(dataValue)")
                    do {
                        let jsonNode = try JSONSerialization.jsonObject(with: dataValue, options: .allowFragments)
                        print("\(jsonNode)")
                        
                    } catch {
                        
                    }
                    
                }
            })
//        try request.post(url: url, body: body, completionHandler: { data, response, error in
//            print("\(data)")
            // code
//        })
        } catch {
            
        }
    }
    
    func sendSampleLaravel() {
        let request: Request = Request()
        
        let url: URL = URL(string: "http://172.28.36.66:8000/smartdata/3")!
//        let url: URL = URL(string: "http://localhost:8000/smartphones")!
        let body: NSMutableDictionary = NSMutableDictionary()
        body.setValue("value", forKey: "key")
        
        do {

            try request.get(url: url, completionHandler: { data, response, error in
                            print("\(data)")
                do {
                    let jsonNode = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                    print("\(jsonNode)")
                
                } catch {
                    
                }
            })
//        try request.post(url: url, body: body, completionHandler: { data, response, error in
//            print("\(data)")
            // code
//        })
        } catch {
            
        }
        
    }
    
    func readNotification(_ notification: Notification) {
        // 変数宣言時にアンラップ & キャストする方法
//        let userInfo = [BleDataKey.NOTIFY_READ.description():dataFormatList[index].characteristicUUID.description,
//                        BleDataKey.VALUE.description():dataFormatList[index].value] as [String : Any]
        //                        let value = self.dataFormatList[index].getStringFromValue()
        var tmpValue:String?
        guard let userInfo = notification.userInfo else {
            return
        }
        let data = userInfo[BleDataKey.NOTIFY_READ.description()] as! BleDataFormat
        switch data.dataType {
        case .String:
            tmpValue = data.getStringFromValue() as String
        case .Int:
            let i = data.getIntFromValue() as Int
            print("read Int value = \(i)")
            tmpValue = data.getStringFromValue() as String
        case .Double:
            let i = data.getDoubleFromValue() as Double
            print("read Double value = \(i)")
            tmpValue = data.getStringFromValue() as String
        case .Data:
            let i = data.getDataFromValue() as Data
            print("read Data value = \(i)")
            tmpValue = data.getStringFromValue() as String
        }
        
        guard let value = tmpValue else {
            print("can not read Notification message!!")
            return
        }
        print("read Notification message  =  \(value)")
        sendSmartDeviceData(value)
        
        let postName = data.getPostName() as String
        
//        self.myTalkFlg = false
//        talkList.insert(value + "," + postName, at: 0)
//        let indexPath = IndexPath(row: 0, section: 0)
//        self.tableView.insertRows(at: [indexPath], with: .automatic)
    }
    
    func writeNotification(_ notification: Notification) {
        // 変数宣言時にアンラップ & キャストする方法
        
//        self.msgText.text = ""
        return
    }
}

