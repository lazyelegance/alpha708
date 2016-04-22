//
//  FinishViewController.swift
//  alpha708
//
//  Created by Ezra Bathini on 19/04/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import Parse


class FinishViewController: UIViewController {
    
    var parityText = "Shared Equally (1:1)"

    var newExpense = PFObject(className: "Expense")
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var billAmountLabel: UILabel!
    
    @IBOutlet weak var parityLabel: UILabel!
    
    @IBOutlet weak var finishButton: FlatButton!
    
    @IBOutlet weak var startOverButton: FlatButton!
    @IBOutlet weak var backButton: FlatButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        view.backgroundColor = MaterialColor.indigo.base
        finishButton.backgroundColor = MaterialColor.white
        
        
        finishButton.setTitle("FINISH", forState: .Normal)
        
        
        finishButton.setTitleColor(MaterialColor.blueGrey.darken1, forState: .Normal)
        finishButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        finishButton.pulseColor = MaterialColor.blue.accent3
        finishButton.pulseScale = true
        finishButton.tintColor = MaterialColor.blue.accent3
        
        finishButton.layer.cornerRadius = 30
        
        finishButton.addTarget(self, action: #selector(FinishViewController.saveExpense), forControlEvents: .TouchUpInside)
        
        finishButton.layer.shadowOpacity = 0.1
        
        startOverButton.backgroundColor = MaterialColor.indigo.accent2
        
        
        startOverButton.setTitle("START OVER", forState: .Normal)
        
        
        startOverButton.setTitleColor(MaterialColor.white, forState: .Normal)
        startOverButton.titleLabel?.numberOfLines = 2
        startOverButton.titleLabel?.lineBreakMode = .ByWordWrapping
        startOverButton.titleLabel?.textAlignment = .Center
        startOverButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        startOverButton.pulseColor = MaterialColor.red.accent3
        startOverButton.pulseScale = true
        startOverButton.tintColor = MaterialColor.red.accent3
        
        startOverButton.layer.cornerRadius = 30
        startOverButton.layer.shadowOpacity = 0.1
        
        startOverButton.addTarget(self, action: #selector(FinishViewController.startOver), forControlEvents: .TouchUpInside)
        
        if let description = newExpense.objectForKey("Description") as? String {
            descriptionLabel.text = description
        }
        
        if let billAmount = newExpense.objectForKey("BillAmount") {
            billAmountLabel.text = "$\(billAmount)"
        }
        
        parityLabel.text = parityText
        
        
        backButton.setTitle("BACK", forState: .Normal)
        backButton.setTitleColor(MaterialColor.white, forState: .Normal)
        backButton.titleLabel?.font = RobotoFont.regularWithSize(12)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func backOneStep(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    func startOver() {
        print("start Over")
        
        if ((self.navigationController?.viewControllers[1].isKindOfClass(AddExpenseController)) == true) {
            self.navigationController?.popToViewController((self.navigationController?.viewControllers[1])!, animated: true)
        }
        
        
    }

    
    func saveExpense() {
        print("boo")
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
        
        
        
        let timzoneSeconds = NSTimeZone.localTimeZone().secondsFromGMT
        
        let currDate = NSDate().dateByAddingTimeInterval(Double(timzoneSeconds))
        
        newExpense["Date"] = "\(currDate)"
        
        let billAmount = newExpense["BillAmount"] as! Float
        let parityEzra = newExpense["ParityEzra"] as! Int
        let parityRam = newExpense["ParityRam"] as! Int
        let owingEzra = newExpense["OwingEzra"] as! Float
        let owingRam = newExpense["OwingRam"] as! Float
        
        
        
        let totalParity = parityEzra + parityRam
        
        newExpense["Total"] = billAmount
        
        if (parityEzra + parityRam) != 0 {
            newExpense["ShareEzra"] = billAmount*Float(parityEzra)/Float(totalParity)
            newExpense["ShareRam"] = billAmount*Float(parityRam)/Float(totalParity)
            
        }
        if PFUser.currentUser()?.username == "ezra" {
            newExpense["SpentEzra"] = billAmount
            newExpense["SpentRam"] = 0.00
        } else if PFUser.currentUser()?.username == "ram" {
            newExpense["SpentRam"] = billAmount
            newExpense["SpentEzra"] = 0.00
        }
        
        newExpense["SettlementEzra"] = (newExpense["SpentEzra"] as! Float) - (newExpense["ShareEzra"] as! Float)
        newExpense["SettlementRam"] = (newExpense["SpentRam"] as! Float) - (newExpense["ShareRam"] as! Float)
        
        newExpense["OwingEzra"] = owingEzra - (newExpense["SettlementEzra"] as! Float)
        newExpense["OwingRam"] = owingRam - (newExpense["SettlementRam"] as! Float)
        
        print(newExpense)
        
        newExpense.saveInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            print("Object has been saved.")
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }

}
