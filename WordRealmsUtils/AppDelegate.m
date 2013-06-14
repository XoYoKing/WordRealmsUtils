//
//  AppDelegate.m
//  WordRealmsUtils
//
//  Created by Dan Dela Rosa on 6/12/13.
//  Copyright (c) 2013 MRD Engineering. All rights reserved.
//

#import "AppDelegate.h"
#import "VatBrainNightmareViewController.h"

@interface AppDelegate ()

@property (nonatomic, strong) IBOutlet VatBrainNightmareViewController *vatBrainNightmareViewController;

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    self.vatBrainNightmareViewController = [[VatBrainNightmareViewController alloc] initWithNibName:@"VatBrainNightmareViewController" bundle:nil];
    [self.window.contentView addSubview:self.vatBrainNightmareViewController.view];
}

@end
