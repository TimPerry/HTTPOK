//
//  main.m
//  HTTPOK
//
//  Created by Timmy on 14/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HTOAppDelegate.h"

int main(int argc, char *argv[])
{

    HTOAppDelegate *delegate = [[HTOAppDelegate alloc] init];
    [[NSApplication sharedApplication] setDelegate:delegate];
    [NSApp run];
    
}
