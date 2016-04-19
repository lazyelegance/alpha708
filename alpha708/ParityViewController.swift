//
//  ParityViewController.swift
//  alpha708
//
//  Created by Ezra Bathini on 19/04/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import Parse



class ParityViewController: UIViewController {
    
    var currentStep = AddExpenseStep.description
    
    var newExpense = PFObject(className: "Expense")
    
    @IBOutlet weak var sharedEquallyLabel: UILabel!
    @IBOutlet weak var paidForOtherLabel: UILabel!
    @IBOutlet weak var paidForSelfLabel: UILabel!
    
    
    @IBOutlet weak var sharedEquallySwitch: UISwitch!
    
    @IBOutlet weak var paidForOtherSwitch: UISwitch!
    
    @IBOutlet weak var paidForSelfSwitch: UISwitch!
    
    @IBOutlet weak var nextButton: FlatButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = nephritis
        
        sharedEquallyLabel.text = "Shared Equally (1:1)"
        paidForOtherLabel.text = "Paid For Other (0:1)"
        paidForSelfLabel.text = "Paid For Self (1:0)"
        
        sharedEquallySwitch.on = true
        paidForOtherSwitch.on = false
        paidForSelfSwitch.on = false
        
        
        sharedEquallySwitch.addTarget(self, action: #selector(ParityViewController.switchAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        paidForOtherSwitch.addTarget(self, action: #selector(ParityViewController.switchAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        paidForSelfSwitch.addTarget(self, action: #selector(ParityViewController.switchAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        
        
        nextButton.backgroundColor = MaterialColor.white
        
        
        if currentStep == .finish {
            nextButton.setTitle("FINISH", forState: .Normal)
        } else {
            nextButton.setTitle("NEXT", forState: .Normal)
        }
        
        nextButton.setTitleColor(peterrock, forState: .Normal)
        nextButton.titleLabel?.font = RobotoFont.regularWithSize(8)
        nextButton.pulseColor = MaterialColor.blue.accent3
        nextButton.pulseScale = true
        nextButton.tintColor = MaterialColor.blue.accent3
        
        nextButton.layer.cornerRadius = 30
        
        nextButton.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: .TouchUpInside)
        
        /*
        

        sharedEquallySwitch.delegate = self
        paidForOtherSwitch.delegate = self
        paidForSelfSwitch.delegate = self
        
        sharedEquallySwitch.translatesAutoresizingMaskIntoConstraints = false
        paidForOtherSwitch.translatesAutoresizingMaskIntoConstraints = false
        paidForSelfSwitch.translatesAutoresizingMaskIntoConstraints = false
        */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func switchAction(sender: UISwitch) {
        print(sender.on)
        print(sender.tag)
        
        switch sender.tag {
        case 100:
            paidForOtherSwitch.setOn(false, animated: true)
            paidForSelfSwitch.setOn(false, animated: true)
        case 200:
            sharedEquallySwitch.setOn(false, animated: true)
            paidForSelfSwitch.setOn(false, animated: true)
        case 300:
            paidForOtherSwitch.setOn(false, animated: true)
            sharedEquallySwitch.setOn(false, animated: true)
        default:
            break
        }
    }
    
    
    func toNextInAddExpenseCycle()  {
        //
        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddExpenseController") as? AddExpenseController {
            addExpenseVC.currentStep = self.currentStep.nextStep()
            addExpenseVC.newExpense = self.newExpense
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
