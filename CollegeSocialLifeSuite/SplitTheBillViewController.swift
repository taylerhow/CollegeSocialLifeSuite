//
//  SplitTheBillViewController.swift
//  CollegeSocialLifeSuite
//
//  Created by Tayler How & Trevor Burch on 2/6/15.
//  Copyright (c) 2015 Tayler How. All rights reserved.
//

import UIKit

class SplitTheBillViewController: UIViewController {
    
    let mainMenuSegueIdentifier = "MainMenuSegue"
    
    @IBOutlet weak var addDebtButton: UIButton!
    var managedObjectContext : NSManagedObjectContext?
    var totalAmount = 0.00;
    var numberOfPeople = 0.00;
    var splitAmount = 0.00;
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboards")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func dismissKeyboards(){
        totalAmountTextField.endEditing(true)
        numberOfPeopleTextField.endEditing(true)
    }

    @IBOutlet weak var totalAmountTextField: UITextField!
    @IBOutlet weak var numberOfPeopleTextField: UITextField!
    @IBOutlet weak var splitItButton: UIButton!
    @IBOutlet weak var eachPersonLabel: UILabel!
    @IBOutlet weak var splitAmountLabel: UILabel!
    @IBAction func selectedOut(sender: AnyObject) {
        totalAmountTextField.endEditing(true)
        numberOfPeopleTextField.endEditing(true)
    }
    @IBAction func pressedAddDebt(sender: AnyObject) {
        let alertController = UIAlertController(title: "Save your options", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Name"
            textField.textAlignment = NSTextAlignment.Center
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Debt"
            textField.text = String(format: "%.2f",self.splitAmount)
            textField.textAlignment = NSTextAlignment.Center
        }
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Comment"
            textField.textAlignment = NSTextAlignment.Center
        }
        
        let nameTextField = alertController.textFields![0] as UITextField
        let debtTextField = alertController.textFields![1] as UITextField
        let commentTextField = alertController.textFields![2] as UITextField
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        var debt = ""
        let iOweAction = UIAlertAction(title: "I Owe", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.addNewDebt(nameTextField.text, debt: debtTextField.text, comment: commentTextField.text, owesMe: false)
        }
        let theyOweAction = UIAlertAction(title: "They Owe", style: UIAlertActionStyle.Default) { (action) -> Void in
            self.addNewDebt(nameTextField.text, debt: debtTextField.text, comment: commentTextField.text, owesMe: true)
        }
        
        
        alertController.addAction(iOweAction)
        alertController.addAction(theyOweAction)
        alertController.addAction(cancelAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    func addNewDebt(name: NSString, debt: NSString, comment: NSString, owesMe: Bool){
        let newDebt = NSEntityDescription.insertNewObjectForEntityForName("Debt", inManagedObjectContext: self.managedObjectContext!) as Debt
        var nameAndDebtString = ""
        if !owesMe {
            nameAndDebtString = "I owe \(name): \(debt)"
        } else {
            nameAndDebtString = "\(name) owes me: \(debt)"
        }
        newDebt.nameAndDebt = nameAndDebtString
        newDebt.comment = comment
        newDebt.lastModified = NSDate()
        self.saveManagedObjectContext()
    }
    
    func saveManagedObjectContext() {
        var error : NSError?
        managedObjectContext?.save(&error)
        if(error != nil){
            println("Unresolved Core Data error \(error?.userInfo)")
            abort()
        }
    }
    
    @IBAction func totalAmountEdited(sender: AnyObject) {
        totalAmount = (totalAmountTextField.text as NSString).doubleValue
    }
    
    @IBAction func numberOfPeopleEdited(sender: AnyObject) {
        numberOfPeople = (numberOfPeopleTextField.text as NSString).doubleValue
    }
    
    @IBAction func pressedSplitIt(sender: AnyObject) {
        if(totalAmountTextField.text != ""){
            if(numberOfPeopleTextField.text != ""){
                totalAmountTextField.endEditing(true)
                numberOfPeopleTextField.endEditing(true)
                splitAmount = totalAmount/numberOfPeople
                var splitString = String(format: "$%.2f",splitAmount)
                splitAmountLabel.text = splitString
                eachPersonLabel.hidden = false
                splitAmountLabel.hidden = false
                addDebtButton.hidden = false
            }
        }
    }
    
    @IBAction func pressedReset(sender: AnyObject) {
        totalAmountTextField.text = ""
        numberOfPeopleTextField.text = ""
        totalAmountTextField.placeholder = "i.e. '22.74'"
        numberOfPeopleTextField.placeholder = "i.e. '4'"
        eachPersonLabel.hidden = true
        splitAmountLabel.hidden = true
        addDebtButton.hidden = true
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        totalAmountTextField.text = ""
        numberOfPeopleTextField.text = ""
        totalAmountTextField.placeholder = "i.e. '22.74'"
        numberOfPeopleTextField.placeholder = "i.e. '4'"
        eachPersonLabel.hidden = true
        splitAmountLabel.hidden = true
        addDebtButton.hidden = true

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == mainMenuSegueIdentifier){
            (segue.destinationViewController as ViewController).managedObjectContext = managedObjectContext
        }
    }
}
