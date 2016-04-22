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
    
    var expenses = [Expense]()
    
    private var fabMenu: Menu!
    
    /// FlatMenu component.
    private var flatMenu: Menu!
    
    /// FlashMenu component.
    private var flashMenu: Menu!
    
    /// Default spacing size
    let spacing: CGFloat = 16
    
    /// Diameter for FabButtons.
    let diameter: CGFloat = 56
    
    /// Height for FlatButtons.
    let height: CGFloat = 36
    
    let btn1: FlatButton = FlatButton()
    let btn2: FlatButton = FlatButton()
    let btn3: FlatButton = FlatButton()
    
    var newExpense = PFObject(className: "Expense")
    
    @IBOutlet weak var nameLabel: UILabel!

    @IBOutlet weak var owingLabel: UILabel!
    @IBOutlet weak var addExpenseButton: FlatButton!
    var mainBalanceAmount = 0.0
    var owingEzra: Float = 0.0
    var owingRam: Float = 0.0

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
        

        owingLabel.textColor = MaterialColor.grey.lighten1
        
        if let userName = PFUser.currentUser()?.username as? String! {
            nameLabel.text = "hi, \(userName)"
        } else {
            nameLabel.text = "hello"
        }
        
        

        
        mainBalance.text = "\(mainBalanceAmount)$"
        updateBackgroudColor()
        
        
        
        //addExpenseButton.addTarget(self, action: #selector(ViewController.toAddExpenseCycle), forControlEvents: .TouchUpInside)

        
        
        
        
        
        btn1.addTarget(self, action: #selector(ViewController.handleFlatMenu), forControlEvents: .TouchUpInside)
        btn1.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
        btn1.titleLabel?.font = RobotoFont.regularWithSize(12)
        btn1.backgroundColor = MaterialColor.white
        btn1.pulseColor = MaterialColor.white
        btn1.setTitle("Menu".uppercaseString, forState: .Normal)
        view.addSubview(btn1)
        
        
        btn2.setTitleColor(MaterialColor.white, forState: .Normal)
        btn2.titleLabel?.font = RobotoFont.regularWithSize(12)
        btn2.borderColor = MaterialColor.white
        btn2.pulseColor = MaterialColor.blue.accent3
        btn2.borderWidth = 1
        btn2.setTitle("Add Expense".uppercaseString, forState: .Normal)
        btn2.addTarget(self, action: #selector(ViewController.toAddExpenseCycle), forControlEvents: .TouchUpInside)
        view.addSubview(btn2)
        
        
        btn3.setTitleColor(MaterialColor.blueGrey.lighten1, forState: .Normal)
        btn3.titleLabel?.font = RobotoFont.regularWithSize(12)
        btn3.borderColor = MaterialColor.blueGrey.lighten1
        btn3.pulseColor = MaterialColor.blue.accent3
        btn3.borderWidth = 1
        btn3.setTitle("See Expenses".uppercaseString, forState: .Normal)
        btn3.addTarget(self, action: #selector(ViewController.toListExpenses), forControlEvents: .TouchUpInside)
        view.addSubview(btn3)
        
        let btn4: FlatButton = FlatButton()
        btn4.setTitleColor(MaterialColor.blue.accent3, forState: .Normal)
        btn4.borderColor = MaterialColor.blue.accent3
        btn4.pulseColor = MaterialColor.blue.accent3
        btn4.borderWidth = 1
        btn4.setTitle("Item", forState: .Normal)
        view.addSubview(btn4)
        
        // Initialize the menu and setup the configuration options.
        
        flatMenu = Menu(origin: CGPointMake(view.bounds.width/2 - 60, view.bounds.height - height - spacing))
        flatMenu.direction = .Up
        flatMenu.spacing = 8
        flatMenu.itemViewSize = CGSizeMake(120, height)
        flatMenu.views = [btn1, btn2, btn3]
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        flatMenu.close()
        if PFUser.currentUser() == nil {
            if let loginVC = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as? LoginViewController {
                
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
        
        
        
        var query = PFQuery(className:"Expense")
        //query.whereKey("Description", equalTo:"As Of 18 Apr 2016")
        query.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                print("Successfully retrieved \(objects!.count) scores.")
                // Do something with the found objects
                if let objects = objects {
                    self.expenses.removeAll()
                    for object in objects {
//                        print(object.objectForKey("SettlementEzra"))
                        if let desc = object.objectForKey("Description") as? String, billAmount = object.objectForKey("BillAmount") as? Float, oE = object.objectForKey("OwingEzra") as? Float, oR = object.objectForKey("OwingRam") as? Float {
                            
                            var currExpense = Expense(desc: desc, billAmount: billAmount)
                            currExpense.date = object.objectForKey("Date") as! String
                            currExpense.owingEzra = object.objectForKey("OwingEzra") as! Float
                            currExpense.owingRam = object.objectForKey("OwingRam") as! Float
                            currExpense.spentEzra = object.objectForKey("SpentEzra") as! Float
                            currExpense.spentRam = object.objectForKey("SpentRam") as! Float
                            
                            self.expenses.append(currExpense)
                            
                            
                            
                            self.owingEzra = oE
                            self.owingRam = oR
                            
                            self.newExpense["OwingEzra"] = oE
                            self.newExpense["OwingRam"] = oR
                            
                            self.updateBackgroudColor()
                        }
                    }
                    print(self.expenses)
                }
            } else {
                // Log details of the failure
                print("Error: \(error!) \(error!.userInfo)")
            }
        }
        
    }
    
    func handleFlatMenu() {
        // Only trigger open and close animations when enabled.
        if flatMenu.enabled {
            if flatMenu.opened {
                flatMenu.close()
            } else {
                flatMenu.open()
            }
        }
    }

    
    func updateBackgroudColor() {
        
        if let userName = PFUser.currentUser()?.username as? String! {
            nameLabel.text = "hi, \(userName)"
            
            newExpense["AddedBy"] = userName
        } else {
            nameLabel.text = "hello"
        }
        
        
        if PFUser.currentUser()?.username == "ezra" {
            
            self.mainBalance.text = "$\(owingEzra)"
            if self.owingEzra > 0.0 {
                self.view.backgroundColor = MaterialColor.deepPurple.accent4
                self.btn1.setTitleColor(MaterialColor.deepPurple.accent4, forState: .Normal)
                
            } else {
                self.view.backgroundColor = MaterialColor.indigo.accent4
                
                self.btn1.setTitleColor(MaterialColor.indigo.accent4, forState: .Normal)
                
            }
        } else if PFUser.currentUser()?.username == "ram" {
            self.mainBalance.text = "$\(owingRam)"
            if self.owingRam > 0.0 {
                self.view.backgroundColor = MaterialColor.deepPurple.accent4
                self.btn1.setTitleColor(MaterialColor.deepPurple.accent4, forState: .Normal)
                
                
            } else {
                self.view.backgroundColor = MaterialColor.indigo.accent4
                
                self.btn1.setTitleColor(MaterialColor.indigo.accent4, forState: .Normal)
                
            }
        }
        
        
    }
    
    func toListExpenses() {
        if let listExpensesVC = self.storyboard?.instantiateViewControllerWithIdentifier("ListExpensesController") as? ListExpensesController {
            listExpensesVC.expenses = self.expenses
            self.navigationController?.pushViewController(listExpensesVC, animated: true)
        }
    }
    
    func toAddExpenseCycle() {
        if let addExpenseVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddExpenseController") as? AddExpenseController {
            addExpenseVC.currentStep = AddExpenseStep.description
            addExpenseVC.newExpense = self.newExpense
            self.navigationController?.pushViewController(addExpenseVC, animated: true)
        }
    }
    
    
    


}

