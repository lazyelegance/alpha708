//
//  AddExpenseController.swift
//  alpha708
//
//  Created by Ezra Bathini on 18/04/16.
//  Copyright © 2016 Ezra Bathini. All rights reserved.
//

import UIKit
import Material
import Parse

class AddExpenseController: UIViewController, UITextFieldDelegate {
    
    var placeHolderText = "Description"
    
    var nextPlaceHolder = "Bill Amount"
    
    var currentStep = AddExpenseStep.description
    
    var newExpense = PFObject(className: "Expense")
    
    

    @IBOutlet weak var descriptionTF: TextField!
    @IBOutlet weak var nextButton: FlatButton!
    @IBOutlet weak var backButton: FlatButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = peterrock
        
        let viewWidth = view.frame.size.width
        
        

        //descriptionTF = TextField(frame: CGRectMake(57, 150, 300, 24))
        descriptionTF.backgroundColor = peterrock
        descriptionTF.placeholder = currentStep.toString()
        descriptionTF.placeholderTextColor = peterrock_2
        descriptionTF.font = RobotoFont.regularWithSize(20)
        descriptionTF.textColor = MaterialColor.white
        
        descriptionTF.titleLabel = UILabel()
        descriptionTF.titleLabel!.font = RobotoFont.mediumWithSize(15)
        descriptionTF.titleLabelColor = MaterialColor.white
        descriptionTF.titleLabelActiveColor = MaterialColor.white
        
        descriptionTF.delegate = self
        
        descriptionTF.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: UIControlEvents.EditingDidEndOnExit)
        descriptionTF.addTarget(self, action: #selector(AddExpenseController.showNextButton), forControlEvents: UIControlEvents.EditingChanged)
        if currentStep == AddExpenseStep.billAmount {
            descriptionTF.keyboardType = .DecimalPad
        }
        
        
        descriptionTF.becomeFirstResponder()
        
        
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
        
        nextButton.layer.shadowOpacity = 0.1

        nextButton.addTarget(self, action: #selector(AddExpenseController.toNextInAddExpenseCycle), forControlEvents: .TouchUpInside)
        
        nextButton.alpha = 0
        
        
        backButton.setTitle("BACK", forState: .Normal)
        backButton.setTitleColor(MaterialColor.white, forState: .Normal)
        backButton.titleLabel?.font = RobotoFont.regularWithSize(12)
        
        let image = UIImage(named: "ic_close_white")?.imageWithRenderingMode(.Automatic)

        
        
        let clearButton: FlatButton = FlatButton()
        clearButton.pulseColor = MaterialColor.grey.base
        clearButton.pulseScale = false
        clearButton.tintColor = MaterialColor.grey.base
        clearButton.setImage(image, forState: .Normal)
        clearButton.setImage(image, forState: .Highlighted)
        
        descriptionTF.clearButton = clearButton

//        view.addSubview(descriptionTF)
//        view.addSubview(nextButton)
        //view.addSubview(cancelButton)


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - TextField
    
    

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        return true
    }
    
    

    
    // MARK: - Navigation
    /*
    

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func showNextButton() {
        self.nextButton.alpha = 1
    }
    
    func toNextInAddExpenseCycle()  {
        //
        
        
        
        self.descriptionTF.resignFirstResponder()
        
        if ((self.descriptionTF.text?.isEmpty) == false) {
            
            if currentStep == .billAmount {
                self.newExpense[self.currentStep.mongoField()] = (self.descriptionTF.text! as NSString).floatValue
            } else {
                self.newExpense[self.currentStep.mongoField()] = self.descriptionTF.text
            }
            
            
            if self.currentStep.nextStep() == .parity {
                if let parityVC = self.storyboard?.instantiateViewControllerWithIdentifier("ParityViewController") as? ParityViewController {
                    parityVC.currentStep = self.currentStep.nextStep()
                    parityVC.newExpense = self.newExpense
                    self.navigationController?.pushViewController(parityVC, animated: true)
                    
                }
            } else {
                if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddExpenseController") as? AddExpenseController {
                    addExpenseVC.currentStep = self.currentStep.nextStep()
                    addExpenseVC.newExpense = self.newExpense
                    self.navigationController?.pushViewController(addExpenseVC, animated: true)
                }
            }
        }
        
        
        
    }

    @IBAction func backOneStep(sender: AnyObject) {
        
        navigationController?.popViewControllerAnimated(true)
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
}
