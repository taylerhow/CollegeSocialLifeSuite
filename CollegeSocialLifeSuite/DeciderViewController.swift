//
//  DeciderViewController.swift
//  CollegeSocialLifeSuite
//
//  Created by Trevor Burch & Tayler How on 2/4/15.
//  Copyright (c) 2015 Tayler How. All rights reserved.
//

import UIKit
import CoreData

class DeciderViewController: UIViewController, NSFetchedResultsControllerDelegate {

    var managedObjectContext : NSManagedObjectContext?
    
    let mainMenuSegueIdentifier = "MainMenuSegue"
    
    var options = ["","","","",""]
    var optionCount = 0
    var arraysRecieved : [NSData] = []
    var arrays : [[String]] = []
    var optionsPicker : ActionSheetStringPicker = ActionSheetStringPicker()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboards")
        tapRecognizer.numberOfTapsRequired = 1
        self.view.addGestureRecognizer(tapRecognizer)
        
    }
    
    func dismissKeyboards(){
        option1TextField.endEditing(true)
        option2TextField.endEditing(true)
        option3TextField.endEditing(true)
        option4TextField.endEditing(true)
        option5TextField.endEditing(true)
    }
    
    @IBOutlet weak var option1TextField: UITextField!
    @IBOutlet weak var option2TextField: UITextField!
    @IBOutlet weak var option3TextField: UITextField!
    @IBOutlet weak var option4TextField: UITextField!
    @IBOutlet weak var option5TextField: UITextField!
    @IBOutlet weak var howAboutLabel: UILabel!
    @IBOutlet weak var decisionLabel: UILabel!
    @IBAction func option1Edited(sender: AnyObject) {
        if(options[0] != ""){
            optionCount -= 1
        }
        options[0] = option1TextField.text
        if(options[0] != ""){
            optionCount += 1
        }
    }
    @IBAction func option2Edited(sender: AnyObject) {
        if(options[1] != ""){
            optionCount -= 1
        }
        options[1] = option2TextField.text
        if(options[1] != ""){
            optionCount += 1
        }
    }
    @IBAction func option3Edited(sender: AnyObject) {
        if(options[2] != ""){
            optionCount -= 1
        }
        options[2] = option3TextField.text
        if(options[2] != ""){
            optionCount += 1
        }
    }
    @IBAction func option4Edited(sender: AnyObject) {
        if(options[3] != ""){
            optionCount -= 1
        }
        options[3] = option4TextField.text
        if(options[3] != ""){
            optionCount += 1
        }
    }
    @IBAction func option5Edited(sender: AnyObject) {
        if(options[4] != ""){
            optionCount -= 1
        }
        options[4] = option5TextField.text
        if(options[4] != ""){
            optionCount += 1
        }
    }
    @IBAction func pressedSave(sender: AnyObject) {
        dismissKeyboards()
        showSaveDialog()
    }
    @IBAction func pressedLoad(sender: AnyObject) {
        dismissKeyboards()
        
        
        arraysRecieved = []
        var fetchRequest = NSFetchRequest(entityName: "Decision")
//        NSEntityDescription *entity = [NSEntityDescription entityForName:@"MyEntity" inManagedObjectContext:self.managedObjectContext];
        
        // Required! Unless you set the resultType to NSDictionaryResultType, distinct can't work.
        // All objects in the backing store are implicitly distinct, but two dictionaries can be duplicates.
        // Since you only want distinct names, only ask for the 'name' property
        var optionsRecieved : [String] = []
        fetchRequest.propertiesToFetch = NSArray(object: "title")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.returnsDistinctResults = true
        var resultRecieved:NSArray = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil)!
//        if resultRecieved != nil{
        for result in resultRecieved{
            var thisResult = result as Decision
            optionsRecieved.append(thisResult.title)
        }
        var fetchRequest2 = NSFetchRequest(entityName: "Decision")
        fetchRequest2.propertiesToFetch = NSArray(object: "array")
        fetchRequest2.returnsObjectsAsFaults = false
        fetchRequest2.returnsDistinctResults = true
        var dataResultRecieved:NSArray = self.managedObjectContext!.executeFetchRequest(fetchRequest2, error: nil)!
        for result in dataResultRecieved{
            var thisResult = result as Decision
            arraysRecieved.append(thisResult.array)
        }
        arrays = []
        var i = 0
        while(i<arraysRecieved.count){
            arrays.append(NSKeyedUnarchiver.unarchiveObjectWithData(self.arraysRecieved[i]) as [String])
            i++
        }
