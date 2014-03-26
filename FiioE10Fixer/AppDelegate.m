//
//  AppDelegate.m
//  FiioE10Fixer
//
//  Created by Dani on 23/03/14.
//  Copyright (c) 2014 Daniel D'Abate. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

-(BOOL) isAppInLogin
{
    BOOL isAppInLogin = NO;
    
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
    
	// This will retrieve the path for the application
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
    
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
	if (loginItems)
    {
		UInt32 seedValue;
        
		//Retrieve the list of Login Items and cast them to a NSArray so that it will be easier to iterate.
		NSArray * loginItemsArray = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);
        
		for(int i = 0; i < [loginItemsArray count]; i++)
        {
			LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)[loginItemsArray objectAtIndex:i];
            
			//Resolve the item with URL
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr)
            {
				NSString * urlPath = [(__bridge NSURL*)url path];
                
                if ([urlPath isEqualToString:appPath])
                    isAppInLogin = YES;
			}
		}
        
        CFRelease(loginItems);
	}
    
    return isAppInLogin;
}

-(void) addToLogin
{
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
    
	// This will retrieve the path for the application
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
    
	// Create a reference to the shared file list (we are adding it to the current user only)
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
    NSDictionary *properties = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:@"com.apple.loginitem.HideOnLaunch"];
    
	if (loginItems)
    {
		//Insert an item to the list.
		LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems,
                                                                     kLSSharedFileListItemLast, NULL, NULL,
                                                                     url, (__bridge CFDictionaryRef)(properties), NULL);
        
		if (item)
			CFRelease(item);
        
        CFRelease(loginItems);
	}
}

-(void) deleteFromLogin
{
	NSString * appPath = [[NSBundle mainBundle] bundlePath];
    
	// This will retrieve the path for the application
	CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
    
	// Create a reference to the shared file list.
	LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    
	if (loginItems)
    {
		UInt32 seedValue;
        
		//Retrieve the list of Login Items and cast them to a NSArray so that it will be easier to iterate.
		NSArray * loginItemsArray = (__bridge NSArray *)LSSharedFileListCopySnapshot(loginItems, &seedValue);

		for(int i = 0; i < [loginItemsArray count]; i++)
        {
			LSSharedFileListItemRef itemRef = (__bridge LSSharedFileListItemRef)[loginItemsArray objectAtIndex:i];
            
			//Resolve the item with URL
			if (LSSharedFileListItemResolve(itemRef, 0, (CFURLRef*) &url, NULL) == noErr)
            {
				NSString * urlPath = [(__bridge NSURL*)url path];
                
				if ([urlPath isEqualToString:appPath])
					LSSharedFileListItemRemove(loginItems,itemRef);
			}
		}
        
        CFRelease(loginItems);
	}
}

@end