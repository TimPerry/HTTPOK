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

@interface HTOAddSite : NSWindowController {
    
    NSTextField *siteName;
    NSTextField *siteURL;
        
}
@property (nonatomic) IBOutlet NSTextField *siteName;
@property (nonatomic) IBOutlet NSTextField *siteURL;

-(IBAction) saveSite:(id)sender;

@end
