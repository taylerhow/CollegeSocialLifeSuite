//
//  DebtTrackerTableView.swift
//  CollegeSocialLifeSuite
//
//  Created by Tayler How on 2/13/15.
//  Copyright (c) 2015 Tayler How. All rights reserved.
//

import UIKit


class DebtTrackerTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var superVC : DebtTrackerViewController!
    var managedObjectContext : NSManagedObjectContext?
    var debtCount : Int {
        return fetchedResultsController.sections![0].numberOfObjects
    }
    
    let debtCellIdentifier = "DebtCell"
    let noDebtsCellIdentifier = "NoDebtsCell"
    let debtEntityName = "Debt"
    let detailDebtViewSegueIdentifier = "DetailDebtViewSegue"
    
    
    override func viewWillAppear(animated: Bool) {
        self.managedObjectContext = (self.parentViewController as DebtTrackerViewController).managedObjectContext        
    }
    func addNewDebt(name: NSString, debt: NSString, comment: NSString, owesMe: Bool){
        let newDebt = NSEntityDescription.insertNewObjectForEntityForName(self.debtEntityName, inManagedObjectContext: self.managedObjectContext!) as Debt
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
//        self.tableView.reloadData()
    }
    
    //---SEGUE HANDLING?-----------------------------------------------------------------
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == detailDebtViewSegueIdentifier {
            println("Showing detail view")
        }
    }
    
    
    //---TABLE VIEW HANDLING-------------------------------------------------------------

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return max(debtCount, 1)
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return debtCount > 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell
        if debtCount == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier(noDebtsCellIdentifier, forIndexPath: indexPath) as UITableViewCell
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier(debtCellIdentifier, forIndexPath: indexPath) as UITableViewCell
            let debt = getDebtAtIndexPath(indexPath)
            cell.textLabel?.text = debt.nameAndDebt
            cell.detailTextLabel?.text = debt.comment
        }
        return cell
    }
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
////        if debtCount != 0 {
//            println("You just pressed on \(getDebtAtIndexPath(indexPath).nameAndDebt)")
//            self.superVC.performSegueWithIdentifier(detailDebtViewSegueIdentifier, sender: self)
////        }
//    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        if debtCount == 0 {
            super.setEditing(false, animated: false)
//            self.tableView.setEditing(false, animated: false)
        } else {
            super.setEditing(editing, animated: animated)
//            self.tableView.setEditing(editing, animated: animated)
        }
    }

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let debtToDelete = getDebtAtIndexPath(indexPath)
            managedObjectContext?.deleteObject(debtToDelete)
            saveManagedObjectContext()
        }
        
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.reloadData();
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            if(debtCount==1){
                self.tableView.reloadData()
            } else {
                let indexPath = NSIndexPath(forRow: 0, inSection: 0)
                self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
            }
        case .Delete:
            if(debtCount==0){
                self.tableView.reloadData()
                super.setEditing(false, animated: true)
            } else {
                self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            }
        default:
            return
        }
    }
    
    //---CORE DATA-----------------------------------------------------------------------
    
    func getDebtAtIndexPath(indexPath: NSIndexPath) -> Debt {
        return fetchedResultsController.objectAtIndexPath(indexPath) as Debt
    }
    
    func saveManagedObjectContext() {
        var error : NSError?
        managedObjectContext?.save(&error)
        if(error != nil){
            println("Unresolved Core Data error \(error?.userInfo)")
            abort()
        }
    }
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest(entityName: debtEntityName)
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "lastModified", ascending: false)]
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 30
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "lastModified", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "DebtTrackerCache")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error : NSError?
        _fetchedResultsController!.performFetch(&error)
        if(error != nil){
            println("Unresolved Core Data error \(error?.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController? = nil
}
