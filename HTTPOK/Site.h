//
//  Site.h
//  HTTPOK
//
//  Created by Timmy on 16/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Site : NSManagedObject

@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * next_check;
@property (nonatomic, retain) NSNumber * active;
@property (nonatomic, retain) NSNumber * status;

@end
