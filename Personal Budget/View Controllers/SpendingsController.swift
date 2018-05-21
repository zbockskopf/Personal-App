//
//  SpendingsController.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 12/22/17.
//  Copyright © 2017 Zach Bockskopf. All rights reserved.
//



/* This controller is used to show all the transactions for the current month */

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SpendingsController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    let label: UILabel = {
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        l.text = "Enter current month"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    


    @IBOutlet weak var transactionTable: UITableView!
    
    var db = DataBase()
    var transactionsDict: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        //populateTable()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
//    func populateTable() {
//
//
//        db.getAllTransactions { (description) in
//            self.allDescriptions = description
//            for des in self.allDescriptions {
//                self.db.getAmountDates(completion: { (amounts, dates) in
//                    self.allAmount.append(amounts)
//                    self.allDates.append(dates)
//                    print(dates, amounts)
//                }, description: des)
//            }
//            DispatchQueue.main.async{
//                self.descriptionTable.reloadData()
//            }
//        }
//    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return sideMenuArray.count
//        if tableView == descriptionTable {
//            return allDescriptions.count
//        }

        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        
//        if tableView == descriptionTable{
//            cell.textLabel?.text = String(describing: allDescriptions[indexPath.row])
//        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        
    }
    
    
}
