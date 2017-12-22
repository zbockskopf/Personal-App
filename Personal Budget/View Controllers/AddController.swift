//
//  AddController.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 10/20/17.
//  Copyright © 2017 Zach Bockskopf. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class AddController: UIViewController, UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var ref: DatabaseReference!
    var mainMenuCon: MainMenuController!
    var uid: String? = ""
    var db = DataBase()
    var allChildren: Array<String> = []
    var selectedCategory: String = ""
    
    let alert: UIAlertController = {
        let a = UIAlertController(title: "", message: "Enter an amount", preferredStyle: .alert)
        return a
    }()
    
    
    override func viewDidLoad() {
        super .viewDidLoad()

        uid = (Auth.auth().currentUser?.uid)!
        //self.amountField.keyboardType = UIKeyboardType.numberPad
        setupAlert()
        populateArray()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    func setupAlert() {
        alert.title = selectedCategory
        alert.addTextField { (textfield) in
            textfield.placeholder = "Amount"
        }
        alert.addAction(UIAlertAction(title: "ok", style: .default, handler: { [weak alert](_) in
            let tf = alert?.textFields![0]
            tf?.keyboardType = .numberPad
            
            self.db.addToCategory(category: self.selectedCategory, changeAmount: (tf?.text)!)
            //makeChanges(selectedCategory: self.selectedCategory, category: <#String#>, changeAmount: <#String#>, subcat: <#String?#>)
        }))

    }
    
    
    
    
    /*-----------------------------------------------------------------------------------------------*/
    /*-Populate tables-*/
    func populateArray() {
        
        db.getAllChildren { (array) in
            self.allChildren = array
            DispatchQueue.main.async{
                self.tableView.reloadData()
            }
        }
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allChildren.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = String(describing: allChildren[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCategory = String(describing: allChildren[indexPath.row])
        self.present(alert, animated: true, completion: nil)
    }
}
