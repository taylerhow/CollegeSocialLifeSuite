//
//  DebtTrackerViewController.swift
//  CollegeSocialLifeSuite
//
//  Created by Tayler How on 2/12/15.
//  Copyright (c) 2015 Tayler How. All rights reserved.
//

import UIKit

class DebtTrackerViewController: UIViewController {
    
    
    //---VARIABLES AND OUTLETS-----------------------------------------------------------
    var managedObjectContext : NSManagedObjectContext?

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var debtTextField: UITextField!
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var debtTrackerTableView: UIView!
//    let detailDebtViewSegueIdentifier = "DetailDebtViewSegue"
    let mainMenuSegueIdentifier = "MainMenuSegue"

    var name = ""
    var debt = ""
    var comment = ""
    
    //---BUTTONS AND TEXT FIELD FUNCTIONS------------------------------------------------
    @IBAction func nameEdited(sender: AnyObject) {
        name = nameTextField.text
    }
    
    @IBAction func debtEdited(sender: AnyObject) {
        debt = debtTextField.text
    }
    
    @IBAction func commentEdited(sender: AnyObject) {
        comment = commentTextField.text
    }
    
    @IBAction func pressedIOwe(sender: AnyObject) {
        dismissKeyboards()
        if !checkForBlanks(){
            (self.childViewControllers[0] as DebtTrackerTableViewController).addNewDebt(name, debt: debt, comment: comment, owesMe: false)
        }
    }
    
    @IBAction func pressedOwesMe(sender: AnyObject) {
        dismissKeyboards()
        if !checkForBlanks(){
            (self.childViewControllers[0] as DebtTrackerTableViewController).addNewDebt(name, debt: debt, comment: comment, owesMe: true)
        }
    }
    
    @IBAction func pressedClearButton(sender: AnyObject) {
        reset()
    }
    
    @IBAction func pressedEditTable(sender: AnyObject) {
        if (self.childViewControllers[0] as DebtTrackerTableViewController).editing == false {
            (self.childViewControllers[0] as DebtTrackerTableViewController).setEditing(true, animated: true)
        } else {
            (self.childViewControllers[0] as DebtTrackerTableViewController).setEditing(false, animated: true)
        }
        
    }
    
    func checkForBlanks() -> Bool{
        if(name == ""){
            let alertController = UIAlertController(title: "Oops!", message: "The 'Name' field was left blank.", preferredStyle: UIAlertControllerStyle.Alert)
        
            let cancelAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            }
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
            return true
        } else if(debt == ""){
            let alertController = UIAlertController(title: "Oops!", message: "The 'Debt' field was left blank.", preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Cancel) { (action) -> Void in
            }
            alertController.addAction(cancelAction)
            presentViewController(alertController, animated: true, completion: nil)
            return true
        }
        return false
    }
    
    func dismissKeyboards(){
        nameTextField.endEditing(true)
        debtTextField.endEditing(true)
        commentTextField.endEditing(true)
    }
    
    func reset(){
        name = ""
        debt = ""
        comment = ""
        nameTextField.text = ""
        debtTextField.text = ""
        commentTextField.text = ""
        nameTextField.placeholder = "Name"
        debtTextField.placeholder = "Debt"
        commentTextField.placeholder = "Comments"
        dismissKeyboards()
    }
    
    //---VIEW AND SEGUE HANDLING---------------------------------------------------------
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboards")
        tapRecognizer.cancelsTouchesInView = false
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        reset()
        self.view.addSubview(debtTrackerTableView)
        // Do any additional setup after loading the view.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == mainMenuSegueIdentifier){
            (segue.destinationViewController as ViewController).managedObjectContext = managedObjectContext
        }
    }
    
//    override func viewWillAppear(animated: Bool) {
//        println(self.managedObjectContext)
//        (self.childViewControllers[0] as DebtTrackerTableViewController).managedObjectContext = managedObjectContext
//        (self.childViewControllers[0] as DebtTrackerTableViewController).superVC = self
//    }

    //---CORE DATA HANDLING--------------------------------------------------------------

}
