//
//  HTOAppDelegate.h
//  HTTPOK
//
//  Created by Timmy on 14/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTOSiteList.h"

@class HTOSiteList;
@interface HTOAppDelegate : NSObject <NSApplicationDelegate> {
    
    HTOSiteList *window;
    
}

@property(retain,nonatomic) HTOSiteList *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

- (IBAction) saveAction:(id)sender;

@end
