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
    
    @IBOutlet weak var descriptionTable: UITableView!
    @IBOutlet weak var amountTable: UITableView!
    @IBOutlet weak var dateTable: UITableView!
    
    
    var db = DataBase()
    var allDescriptions: Array<String> = []
    var allAmount: Array<String> = []
    var allDates: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        populateTable()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    
    func populateTable() {
        
        db.getAllTransactions { (description) in
            self.allDescriptions = description
            for des in self.allDescriptions {
                self.db.getAmountDates(completion: { (amounts, dates) in
                    self.allAmount = amounts
                    self.allDates = dates
                    DispatchQueue.main.async{
                        self.amountTable.reloadData()
                        self.dateTable.reloadData()
                    }
                }, description: des)
            }
            DispatchQueue.main.async{
                self.descriptionTable.reloadData()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return sideMenuArray.count
        if tableView == descriptionTable {
            return allDescriptions.count
        }
        if tableView == amountTable{
            return allAmount.count
        }
        if tableView == dateTable{
            return allDates.count
        }
        
        return 1
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        
        if tableView == descriptionTable{
            cell.textLabel?.text = String(describing: allDescriptions[indexPath.row])
        }
        
        if tableView == amountTable{
            cell.textLabel?.text = String(describing: allAmount[indexPath.row])
        }
        
        if tableView == dateTable{
            cell.textLabel?.text = String(describing: allDates[indexPath.row])
        }
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let TableViewCon = TableViewController()
        //        TableViewCon.stringPassed = String(describing: arr[indexPath.row])
        //
        //        present(TableViewCon, animated: true, completion: nil)
        
//        if(indexPath.row == 1){
//            let SpendCon = SpendingsController()
//            self.present(SpendCon, animated: true, completion: nil)
//        }else{
//            let NewMonthCon = NewAccountController()
//            self.present(NewMonthCon, animated: true, completion: nil)
//        }
        
        
        
    }
    
    
}
