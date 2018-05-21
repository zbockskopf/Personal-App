//
//  MainMenuViewController2.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 2/25/18.
//  Copyright © 2018 Zach Bockskopf. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
class MainMenuController2:  UIViewController {
    
//Global Varaibles
    let db = DataBase()
    
    
//UI Elements

    
    let buttonContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    let cashBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
//        button.backgroundColor = UIColor.green
        return button
    }()
    
    let checkBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let saveBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let creditBtn: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //checkIfUserIsLoggedIn()
        //view.addSubview(buttonContainer)
        //setupBtnContainer()
        //addBtns()
        
        view.addSubview(cashBtn)
        view.addSubview(saveBtn)
        view.addSubview(creditBtn)
        view.addSubview(checkBtn)
        
        setupCashButton()
        setupSavingButton()
        setupCreditButton()
        setupCheckingButton()
        
        //db.setMonth(month: "March 2018")
        
        
    }
    
    func checkIfUserIsLoggedIn(){
        
        if Auth.auth().currentUser?.uid != nil {
            print("No User is logged in")
            perform(#selector(logout), with: nil, afterDelay: 0)
            self.performSegue(withIdentifier: "goToLoginScreen", sender: nil)
        }else{
            
            //self.uid = (Auth.auth().currentUser?.uid)!
            print("User is logged in")
        }
    }
    
    
//    func addBtns() {
//        var categories: Array<String> = []
//        var numCategories: Int = 0
//        var categoryName: String = "Test"
//        db.getAllCategories { (categoryArray) in
//            categories = categoryArray
//            numCategories = categories.count
//            print(numCategories)
//
//            for i in 0...(categories.count - 1){
//                let categoryBtn: UIButton = {
//                    let button = UIButton(type: .system)
//                    button.translatesAutoresizingMaskIntoConstraints = false
//                    return button
//                }()
//                self.buttonContainer.addSubview(categoryBtn)
//                self.setupButton(categoryName: categoryName, categoryBtn: categoryBtn)
//                print("Button number", i)
//            }
//        }
//
//
//    }
    
    
    
    
    func setupBtnContainer() {
        //buttonContainer.topAnchor.constraint(equalTo: .bottomAnchor, constant: 25).isActive = true
        buttonContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        buttonContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -25).isActive = true
        buttonContainer.heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        
        buttonContainer.addSubview(cashBtn)
        buttonContainer.addSubview(saveBtn)
        buttonContainer.addSubview(creditBtn)
        buttonContainer.addSubview(checkBtn)
        
        setupCashButton()
        setupSavingButton()
        setupCreditButton()
        setupCheckingButton()
    }
    
    func setupCashButton(){
        
        cashBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50).isActive = true
        cashBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        cashBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        cashBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        cashBtn.addTarget(self, action: #selector(categoryBtnClick), for: .touchUpInside)
        cashBtn.setTitle("Cash", for: .normal)
        cashBtn.tag = 1
    }
    
    func setupSavingButton(){
        
        saveBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        saveBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        saveBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        saveBtn.addTarget(self, action: #selector(categoryBtnClick), for: .touchUpInside)
        saveBtn.setTitle("Savings", for: .normal)
        saveBtn.tag = 2
    }
    
    func setupCreditButton(){
        
        creditBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 100).isActive = true
        creditBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        creditBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        creditBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        creditBtn.addTarget(self, action: #selector(categoryBtnClick), for: .touchUpInside)
        creditBtn.setTitle("Credit", for: .normal)
        creditBtn.tag = 3
    }
    
    func setupCheckingButton(){
        
        checkBtn.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 50).isActive = true
        checkBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkBtn.widthAnchor.constraint(equalToConstant: 100).isActive = true
        checkBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        checkBtn.addTarget(self, action: #selector(categoryBtnClick), for: .touchUpInside)
        checkBtn.setTitle("Checkings", for: .normal)
        checkBtn.tag = 4
    }
    
    
    @objc func categoryBtnClick(sender: UIButton)  {
        switch sender.tag {
        case 1:
            setupAlert(categoryName: "Cash")
        case 2:
            setupAlert(categoryName: "Savings")
        case 3:
            setupAlert(categoryName: "Credit Card")
        case 4:
            setupAlert(categoryName: "Checkings")
        default:
            return
        }
        
    }
    
    func setupAlert(categoryName: String) {
        let alert: UIAlertController = {
            let a = UIAlertController(title: "", message: "Enter an amount", preferredStyle: .alert)
            return a
        }()
        alert.title = categoryName
        alert.addTextField { (textfield) in
            textfield.placeholder = "Description"
        }
        alert.addTextField { (textfield) in
            textfield.placeholder = "Amount"
            
            //textfield.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert](_) in
            let descrptionTF = alert?.textFields![0]
            let amountTF = alert?.textFields![1]
            
            self.db.addToCategory(category: categoryName, changeAmount: (amountTF?.text)!)
            self.db.addToSpendings(description: (descrptionTF?.text)!, category: categoryName, amount: (amountTF?.text)!)
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    

    
    
    @objc func logout() -> Bool {
        do{
            try Auth.auth().signOut()
            print("User is logged out")
            return true
        }catch let logoutError{
            print(logoutError)
        }
        return false
    }
    
}
