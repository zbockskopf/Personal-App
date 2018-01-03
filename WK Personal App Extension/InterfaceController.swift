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

    

    
    @IBOutlet var table: WKInterfaceTable!

    @IBOutlet var testLbl: WKInterfaceLabel!
    
    
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.



        
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
    private func session(_ session: WCSession, didReceiveMessage message: [String : String]) {
        //cashLabel.setText(message["cashAmount"] as? String)
        testLbl.setText(message["cashAmount"])
        self.table.setNumberOfRows(3, withRowType: "CategoryRow")
        for i in 0...3{
            let currentRow = self.table.rowController(at: i) as? WatchTable
            currentRow?.categoryLbl.setText(message["cashAmount"])
            
            currentRow?.amountLbl.setText("World")
        }
    }

}
