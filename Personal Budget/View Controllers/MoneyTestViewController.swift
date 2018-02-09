//
//  MoneyTestViewController.swift
//  Personal Budget
//
//  Created by Zach Bockskopf on 2/8/18.
//  Copyright © 2018 Zach Bockskopf. All rights reserved.
//

import UIKit

class MoneyTestViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let x: USD = 100.50
        let y: USD = 20.50
        
        let z: Double = 100.50
        let v: Double = 20.50
        
        
        print("This is adding USD: " , x + y)
        print("This is adding Double: ", z + v)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    



}
