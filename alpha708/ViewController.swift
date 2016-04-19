//
//  ViewController.swift
//  alpha708
//
//  Created by Ezra Bathini on 6/04/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Parse
import DigitsKit
import Material


class ViewController: UIViewController {
    
    
    

    @IBOutlet weak var addExpenseButton: FlatButton!
    var mainBalanceAmount = 0.00

    @IBOutlet weak var mainBalance: UILabel!
    @IBAction func login(sender: AnyObject) {
        
        PFUser.loginWithDigitsInBackground { (user, error) in
            if ((error == nil)) {
                print("SUCCESS")
            } else {
                print(error)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBarHidden = true
        
        /*
        let testObject = PFObject(className: "Expense")
        testObject["Description"] = "As Of 18 Apr 2016"
        testObject["Date"] = "\(NSDate())"
        testObject["BillAmount"] = 170472.65
        testObject["SpentRam"] = 114197.62
        testObject["SpentEzra"] = 43213.60
        testObject["Total"] = 170472.65
        testObject["ParityEzra"] = 0
        testObject["ParityRam"] = 0
        testObject["ShareEzra"] = 111519.35
        testObject["ShareRam"] = 58953.31
        testObject["SettlementEzra"] = -2678.28
        testObject["SettlemetRam"]  = 2678.28
        testObject.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
        }
        
        */
        
        var query = PFQuery(className:"Expense")
        //query.whereKey("Description", equalTo:"As Of 18 Apr 2016")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    for object in objects {
                        print(object.objectForKey("SettlementEzra"))
                        if let sE = object.objectForKey("SettlementEzra") as? Double {
                            self.mainBalanceAmount = sE
                            self.updateBackgroudColor()
                        }
                    }
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }

        
        mainBalance.text = "\(mainBalanceAmount)$"
        updateBackgroudColor()
        
        addExpenseButton.backgroundColor = UIColor.whiteColor()
        
        addExpenseButton.addTarget(self, action: #selector(ViewController.toAddExpenseCycle), forControlEvents: .TouchUpInside)

        
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateBackgroudColor() {
        self.mainBalance.text = "\(mainBalanceAmount)$"
        if self.mainBalanceAmount < 0.0 {
            self.view.backgroundColor = pomegranate
            self.addExpenseButton.setTitleColor(pomegranate, forState: .Normal)
        } else {
            self.view.backgroundColor = nephritis
            self.addExpenseButton.setTitleColor(nephritis, forState: .Normal)
        }
    }
    
    func toAddExpenseCycle() {
        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddExpenseController") as? AddExpenseController {
            addExpenseVC.currentStep = AddExpenseStep.description
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
    }
    
    
    


}

