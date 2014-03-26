//
//  AppDelegate.h
//  FiioE10Fixer
//
//  Created by Dani on 23/03/14.
//  Copyright (c) 2014 Daniel D'Abate. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

-(BOOL) isAppInLogin;
-(void) addToLogin;
-(void) deleteFromLogin;

@end
