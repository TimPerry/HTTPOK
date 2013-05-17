//
//  HTOSiteList.m
//  HTTPOK
//
//  Created by Timmy on 15/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import "HTOSiteList.h"

@implementation HTOSiteList

@synthesize siteList;

// =================
//  VIEW CONTROLLER
// =================

- (id)initWithWindow:(NSWindow *)window {
    
    self = [super initWithWindow:window];
    return self;
    
}

- (void)windowDidLoad {
    
    NSManagedObjectContext *context = [(HTOAppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Site" inManagedObjectContext: context];
    
    NSError *error = nil;
    if(![ context save:&error]){
        //Handle error
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    
    _sites = [NSMutableArray arrayWithArray: [context executeFetchRequest:request error:&error]];
    
    [siteList setDelegate: self];
    [siteList setDataSource: self];
    
    [super windowDidLoad];
    
    // every 60 seconds check the urls
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(checkURLs) userInfo:nil repeats:YES];
    
}

// =============
//  TABLE VIEWS
// =============

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [_sites count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)rowIndex {
    
    Site *site = [_sites objectAtIndex:rowIndex];
    
    if ( [[tableColumn identifier] isEqualToString:@"status"]) {
        return [NSImage imageNamed:@"add.png"];
    } else if ( [[tableColumn identifier] isEqualToString:@"next_check"] ) {
        return @"4mins 20secs";
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
    
    HTOURLChecker *urlChecker = [[HTOURLChecker alloc] init];
    
    for( Site *site in _sites ) {
        
        [urlChecker setUrl: [site url]];
        [urlChecker check];
        
    }

}

-(void) URLCheckedWithStatus: (NSInteger) http_status andURL: (NSString*) url {
    
    NSLog( @"Status code: %ld and url: %@", (long)http_status, url );
    
}

// =============
//  UI ACTIONS
// =============

- (IBAction) addSite:(id)sender {
    
    if ( ! _addSiteWindow ) {
        _addSiteWindow = [[HTOAddSite alloc] initWithWindowNibName:@"HTOAddSite"];
    }
    [_addSiteWindow showWindow: self];
    
}

@end
