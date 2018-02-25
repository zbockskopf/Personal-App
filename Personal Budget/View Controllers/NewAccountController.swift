//
//  NewAccountController.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 10/20/17.
//  Copyright © 2017 Zach Bockskopf. All rights reserved.
//

import UIKit
import FirebaseDatabase


class NewAccountController: UIViewController {
    
    
    
    var ref: DatabaseReference!
    var db = DataBase()
    var newMonth: Bool = true
    var currentState: String = "Month"
    
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white //UIColor(red: 84/255, green: 193/255, blue: 69/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let buttonContainter: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white //UIColor(red: 84/255, green: 193/255, blue: 69/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let monthTextField: UITextField = {
       let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let amountTextField: UITextField = {
       let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let doneButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Done", for: .normal)
        button.backgroundColor = UIColor(red: 84/255, green: 193/255, blue: 69/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.backgroundColor = UIColor(red: 84/255, green: 193/255, blue: 69/255, alpha: 1)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let label: UILabel = {
        let l = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        l.text = "Enter current month"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var inputContainerHeightAnchor: NSLayoutConstraint?
    var topTextFieldHeightAnchor: NSLayoutConstraint?
    var bottomTextFieldHeightAnchor: NSLayoutConstraint?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(inputContainer)
        view.addSubview(buttonContainter)
        
        setupLabel()
        setupinputContainer()
        setupButtonContainer()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func setupLabel() {
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: inputContainer.topAnchor, constant: -25).isActive = true
        label.widthAnchor.constraint(equalToConstant: 200).isActive = true
        label.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func setupinputContainer(){
        //inputContainer.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 25).isActive = true
        inputContainer.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -25).isActive = true
        inputContainerHeightAnchor = inputContainer.heightAnchor.constraint(equalToConstant: 50)
        inputContainerHeightAnchor?.isActive = true
        
        inputContainer.addSubview(monthTextField)

        setupMonthTextField()

    }
    
    func setupButtonContainer() {
        buttonContainter.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonContainter.topAnchor.constraint(equalTo: inputContainer.bottomAnchor).isActive = true
        buttonContainter.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        buttonContainter.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        buttonContainter.addSubview(doneButton)
        buttonContainter.addSubview(nextButton)
        
        setupDoneButton()
        setupNextButton()
    }
    
    func setupMonthTextField() {
        monthTextField.placeholder = "Month"
        monthTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        monthTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        monthTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        topTextFieldHeightAnchor = monthTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1)
        topTextFieldHeightAnchor?.isActive = true
    }
    
    
    func setupAmountTextField() {
        amountTextField.placeholder = "Amount"
        amountTextField.leftAnchor.constraint(equalTo: inputContainer.leftAnchor).isActive = true
        amountTextField.topAnchor.constraint(equalTo: monthTextField.bottomAnchor).isActive = true
        amountTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        bottomTextFieldHeightAnchor = amountTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/2)
        bottomTextFieldHeightAnchor?.isActive = true
    }
    
    
    func setupDoneButton() {
        doneButton.topAnchor.constraint(equalTo: buttonContainter.topAnchor).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        doneButton.centerXAnchor.constraint(equalTo: buttonContainter.centerXAnchor).isActive = true
        doneButton.addTarget(self, action: #selector(doneButtonClick), for: .touchUpInside)
    }
    
    func setupNextButton() {
        nextButton.topAnchor.constraint(equalTo: doneButton.bottomAnchor).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 75).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: buttonContainter.centerXAnchor).isActive = true
        nextButton.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
    }
    
    func changeInputConatiner() {
        inputContainerHeightAnchor?.isActive = false
        inputContainerHeightAnchor?.constant = 100
        inputContainerHeightAnchor?.isActive = true
        
        topTextFieldHeightAnchor?.isActive = false
        topTextFieldHeightAnchor = monthTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/2)
        topTextFieldHeightAnchor?.isActive = true
        
    }
    
    
    @objc func doneButtonClick() {
        
        switch currentState {
        case "Month":
            let month = monthTextField.text
            db.createNewMonth(month: month!)
            db.setMonth(month: month!)
            currentState = "Category"
            label.text = "Enter a Category"
            monthTextField.text = ""
            monthTextField.placeholder = "Category"
            changeInputConatiner()
            inputContainer.addSubview(amountTextField)
            
            setupAmountTextField()
            db.setMonth(month: month!)
            
        case "Category":
            let cat = monthTextField.text
            let amount = amountTextField.text
            db.addCategory(category:cat! , amount: amount!)
        default:
            break
        }   
        
        print(currentState)
//        let category = categoryTextField.text
//        let amount = amountTextField.text
//        db.addCategory(category: category!, amount: amount!)
    }
    
    
    @objc func nextButtonClick() {
        
        performSegue(withIdentifier: "goToMainMenuFromNewAccount", sender: nil)
    }
    
    
}
