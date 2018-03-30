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
    private var currentMonth: String = "March 2018"
//    private var currentMonth: String {
//        let defaults = UserDefaults.standard
//        let token = defaults.string(forKey: "currentMonth")
//        return token!
//    }
    
    
    
    
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
            let checkings = value["Checkings"] as! String
            let check = String(describing: checkings)
            completion(check)
        }
    }
    

    func readSavings(completion: @escaping (String?) -> Void) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let savings = value["Savings"] as! String
            let save = String(describing: savings)
            completion(save)
        }
    }
    
    func readCash(completion: @escaping (String?) -> Void) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let cashAm = value["Cash"] as! String
            let cash = String(describing: cashAm)
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
    
//    func getMonth(completion: @escaping (String?) -> Void) {
//        self.ref.child("Current Month").observeSingleEvent(of: .value) { (snapshot) in
//            let value = snapshot.value as! NSDictionary
//            let month = value[self.uid!] as? String
//            self.currentMonth = month!
//            completion(month)
//        }
//    }
//
//    func getMonth(){
//        var month: String = ""
//        self.ref.child("Current Month").observeSingleEvent(of: .value) { (snapshot) in
//            let value = snapshot.value as! NSDictionary
//            month = value[self.uid!] as! String
//        }
//
//        currentMonth = month
//    }
    
    func setMonth(month: String) {
        ref.child("Current Month").child(self.uid!).setValue(month)
        let defaults = UserDefaults.standard
        defaults.set(month, forKey: "currentMonth")
        defaults.synchronize()
        print("called")
    }
    
    func createNewMonth(month: String) {
        ref.child("Current Month").child(self.uid!).setValue(month)
        //currentMonth = month
    }
    
    func readCategory(completion: @escaping (String?) -> Void, category: String) {
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let catAmount = value[category] as! String
            if catAmount != nil {
                completion(catAmount)
            }
        }
    }
    
    func addCategory(category: String, amount: String){
        ref.child("Account Data").child(self.uid!).child(currentMonth).child(category).setValue(amount)
    }
    
    func addToCategory(category: String, changeAmount: String, subCategroy: String? = "") {
        var categoryAmount:String = ""
        if subCategroy != ""{
            readCategory(completion: { (amount) in
                categoryAmount = amount!
                let temp_catAmt = Money(amt: categoryAmount, currency: .USD)
                let temp_changeAmt = Money(amt: changeAmount, currency: .USD)
                let temp_total = temp_catAmt + temp_changeAmt
                categoryAmount = String(temp_total.amount)
                self.ref.child("Account Data").child(self.uid!).child(self.currentMonth).child(subCategroy!).child(category).setValue(categoryAmount)
            }, category: category)

        }else{
            readCategory(completion: { (amount) in
                categoryAmount = amount!
                let temp_catAmt = Money(amt: categoryAmount, currency: .USD)
                let temp_changeAmt = Money(amt: changeAmount, currency: .USD)
                let temp_total = temp_catAmt + temp_changeAmt
                categoryAmount = String(temp_total.amount)
                self.ref.child("Account Data").child(self.uid!).child(self.currentMonth).child(category).setValue(categoryAmount)
            }, category: category)
            

            
        }

    }
    
    

/*---------------------Spendings Functions------------------------*/
    func addToSpendings(description: String, category: String, amount: String) {
        
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "MM-dd"
        let day = formater.string(from: date)
        
        self.ref.child("Stats").child(self.uid!)
        self.ref.child("Spendings").child(self.uid!).child(self.currentMonth).child(day).child(category).child(description).setValue(amount)
        self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child(category).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var tu = value["Times Used"] as! Int
            let total = value["Total"] as! String
            
            let temp_catAmt = Money(amt: amount, currency: .USD)
            let temp_changeAmt = Money(amt: total, currency: .USD)
            let temp_total = temp_catAmt + temp_changeAmt
            
            tu += 1
            
            self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child(category).child("Total").setValue(String(abs(temp_total.amount)))
            self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child(category).child("Times Used").setValue(tu)
        }

        
        self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child("Total").observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! NSDictionary
            var tu = value["Times Used"] as! Int
            let total = value["Total"] as! String
            
            tu += 1
            let temp_catAmt = Money(amt: amount, currency: .USD)
            let temp_changeAmt = Money(amt: total, currency: .USD)
            let temp_total = temp_catAmt + temp_changeAmt
            
            self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child("Total").child("Total").setValue(String(abs(temp_total.amount)))
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
    
    func getAllCategories(completion: @escaping (Array<String>) -> Void) {
        var categoryArray: Array<String> = []
        
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) { (snapshot) in
            let dict = snapshot.value as! NSDictionary
            categoryArray = dict.allKeys as! Array<String>
            
            completion(categoryArray)
        }
    }
    
    
    
    
    
    
    
    
    
   ///////    Testing functions
    
    
    func addToCheckings(amount: String) {
        
        let Amount = NSDecimalNumber(string: amount)
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let checkings = value["Checkings"] as! NSDecimalNumber
            let check = String(describing: checkings)
            self.ref.child("Account Data").child(self.uid!).child(self.currentMonth).child("Checkings").setValue(Amount)
            
        }
        
    }
    
    func addToCash(amount: String) {
        
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let cash = value["Cash"] as! String
            
            let temp_catAmt = Money(amt: cash, currency: .USD)
            let temp_changeAmt = Money(amt: amount, currency: .USD)
            let temp_total = temp_catAmt + temp_changeAmt

            self.ref.child("Account Data").child(self.uid!).child(self.currentMonth).child("Cash").setValue(String(temp_total.amount))
            
        }
        
    }
    
    
    func addToSavings(amount: String) {
        
        let Amount = NSDecimalNumber(string: amount)
        self.ref.child("Account Data").child(uid!).child(currentMonth).observeSingleEvent(of: .value) {(snapshot) in
            let value = snapshot.value as! NSDictionary
            let checkings = value["Savings"] as! NSDecimalNumber
            let check = String(describing: checkings)
            self.ref.child("Account Data").child(self.uid!).child(self.currentMonth).child("Savings").setValue(Amount)
            
        }
        
    }
    
    func setupStats(currentState: String, category: String?) {
        
        if currentState == "Month" {
            self.ref.child("Stats").child(uid!).child(currentMonth).child("Total").child("Times Used").setValue(0)
        self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child("Total").child("Total").setValue("0")
        }else{
            self.ref.child("Stats").child(uid!).child(currentMonth).child(category!).child("Times Used").setValue(0)
            self.ref.child("Stats").child(self.uid!).child(self.currentMonth).child(category!).child("Total").setValue("0")
        }
        
    }
    
}

    

