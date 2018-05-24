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
import Charts

class MainMenuController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {
    

    
    @IBOutlet weak var sideMenu: UIView!
    @IBOutlet weak var sideMenuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuTable: UITableView!
    var menuIsShown = false
    @IBOutlet weak var feedBackBtn: UIButton!
    @IBOutlet weak var chartView: PieChartView!
    

    
    //Labels
    @IBOutlet weak var checkAmLbl: UILabel!
    @IBOutlet weak var savAmLbl: UILabel!
    @IBOutlet weak var cashAmLbl: UILabel!
    @IBOutlet weak var creditLbl: UILabel!
    
    //Variables
    var ref: DatabaseReference!
    var uid: String? = ""
    var db = DataBase()
    var sideMenuArray: Array<String> = []
    var testArr: Array<String> = ["New Month", "Spendings", "New Category", "Charts"]
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        checkIfUserIsLoggedIn()
//        ref = Database.database().reference()
//        ref.child("Account Data").child(uid!).child("March 2018").child("Savings").setValue("1244.29")
//        ref.child("Account Data").child(uid!).child("March 2018").child("Cash").setValue(String("0"))
//        ref.child("Account Data").child(uid!).child("March 2018").child("Checkings").setValue(String("69.64"))
//        ref.child("Account Data").child(uid!).child("March 2018").child("Credit Card").setValue(String("54.26"))
        
        //logout()
        
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
        readCredit()
//        //getAllChildren()
        
        print("Side Menu Array", sideMenuArray)
    }
/*-----------------------------------------------------------------------------------------------*/
                        /*-Chart Functions-*/
    
    func pieChartUpdate() {
        
        // 2. generate chart data entries
        let checkings = Double(checkAmLbl.text!)
        let cash = Double(cashAmLbl.text!)
        let savings = Double(savAmLbl.text!)
        let credit = Double(creditLbl.text!)
        let track = ["Checkings", "Cash", "Savings", "Credit"]
        let money = [checkings, cash, savings, credit]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value!
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Pie Chart")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        chartView.data = data
        chartView.noDataText = "No data available"
        // user interaction
        chartView.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "iOSCharts.io"
        chartView.chartDescription = d
        chartView.centerText = "Pie Chart"
        chartView.holeRadiusPercent = 0.2
        chartView.transparentCircleColor = UIColor.clear
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
            print("Failed")
            
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
    
        
        controller.presentingViewController?.dismiss(animated: true, completion: nil)
    }
            

    
    
/*--------------------------------------------------------------------------------------------------*/
                                        /*-Fetch Data Functions-*/
    
    func readCheckings() {
        db.readCategory(completion: { (amount) in
            self.checkAmLbl.text? = amount!
        }, category: "Checkings")
//        db.readCheckings { (amount) in
//            self.checkAmLbl.text? = amount!
//        }
    }
    
    func readSavings(){
        db.readSavings { (save) in
            self.savAmLbl.text = save!
            
        }
    }

    func readCash(){
        
        db.readCategory(completion: { (amount) in
            self.cashAmLbl.text? = amount!
        }, category: "Cash")
        
//        db.readCash { (cash) in
//            self.cashAmLbl.text = cash!
//        }
    }
    
    func readCredit(){
        db.readCategory(completion: { (amount) in
            self.creditLbl.text? = amount!
            self.pieChartUpdate()
        }, category: "Credit Card")
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
            //let SpendCon = SpendingsController()
            //self.present(SpendCon, animated: true, completion: nil)
            self.performSegue(withIdentifier: "goToSpendings", sender: nil)
//            let chartController = ChartViewController()
//            self.present(chartController, animated: true, completion: nil)
        }else{
            //let NewMonthCon = NewAccountController()
            //self.present(NewMonthCon, animated: true, completion: nil)
            self.performSegue(withIdentifier: "goToNewMonth", sender: nil)
        }

        
        
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    
}
