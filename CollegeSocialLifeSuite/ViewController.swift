//
//  ViewController.swift
//  CollegeSocialLifeSuite
//
//  Created by Tayler How & Trevor Burch on 1/31/15.
//  Copyright (c) 2015 Tayler How. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController{
    
    var sharedDefaults = NSUserDefaults(suiteName: "group.edu.rosehulman.collegesuite")
    
    var managedObjectContext : NSManagedObjectContext?
    
    let decisionMakerSegueIdentifier = "DecisionMakerSegue"
    let splitTheBillSegueIdentifier = "SplitTheBillSegue"
    let debtTrackerSegueIdentifier = "DebtTrackerSegue"

    override func viewDidLoad() {
        super.viewDidLoad()
        sharedDefaults?.synchronize()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
        if(segue.identifier == decisionMakerSegueIdentifier){
            (segue.destinationViewController as DeciderViewController).managedObjectContext = managedObjectContext
        }
        else if(segue.identifier == debtTrackerSegueIdentifier){
            (segue.destinationViewController as DebtTrackerViewController).managedObjectContext = managedObjectContext
        } else if(segue.identifier == splitTheBillSegueIdentifier){
            (segue.destinationViewController as SplitTheBillViewController).managedObjectContext = managedObjectContext
        }
    }

}

