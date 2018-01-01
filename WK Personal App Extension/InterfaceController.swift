//
//  InterfaceController.swift
//  WK Personal App Extension
//
//  Created by Zach Bockskopf on 12/31/17.
//  Copyright © 2017 Zach Bockskopf. All rights reserved.
//

import WatchKit
import Foundation
import WatchConnectivity


class InterfaceController: WKInterfaceController, WCSessionDelegate {

    

    @IBOutlet var cashLabel: WKInterfaceLabel!
    @IBOutlet var table: WKInterfaceTable!
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        cashLabel.setText("Testing")
        self.table.setNumberOfRows(3, withRowType: "CategroyRow")
        for i in 0...3 {
            
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        

        
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        
    }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        //cashLabel.setText(message["cashAmount"] as? String)
        cashLabel.setText("Hello")
    }

}
