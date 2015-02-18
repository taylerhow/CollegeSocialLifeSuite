//
//  Debt.h
//  CollegeSocialLifeSuite
//
//  Created by Tayler How on 2/13/15.
//  Copyright (c) 2015 Tayler How. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Debt : NSManagedObject

@property (nonatomic, retain) NSDate * lastModified;
@property (nonatomic, retain) NSString * comment;
@property (nonatomic, retain) NSString * nameAndDebt;

@end
