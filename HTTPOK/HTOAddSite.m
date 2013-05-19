//
//  HTOAddSite.m
//  HTTPOK
//
//  Created by Timmy on 15/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import "HTOAddSite.h"

@implementation HTOAddSite

@synthesize siteName, siteURL, siteListWindow;

-(IBAction) saveSite:(id)sender {
    
    if ( [[siteName stringValue] length] > 0 && [[siteURL stringValue] length] > 0 ) {
    
        HTOAppDelegate *delegate = (HTOAppDelegate*)[[NSApplication sharedApplication] delegate];
        NSManagedObjectContext *context = [delegate managedObjectContext];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Site" inManagedObjectContext: context];
        
        Site *newSite = [[Site alloc] initWithEntity:entity insertIntoManagedObjectContext: context];
        
        NSString *url = [siteURL stringValue];

        if ( [url rangeOfString:@"http"].location == NSNotFound ) {
            url = [NSString stringWithFormat:@"http://%@", url];
        }
        
        [newSite setUrl: url];
        [newSite setName:[siteName stringValue]];

        [context processPendingChanges];
        
        NSError *error = nil;
        if([ context save:&error]){
            
            if ( [[self siteListWindow] setupSiteList] ) {

                [[self siteName] setStringValue:@""];
                [[self siteURL] setStringValue:@""];
                
                [[self siteURL] resignFirstResponder];
                [[self window] setInitialFirstResponder: [self siteName]];
                
                [[self window] close];
                
            }
            
        } else {
            
            NSAlert *alert = [NSAlert alertWithMessageText:@"Oh noes!"
                                             defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat: @"Failed to add the site, please try again. If problem persists, please report."];
            
            [alert runModal];
            
        }
        
    } else {
        
        NSAlert *alert = [NSAlert alertWithMessageText:@"Oh noes!"
                                         defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat: @"Please enter both a url and name for the site."];
        
        [alert runModal];
        
    }
    
}

@end