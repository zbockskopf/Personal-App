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
    
    @IBOutlet weak var tableView: UITableView!
    var db = DataBase()
    var allTransactions: Array<String> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        db.getAllTransactions { (all) in
            self.allTransactions = all
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //return sideMenuArray.count
        
        return allTransactions.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        //cell.textLabel?.text = String(describing: sideMenuArray[indexPath.row])
        cell.textLabel?.text = String(describing: allTransactions[indexPath.row])
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
