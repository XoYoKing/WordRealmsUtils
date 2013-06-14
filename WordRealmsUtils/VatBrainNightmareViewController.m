//
//  VatBrainNightmareViewController.m
//  WordRealmsUtils
//
//  Created by Dan Dela Rosa on 6/12/13.
//  Copyright (c) 2013 MRD Engineering. All rights reserved.
//

#import "VatBrainNightmareViewController.h"

@interface VatBrainNightmareViewController ()

@property (weak) IBOutlet NSMatrix *difficultyMatrix;
@property (weak) IBOutlet NSTextField *scrambledKeysTextField;
@property (weak) IBOutlet NSTextField *unscrambledKeysTextField;

@property (nonatomic, strong) NSArray *letters;

@end

@implementation VatBrainNightmareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        self.letters = @[ @"A", @"B", @"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z" ];
    }
    
    return self;
}

- (IBAction)difficultyChanged:(id)sender
{
    [self unscrambleKeys];
}

- (void)controlTextDidChange:(NSNotification *)notification
{
    [self unscrambleKeys];
}

- (void)unscrambleKeys
{
    NSString *scrambledKeys = [[self.scrambledKeysTextField stringValue] uppercaseString];
    
    // Easy difficulty
    NSInteger advanceKeyAmount = 1;
    // Medium difficulty
    if (self.difficultyMatrix.selectedColumn == 1) {
        advanceKeyAmount = 3;
    }
    // Hard difficulty
    else if (self.difficultyMatrix.selectedColumn == 2) {
        advanceKeyAmount = 5;
    }
    
    NSMutableString *unscrambledKeys = [NSMutableString stringWithCapacity:scrambledKeys.length];
    for (NSUInteger index = 0; index < scrambledKeys.length; index++) {
        NSString *key = [scrambledKeys substringWithRange:NSMakeRange(index, 1)];
        NSInteger indexOfKey = [self.letters indexOfObject:key];
        NSInteger unscrambledIndex = indexOfKey + advanceKeyAmount;
        // Key indices loop
        if (unscrambledIndex >= self.letters.count) {
            unscrambledIndex -= self.letters.count;
        }
        NSString *unscrambledKey = self.letters[unscrambledIndex];
        [unscrambledKeys appendString:unscrambledKey];
    }
    
    [self.unscrambledKeysTextField setStringValue:unscrambledKeys];
}


@end
