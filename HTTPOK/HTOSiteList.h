//
//  HTOSiteList.h
//  HTTPOK
//
//  Created by Timmy on 15/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTOURLChecker.h"
#import "HTOAppDelegate.h"
#import "HTOAddSite.h"

@class HTOAddSite;
@interface HTOSiteList : NSWindowController <NSTableViewDelegate, NSTableViewDataSource, NSToolbarDelegate, NSUserNotificationCenterDelegate, HTOURLCheckerDelegate> {

    // Data vars
    NSMutableArray *_sites;
    HTOURLChecker *_urlChecker;

    // IBOutlets
    HTOAddSite *_addSiteWindow;
    NSTableView *_siteList;

}

@property (retain,nonatomic) IBOutlet NSTableView *_siteList;

-(void) checkURLs;
-(BOOL) setupSiteList;
-(void) notifyUserOfOffline:(Site*) site;

-(IBAction) addSite:(id)sender;
-(IBAction) deleteSite:(id)sender;

@end