//
//  DataBase.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 10/22/17.
//  Copyright © 2017 Zach Bockskopf. All rights reserved.
//

import UIKit
import Firebase


class DataBase {
    
    private var ref: DatabaseReference {
        return Database.database().reference()
    }
    
    private var uid: String? = (Auth.auth().currentUser?.uid)!
    private var currentMonth: String = "February 2018"
    
    
    
    
    func checkIfUserIsLoggedIn() -> Bool {
        if uid == nil {
            print("No User is logged in")
            return false
            
        }else{
            print("User is loged in")
            return true
        }
    }
        
    
    func readCheckings(completion: @escaping (String?) -> Void) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let checkings = value["Checkings"] as! Money
            let check = String(describing: checkings)
            completion(check)
        }
    }
    
    
    func readSavings(completion: @escaping (String?) -> Void) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let savings = value["Savings"] as! Double
            let save = String(savings)
            completion(save)
        }
    }
    
    func readCash(completion: @escaping (String?) -> Void) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let cashAm = value["Cash"] as! Double
            let cash = String(cashAm)
            completion(cash)
        }
    }
    
    func getAllChildren(completion: @escaping (Array<String>) -> Void) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            var childrenArray: Array<String> = []
            while let rest = enumerator.nextObject() as? DataSnapshot {
                //if rest.value == nil {
                childrenArray.append(rest.key)
                //}
                
            }
            completion(childrenArray)
        }
    }
    
    func getAllSubParents(completion: @escaping (Array<String>) -> Void) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            var childrenArray: Array<String> = []
            while let rest = enumerator.nextObject() as? DataSnapshot{
                if(rest.value(forKey: rest.key) != nil){
                    childrenArray.append(rest.key)
                }
            }
            completion(childrenArray)
        }
    }
    
    func getMonth(completion: @escaping (String?) -> Void) {
        self.ref.child("Current Month").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let month = value[self.uid!] as? String
            self.currentMonth = month!
            completion(month)
        }
    }
    
    func setMonth(month: String) {
        ref.child("Current Month").child(self.uid!).setValue(month)
    }
    
    func createNewMonth(month: String) {
        ref.child("Current Month").child(self.uid!).child(month).setValue("")
        currentMonth = month
    }
    
    func readCategory(completion: @escaping (String?) -> Void, category: String) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let catAmount = value[category] as? Double
            if catAmount != nil {
                let amount = String(describing: catAmount!)
                completion(amount)
            }
        }
    }
    
    func addCategory(category: String, amount: String){
        ref.child("Account Data").child(self.uid!).child(currentMonth).child(category).setValue(Double(amount))
    }
    
    func addToCategory(category: String, changeAmount: String, subCategroy: String? = "") {
        var categoryAmount: Double = 0
        let changeAmount = Double(changeAmount)!
        if subCategroy != ""{
            readCategory(completion: { (amount) in
                categoryAmount = Double(amount!)!
            }, category: category)
            categoryAmount += changeAmount
            ref.child("Account Data").child(self.uid!).child(currentMonth).child(subCategroy!).child(category).setValue(categoryAmount)
        }else{
            readCategory(completion: { (amount) in
                categoryAmount = Double(amount!)!
                categoryAmount += changeAmount
                self.ref.child("Account Data").child(self.uid!).child(self.currentMonth).child(category).setValue(categoryAmount)
            }, category: category)
            print(categoryAmount)
            
        }

    }
    
    
    
/*---------------------Spendings Functions------------------------*/
    func addToSpendings(description: String, category: String, amount: String) {
        //var categoryAmount: Double = 0
        let Amount = Double(amount)!
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd"
        let day = formater.string(from: date)
        

        self.ref.child("Spendings").child(self.uid!).child(self.currentMonth).child(day).child(category).child(description).setValue(Amount)
        self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child(category).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var tu = value["Times Used"] as! Int
            var total = value["Total"] as! Double
            
            tu += 1
            total += abs(Amount)
            
            self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child(category).child("Total").setValue(total)
            self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child(category).child("Times Used").setValue(tu)
        }
        
        self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child("Totals").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var tu = value["Times Used"] as! Int
            var total = value["Total"] as! Double
            
            tu += 1
            total += abs(Amount)
            
            self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child("Total").child("Total").setValue(total)
            self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child("Total").child("Times Used").setValue(tu)
        }
        
        
       
        //self.ref.child("Spendings").child(self.uid!).child(self.currentMonth).child(result).child("Amount").setValue(amount)
        
        
        }
    func getAmountDates(completion: @escaping (String, String) -> Void, description: String) {
        var amountArray: Array<String> = []
        var dateArray: Array<String> = []
        self.ref.child("Spendings").child(self.uid!).child(self.currentMonth).child(description).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            let amount = value["Amount"] as! Double
            let date = value["Date"] as! String
            var amountVal = String(amount)

//            amountArray.append(amountVal)
//            dateArray.append(date)
//            print("FUN SHIT",amountArray, dateArray)
            completion(amountVal, date)
        }
        
    }
    
    func getAllTransactions(completion: @escaping (Array<String>) -> Void) {
        self.ref.child("Spendings").child(uid!).child(currentMonth).observeSingleEvent(of: .value) { (snapshot) in
            let enumerator = snapshot.children
            var dateArray: Array<String> = []
            while let rest = enumerator.nextObject() as? DataSnapshot {
                //if rest.value == nil {
                dateArray.append(rest.key)

                //}
                
            }
            completion(dateArray)
        }
    }
    
//    func getSpendings(completion: @escaping () {
//
//    }
    
}

    

