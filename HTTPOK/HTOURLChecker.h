//
//  HTOURLChecker.h
//  HTTPOK
//
//  Created by Timmy on 15/05/2013.
//  Copyright (c) 2013 Applicious. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTOURLCheckerDelegate <NSObject>
-(void) URLCheckedWithStatus: (NSInteger) http_status andURL: (NSString*) url;
@end

@interface HTOURLChecker : NSObject <NSURLConnectionDelegate> {
    
    NSString *url;
    NSMutableData *_receivedData;
    
}

@property (nonatomic, weak) id <HTOURLCheckerDelegate> delegate;
@property (nonatomic) NSString *url;

-(void)check;
-(id)initWithURL:(NSString*) url;

-(id)init;

@end
