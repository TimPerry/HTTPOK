//
//  HTOSiteList.m
//  HTTPOK
//
//  Created by Timmy on 15/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import "HTOSiteList.h"

@implementation HTOSiteList

@synthesize _siteList;

#define STATUS_OK 100
#define STATUS_FAILED 101

// =================
//  VIEW CONTROLLER
// =================

- (void) windowDidLoad {
    
    // init the url checker
    _urlChecker = [[HTOURLChecker alloc] init];
    _urlChecker.delegate = self;
    
    // set the delegates / datasource for the tableview
    [_siteList setDelegate: self];
    [_siteList setDataSource: self];
            
    // setup the site list
    [self setupSiteList];
        
    // check the urls on startup
    [self checkURLs];
        
    // check the urls every 60 seconds
    [NSTimer scheduledTimerWithTimeInterval:60.0 target:self selector:@selector(checkURLs) userInfo:nil repeats:YES];
    
    // load that window
    [super windowDidLoad];
    
}

// =========
//  TOOLBAR
// =========

-(BOOL) validateToolbarItem:(NSToolbarItem *) toolbarItem {
    
    BOOL enabled = true;
    if ([[toolbarItem itemIdentifier] isEqual:@"delete"]) {
        enabled = ([_siteList selectedRow] != -1 );
    }
    
    return enabled;
    
}

// =============
//  TABLE VIEWS
// =============

-(BOOL) setupSiteList {
    
    NSManagedObjectContext *context = [(HTOAppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Site" inManagedObjectContext: context];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setSortDescriptors:[ NSArray arrayWithObject: sortDescriptor]];

    [context processPendingChanges];
    
    NSError *error;
    _sites = [NSMutableArray arrayWithArray: [context executeFetchRequest:request error:&error]];
    
    [_siteList reloadData];
    
    return true;
    
}

- (NSInteger) numberOfRowsInTableView:(NSTableView *) tableView {
    return [_sites count];
}

- (id) tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
    
    Site *site = [_sites objectAtIndex:rowIndex];
    
    if ( [[tableColumn identifier] isEqualToString:@"status"]) {
        return ([[site status] intValue] == STATUS_OK ) ? [NSImage imageNamed:@"status_ok.png"] : [NSImage imageNamed:@"status_error.png"] ;
    } else if ( [[tableColumn identifier] isEqualToString:@"site_name"] ) {
        return [site name];
    } else if ( [[tableColumn identifier] isEqualToString:@"site_url"] ) {
        return [site url];
    }
    
    return nil;
    
}

// =============
//  URL CHECKER
// =============

-(void) checkURLs {
    
    for( Site *site in _sites ) {
        
        [_urlChecker setUrl: [site url]];
        [_urlChecker check];
        
    }

}

-(void) URLCheckedWithStatus:(NSInteger) http_status andURL:(NSString*) url {
    
    NSManagedObjectContext *context = [(HTOAppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
    
    for( Site *site in _sites ) {
        
        if ( [[site url] isEqualToString: url] ) {
         
            int status = ( http_status == 200 ) ? STATUS_OK : STATUS_FAILED;
            
            // failed, play sound, bring application to front and then open the url in the browser
            if ( status == STATUS_FAILED ) {
                [self notifyUserOfOffline: site];                
            }
            
            [site setStatus: [NSNumber numberWithInt:status]];
            
            [context processPendingChanges];
            
            NSError *error = nil;
            if([ context save:&error]){
                [_siteList reloadData];
            }
            
            break;
            
        }
        
    }
    
}

// =============
//  UI ACTIONS
// =============

-(IBAction) addSite:(id) sender {
    
    if ( ! _addSiteWindow ) {
        _addSiteWindow = [[HTOAddSite alloc] initWithWindowNibName:@"HTOAddSite"];
        _addSiteWindow.siteListWindow = self;
    }
    [_addSiteWindow showWindow: self];
    
}

-(IBAction) deleteSite:(id) sender {
    
    NSIndexSet *selected_rows = [_siteList selectedRowIndexes];
    NSManagedObjectContext *context = [(HTOAppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];

    // begin updates
    [_siteList beginUpdates];
    
    NSUInteger index = [selected_rows firstIndex];
    while ( index != NSNotFound ) {
            
        // get the selected row
        NSInteger total_sites = [_sites count];
        
        if ( index < total_sites) {
            
            // delete item
            [context deleteObject: [_sites objectAtIndex: index]];
            
            // save
            [context processPendingChanges];
            
            NSError *error = nil;
            if( [context save:&error] ) {
            
                // remove from array
                [_sites removeObjectAtIndex: index];
            
                // would like to just use selected_rows but we must check each removal indidivually incase of a core data error
                NSIndexSet *indexPaths = [NSIndexSet indexSetWithIndex: index];
                
                // remove row
                [_siteList removeRowsAtIndexes:indexPaths withAnimation:NSTableViewAnimationEffectFade];
                
            }
            
        }
         
        index = [selected_rows indexGreaterThanIndex: index];
         
    }
    
    [_siteList endUpdates];

}

-(void) notifyUserOfOffline:(Site*) site {
    
    // setup the notification
    NSUserNotification *notification = [[NSUserNotification alloc] init];
    notification.title = @"Site offline!";
    notification.informativeText = [NSString stringWithFormat:@"%@ is offline!", [site name]];
    notification.soundName = @"alert1.mp3";
    
    // show notification
    [[NSUserNotificationCenter defaultUserNotificationCenter] deliverNotification:notification];
    
    // open url and bring application to front
    [[NSApplication sharedApplication] activateIgnoringOtherApps : YES];
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString: [site url]]];

    
}

// ========================
//  NOTIFICATIONS DELEGATE
// ========================

- (BOOL) userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification {
    return YES;
}

@end