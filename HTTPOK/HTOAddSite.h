//
//  HTOAddSite.h
//  HTTPOK
//
//  Created by Timmy on 15/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Site.h"
#import "HTOAppDelegate.h"

@class HTOSiteList;
@interface HTOAddSite : NSWindowController {
    
    NSTextField *siteName;
    NSTextField *siteURL;
    
    HTOSiteList *siteListWindow;
        
}

@property (retain, nonatomic) HTOSiteList *siteListWindow;
@property (retain, nonatomic) IBOutlet NSTextField *siteName;
@property (retain, nonatomic) IBOutlet NSTextField *siteURL;

-(IBAction) saveSite:(id)sender;

@end