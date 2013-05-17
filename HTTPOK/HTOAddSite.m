//
//  HTOAddSite.m
//  HTTPOK
//
//  Created by Timmy on 15/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import "HTOAddSite.h"

@implementation HTOAddSite

@synthesize siteName, siteURL;

- (id)initWithWindow:(NSWindow *)window {

    self = [super initWithWindow:window];
    return self;
    
}

- (void)windowDidLoad {
    [super windowDidLoad];
}

-(IBAction) saveSite:(id)sender {
    
    if ( [[siteName stringValue] length] > 0 && [[siteURL stringValue] length] > 0 ) {
    
        NSManagedObjectContext *context = [(HTOAppDelegate *)[[NSApplication sharedApplication] delegate] managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Site" inManagedObjectContext: context];
        
        Site *newSite = [[Site alloc] initWithEntity:entity insertIntoManagedObjectContext: context];
        
        [newSite setName:[siteName stringValue]];
        [newSite setUrl:[siteURL stringValue]];
        
        [context processPendingChanges];
        
        NSError *error = nil;
        if(![ context save:&error]){
            //Handle error
        }
        
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        NSArray *array = [context executeFetchRequest:request error:&error];
        
        for( Site *site in array ) {
            NSLog(@"Sitename: %@", [site name]);
        }
        
    } else {
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Oh noes!"
                                         defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat: @"Please enter both a url and name for the site."];
        
        [alert runModal];
        
    }
    
}

@end
