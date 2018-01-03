//
//  ViewController.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 10/15/17.
//  Copyright © 2017 Zach Bockskopf. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth
import MessageUI
import WatchConnectivity

class MainMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, WCSessionDelegate {

    
    

    
    @IBOutlet weak var sideMenu: UIView!
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTable: UITableView!
    var menuIsShown = false
    @IBOutlet weak var feedBackBtn: UIButton!
    

    
    //Labels
    @IBOutlet weak var checkAmLbl: UILabel!
    @IBOutlet weak var savAmLbl: UILabel!
    @IBOutlet weak var cashAmLbl: UILabel!
    
    //Variables
    var ref: DatabaseReference!
    var uid: String? = ""
    var db = DataBase()
    var sideMenuArray: Array<String> = []
    var testArr: Array<String> = ["New Month", "Spendings"]
    
    
    //Watch Connectivity
    private var WCS: WCSession!
    private var cashAmount: String = ""
    private var messsageDict: [String: String] = ["Test": "Test"]
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Watch Stuff
        
        WCS = WCSession.default
        WCS.delegate = self
        WCS.activate()
        sendToWatch()
        
        
        
        
        
        
        
        
        // Do any additional setup after loading the view, typically from a nib.
        checkIfUserIsLoggedIn()
        ref = Database.database().reference()
        //ref.child("Account Data").child(uid!).child("November").child("Checkings").setValue(12)
        //getAllChildren()
        //populateSideMenu()
        //db.setMonth(month: "November 2017")
//        var currentMonth: String = ""
//        db.getMonth { (month) in
//            currentMonth = month!
//        }
        db.addToSpendings(description: "test item", category: "Cash", Amount: "1000.00")
        
        
        
        
        //side menu
        self.sideMenu.layer.shadowOpacity = 1
        self.sideMenu.layer.shadowRadius = 6
        
        
//Swipe Declarations
        
        //Left edge swipe. Used for opening the side menu
        let leftEdgeSwipe = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftEdgeGeature))
        leftEdgeSwipe.edges = .left
        self.view.addGestureRecognizer(leftEdgeSwipe)
        
        //Left swipe. Used to close the side menu
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(leftSwipe)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readCheckings()
        readCash()
        readSavings()
        getAllChildren()
        print("Side Menu Array", sideMenuArray)
    }
/*-----------------------------------------------------------------------------------------------*/
                        /*-Login Functions-*/
    
    func checkIfUserIsLoggedIn(){
        
        if Auth.auth().currentUser?.uid == nil {
            print("No User is logged in")
            perform(#selector(logout), with: nil, afterDelay: 0)
        }else{

            self.uid = (Auth.auth().currentUser?.uid)!
            print("User is logged in")
        }
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        let isLoggedOut = logout()
        if isLoggedOut {
            self.performSegue(withIdentifier: "goToLoginScreen", sender: nil)
        }
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
/*---------------------------------------------------------------------------------------------*/
                        /*-Side Menu functions-*/


    @IBAction func openMenu(_ sender: Any) {
        if menuIsShown{
            sideMenuLeadingConstraint.constant = -210
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }else{
            sideMenuLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuIsShown = !menuIsShown
    }
    
//Function for the left edge swipe
    @objc func leftEdgeGeature(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            sideMenuLeadingConstraint.constant = 0
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
    
//Function for swipe actions. (currently only detecting left swipes
    @objc func swipeAction(swipe:UISwipeGestureRecognizer) {
        
        if swipe.direction.rawValue == 2{
            sideMenuLeadingConstraint.constant = -210
            UIView.animate(withDuration: 0.2, animations: {
                self.view.layoutIfNeeded()
            })
        }
        menuIsShown = !menuIsShown
        
//Code for detecting left and right swipes, may have to use later
        
        switch swipe.direction.rawValue {
        case 1:
            //right swipe
            if menuIsShown{
                sideMenuLeadingConstraint.constant = 0
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        case 2:
            //left swipe
            if menuIsShown{
                sideMenuLeadingConstraint.constant = -210
                UIView.animate(withDuration: 0.2, animations: {
                    self.view.layoutIfNeeded()
                })
            }
        default:
            print("Failied")
            
        }
        
    }
    
/*---------------------------------------------------------------------------------------*/
                        /*-Feedback Functions-*/
    
    @IBAction func feedBackBtnClick(_ sender: Any) {

                
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            sendEmail()
        }
    
    
    func sendEmail() {
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["zbockskopf@icloud.com"])
        composeVC.setSubject("PB Feedback")
        composeVC.setMessageBody("Hello this is my message body!", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
            

    private func mailComposeController(controller: MFMailComposeViewController,
                                       didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        
                // Check the result or perform other tasks.
                // Dismiss the mail compose view controller.
//        switch result {
//        case .cancelled:
//            break
//        case .saved:
//            break
//        case .sent:
//            break
//        case .failed:
//            break
//
//        }
        
        controller.presentingViewController?.dismiss(animated: true, completion: nil)
    }
            

    
    
/*--------------------------------------------------------------------------------------------------*/
                                        /*-Fetch Data Functions-*/
    
    func readCheckings() {
        db.readCategory(completion: { (amount) in
            self.checkAmLbl.text? = amount!
            self.messsageDict.updateValue(amount!, forKey: "checkAmount")
        }, category: "Checkings")
        
    }
    
    func readSavings(){
        db.readSavings { (save) in
            self.savAmLbl.text = save!
            self.messsageDict.updateValue(save!, forKey: "saveAmont")
        }
    }

    func readCash(){
        
        db.readCategory(completion: { (amount) in
            self.cashAmLbl.text? = amount!
            self.messsageDict.updateValue(amount!, forKey: "cashAmount")
        }, category: "Cash")
        
//        db.readCash { (cash) in
//            self.cashAmLbl.text = cash!
//        }
    }

    
    func addToSpendings() {
        
    }
    
    func getAllChildren() {
        db.getAllChildren { (childenArray) in
            self.sideMenuArray = childenArray
            DispatchQueue.main.async{
                self.sideMenuTable.reloadData()
            }
        }

    }
    
    
/*----------------------------------------------------------------------------------------------------*/
                                    /*-Populate tables-*/

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        //return sideMenuArray.count
        return testArr.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        //cell.textLabel?.text = String(describing: sideMenuArray[indexPath.row])
        cell.textLabel?.text = String(describing: testArr[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        let TableViewCon = TableViewController()
        //        TableViewCon.stringPassed = String(describing: arr[indexPath.row])
        //
        //        present(TableViewCon, animated: true, completion: nil)
        
        if(indexPath.row == 1){
            let SpendCon = SpendingsController()
            //self.present(SpendCon, animated: true, completion: nil)
            self.performSegue(withIdentifier: "goToSpendings", sender: nil)
        }else{
            let NewMonthCon = NewAccountController()
            //self.present(NewMonthCon, animated: true, completion: nil)
            self.performSegue(withIdentifier: "gotToNewMonth", sender: nil)
        }

        
        
    }
    
    
    
    
/*----------------------------------------Watch Stuff-----------------------------*/
    
    func sendToWatch() {
        WCS.sendMessage(["cashAmount": cashAmLbl.text!], replyHandler: nil) { (error) in
            print(error)
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        session.delegate = self
//        session.activate()
//        session.sendMessage(messsageDict, replyHandler: nil) { (error) in
//            print(error)
//        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
}
