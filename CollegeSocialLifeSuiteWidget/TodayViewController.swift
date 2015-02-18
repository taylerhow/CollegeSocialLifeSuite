//
//  TodayViewController.swift
//  CollegeSocialLifeSuiteWidget
//
//  Created by Trevor Burch on 2/12/15.
//  Copyright (c) 2015 Tayler How. All rights reserved.
//

import Foundation
import NotificationCenter
import CoreData

class TodayViewController: UIViewController, NCWidgetProviding {
        
    override func viewDidLoad() {
        super.viewDidLoad()
//        NSNotificationCenter().addObserver(self) {
//            NSUserDefaultsDidChangeNotification object
//        }
        self.preferredContentSize = CGSizeMake(320, 80)
        // Do any additional setup after loading the view from its nib.
        decisionMakerButton.titleLabel?.textAlignment = NSTextAlignment.Center
        splitTheBillButton.titleLabel?.textAlignment = NSTextAlignment.Center
        debtTrackerButton.titleLabel?.textAlignment = NSTextAlignment.Center
    }
    
    
    @IBOutlet weak var decisionMakerButton: UIButton!
    @IBOutlet weak var debtTrackerButton: UIButton!
    @IBOutlet weak var splitTheBillButton: UIButton!
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func pressedDecisionMaker(sender: AnyObject) {
        let url: NSURL? = NSURL(string: "collegeHelp://Decision")
        
        if let appurl = url {
            self.extensionContext!.openURL(appurl,
                completionHandler: nil)
        }    }
    @IBAction func pressedDebtTracker(sender: AnyObject) {
        let url: NSURL? = NSURL(string: "collegeHelp://Debt")
        
        if let appurl = url {
            self.extensionContext!.openURL(appurl,
                completionHandler: nil)
        }
    }
    @IBAction func pressedSplitTheBill(sender: AnyObject) {
        let url: NSURL? = NSURL(string: "collegeHelp://Split")
        
        if let appurl = url {
            self.extensionContext!.openURL(appurl,
                completionHandler: nil)
        }
    }
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)!) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData

        completionHandler(NCUpdateResult.NewData)
    }

    
    func widgetMarginInsetsForProposedMarginInsets(defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        var Margin = UIEdgeInsets(top: defaultMarginInsets.top, left: defaultMarginInsets.left, bottom: 10 , right: defaultMarginInsets.right)
        return Margin
        
    }
    
}
