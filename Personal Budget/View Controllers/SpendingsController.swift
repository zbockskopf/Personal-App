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
    
    var db = DataBase()
    
    let monthLbl: UILabel = {
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    


    @IBOutlet weak var transactionTable: UITableView!
    

    var transactions: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(monthLbl)
        
        setupMonthLbl()
        
        
        
        
    

    }
    
    override func viewWillAppear(_ animated: Bool) {
        populateTable()
    }
    
    func setupMonthLbl(){
        monthLbl.text = db.getMonth()
        monthLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        monthLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
    }
    
    func populateTable() {
        db.getAllMonthlyTransactions(completion: { (transArray) in
//            for (key, value) in transDict{
//                var temp: String = ""
//                for i in value{
//                    temp += i.0
//                    temp += i.1
//                    temp += i.2
//                }
//
//
//                self.transactions.append(temp)
//            }
            print("Transactions", transArray)
            self.transactions = transArray
            DispatchQueue.main.async{
                self.transactionTable.reloadData()
            }
        })


//        db.getAllTransactions { (description) in
//            self.allDescriptions = description
//            for des in self.allDescriptions {
//                self.db.getAmountDates(completion: { (amounts, dates) in
//                    self.allAmount.append(amounts)
//                    self.allDates.append(dates)
//                    print(dates, amounts)
//                }, description: des)
//            }
//                    }
//        DispatchQueue.main.async{
//            self.descriptionTable.reloadData()
//        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        return transactions.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        
        if tableView == transactionTable{
            cell.textLabel?.text = String(describing: transactions[indexPath.row])
        }
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        
        
    }
    
    
}
