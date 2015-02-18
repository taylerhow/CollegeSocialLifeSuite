//
//  Decision.h
//  CollegeSocialLifeSuite
//
//  Created by Trevor Burch on 2/11/15.
//  Copyright (c) 2015 Tayler How. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Decision : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSData * array;

@end
