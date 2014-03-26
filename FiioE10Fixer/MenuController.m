//
//  MainController.m
//  FiioE10Fixer
//
//  Created by Dani on 23/03/14.
//  Copyright (c) 2014 Daniel D'Abate. All rights reserved.
//

#import "MenuController.h"
#import "AppDelegate.h"

@interface MenuController ()

@property (strong) AVAudioPlayer * player;
@property (strong) NSStatusItem * statusItem;

@property (unsafe_unretained) IBOutlet NSMenu * statusMenu;

@end

@implementation MenuController

- (void)awakeFromNib
{
    // Start the player
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"silence" withExtension:@"wav"] error:nil];
    self.player.numberOfLoops = -1;
    
    // Set status item and menu
    self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength: NSVariableStatusItemLength];
    
    [self.statusItem setHighlightMode:NO];
    
    [self.statusItem setEnabled:YES];
    [self.statusItem setToolTip:@"Fiio E10 Fixer"];

    self.statusItem.menu = self.statusMenu;
    
    AppDelegate * appDelegate = [NSApplication sharedApplication].delegate;
    [self.statusMenu.itemArray[2] setState: appDelegate.isAppInLogin ? NSOnState : NSOffState];
    
    // Start playing silence
    [self togglePlay:self];
    
    // Ask to run at login on the first run
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:@"ranBefore"])
    {
        [defaults setBool:YES forKey:@"ranBefore"];
        
        if (!appDelegate.isAppInLogin)
        {
            NSAlert *alert = [NSAlert alertWithMessageText:@"Do you want FiioE10Fixer to run automatically on login?" defaultButton:@"Yes" alternateButton:@"No, thanks" otherButton:nil informativeTextWithFormat:@""];
            
            [alert beginSheetModalForWindow:nil modalDelegate:self didEndSelector:@selector(alertDidEnd:returnCode:contextInfo:) contextInfo:"runAtLoginAlert"];
        }
    }
}

- (void) alertDidEnd:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo
{
    if (returnCode == 1)
    {
        [self toggleRunAtLogin:self];
    }
}

- (IBAction)togglePlay:(id)sender
{
    if(self.player.isPlaying)
    {
        [self.player stop];
        
        self.statusItem.title = [NSString stringWithFormat:@"%C", 0x2573];
        [self.statusMenu.itemArray[0] setTitle: @"Activate"];
    }
    else
    {
        [self.player play];
        
        self.statusItem.title = [NSString stringWithFormat:@"%C", 0x266B];
        [self.statusMenu.itemArray[0] setTitle: @"Deactivate"];
    }
}

- (IBAction)toggleRunAtLogin:(id)sender
{
    AppDelegate * appDelegate = [NSApplication sharedApplication].delegate;
    
    if (appDelegate.isAppInLogin)
    {
        [appDelegate deleteFromLogin];
        [self.statusMenu.itemArray[2] setState:NSOffState];
    }
    else
    {
        [appDelegate addToLogin];
        [self.statusMenu.itemArray[2] setState:NSOnState];
    }
}

- (IBAction)showAbout:(id)sender
{
    [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
    [[NSApplication sharedApplication] orderFrontStandardAboutPanel:self];
}

@end