//        let done: ActionStringDoneBlock = {(picker: ActionSheetStringPicker!, selectedIndex: NSInteger!, selectedValue : AnyObject!) in
//            println("Success")
//            var selectedArray = self.arrays[0]
//            for i in 0...4{
//                self.options[i] = selectedArray[i]
//            }
//            
//        }
        optionsPicker = ActionSheetStringPicker(title: "Choose a set of options", rows: optionsRecieved, initialSelection: 0, target: self, successAction : "fillOptionsLoaded", cancelAction: nil, origin: sender.superview!) as ActionSheetStringPicker
            optionsPicker.showActionSheetPicker()///}
    }
//    func pickerDone()
//    {
//        println("Here I am!")
//    }
//    
//    @IBAction func functionInvokeByDoneCicked(sender: UIButton) {
//        var picker = ActionSheetStringPicker(title: "title", rows: ["1","2"], initialSelection: 0, target: self, successAction: "pickerDone", cancelAction: nil, origin: sender.superview!.superview)
//        
//        picker.showActionSheetPicker()
//    }
    
    func fillOptionsLoaded(){
        if(!self.arrays.isEmpty){
        var selectedArray = self.arrays[optionsPicker.getIndex()]
        for i in 0...4{
            self.options[i] = selectedArray[i]
        }
        optionCount = 0
        if(options[0] != ""){
            optionCount += 1
        }
        if(options[1] != ""){
            optionCount += 1
        }
        if(options[2] != ""){
            optionCount += 1
        }
        if(options[3] != ""){
            optionCount += 1
        }
        if(options[4] != ""){
            optionCount += 1
        }
        option1TextField.text = options[0]
        option2TextField.text = options[1]
        option3TextField.text = options[2]
        option4TextField.text = options[3]
        option5TextField.text = options[4]}
        
    }
    @IBAction func pressedReset(sender: AnyObject) {
        option1TextField.endEditing(true)
        option2TextField.endEditing(true)
        option3TextField.endEditing(true)
        option4TextField.endEditing(true)
        option5TextField.endEditing(true)
        option1TextField.text = ""
        option2TextField.text = ""
        option3TextField.text = ""
        option4TextField.text = ""
        option5TextField.text = ""
        for i in 0...4{
            options[i] = ""
        }
        optionCount = 0
        decisionLabel.hidden = true
        howAboutLabel.hidden = true
    }
    
    func showSaveDialog(){
        let alertController = UIAlertController(title: "Save your options", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Title"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) { (action) -> Void in
        }
        let saveOptionsAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.Default) { (action) -> Void in
            let titleTextField = alertController.textFields![0] as UITextField
            let newSavedSet = NSEntityDescription.insertNewObjectForEntityForName("Decision",inManagedObjectContext: self.managedObjectContext!) as Decision
            newSavedSet.title = (alertController.textFields![0] as UITextField).text
            var arrayData = NSKeyedArchiver.archivedDataWithRootObject(self.options)
            newSavedSet.array = arrayData
            var error : NSError? = nil
            self.managedObjectContext!.save(&error)
            if error != nil {
                println("Unresolved Core Data error \(error?.userInfo)")
                abort()
            }
        }
        
        
        alertController.addAction(cancelAction)
        alertController.addAction(saveOptionsAction)
        presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    @IBAction func pressedDecide(sender: AnyObject) {
        option1TextField.endEditing(true)
        option2TextField.endEditing(true)
        option3TextField.endEditing(true)
        option4TextField.endEditing(true)
        option5TextField.endEditing(true)
        if(optionCount != 0){
            var result = ""
            while(result == ""){
                var random = Int(arc4random_uniform(UInt32(5)))
                result = options[random]
            }
            decisionLabel.text = result + "!"
            decisionLabel.hidden = false
            howAboutLabel.hidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        decisionLabel.hidden = true
        howAboutLabel.hidden = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var fetchedResultsController: NSFetchedResultsController {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest = NSFetchRequest(entityName: "Decision")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: false)]
        fetchRequest.fetchBatchSize = 20
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectContext!, sectionNameKeyPath: nil, cacheName: "DeciderCache")
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        var error: NSError? = nil
        _fetchedResultsController!.performFetch(&error)
        if error != nil{
            println("Unresolved Core Data error \(error?.userInfo)")
            abort()
        }
        
        return _fetchedResultsController!
    }
    var _fetchedResultsController :NSFetchedResultsController? = nil
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        default:
            return
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if(segue.identifier == mainMenuSegueIdentifier){
            (segue.destinationViewController as ViewController).managedObjectContext = managedObjectContext
        }
    }


}
