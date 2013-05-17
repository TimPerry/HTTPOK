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

@interface HTOSiteList : NSWindowController <NSTableViewDelegate, NSTableViewDataSource, HTOURLCheckerDelegate> {

    NSMutableArray *_sites;
    
    HTOAddSite *_addSiteWindow;
    NSTableView *siteList;
}

@property (nonatomic) IBOutlet NSTableView *siteList;

-(void) checkURLs;

@end