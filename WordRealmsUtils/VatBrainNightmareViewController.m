//
//  VatBrainNightmareViewController.m
//  WordRealmsUtils
//
//  Created by Dan Dela Rosa on 6/12/13.
//  Copyright (c) 2013 MRD Engineering. All rights reserved.
//

#import "VatBrainNightmareViewController.h"

@interface VatBrainNightmareViewController () <NSTableViewDataSource, NSTableViewDelegate>

@property (weak) IBOutlet NSMatrix *difficultyMatrix;
@property (weak) IBOutlet NSTextField *scrambledKeysTextField;
@property (weak) IBOutlet NSTextField *unscrambledKeysTextField;
@property (weak) IBOutlet NSTableView *wordsTableView;
@property (weak) IBOutlet NSTextField *guessTextField;
@property (weak) IBOutlet NSTextField *solutionTextField;

@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSMutableArray *words;

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
    NSControl *control = [notification object];
    if (control == self.scrambledKeysTextField) {
        [self unscrambleKeys];
    }
    else if (control == self.guessTextField) {
        [self scrambleGuess];
    }
}

- (IBAction)solveButtonPressed:(id)sender
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

- (void)findWordsForKeys:(NSString *)keys
{
    self.words = [NSMutableArray array];
    NSString *currentWord = @"";
    keys = [keys lowercaseString];
    [self findValidWordsFromCurrentWord:currentWord remainingLetters:keys];
    [self.wordsTableView reloadData];
}

- (void)findValidWordsFromCurrentWord:(NSString *)currentWord remainingLetters:(NSString *)remainingLetters
{
    // Check if current word is valid
    // TODO: optimize this! (takes too long!)
    if (currentWord.length > 4) {
        NSRange mispelledWordRange = [[NSSpellChecker sharedSpellChecker] checkSpellingOfString:currentWord startingAt:0];
        if (mispelledWordRange.location == NSNotFound) {
            [self.words addObject:currentWord];
        }
    }
    
    for (NSUInteger index = 0; index < remainingLetters.length; index++) {
        NSMutableString *newWord = [currentWord mutableCopy];
        NSMutableString *newRemainingLetters = [remainingLetters mutableCopy];
        NSRange rangeOfNewCharacter = NSMakeRange(index, 1);
        [newWord appendString:[newRemainingLetters substringWithRange:rangeOfNewCharacter]];
        [newRemainingLetters deleteCharactersInRange:rangeOfNewCharacter];
        [self findValidWordsFromCurrentWord:newWord remainingLetters:newRemainingLetters];
    }
}

- (void)scrambleGuess
{
    NSString *guess = [[self.guessTextField stringValue] uppercaseString];
    
    // Easy difficulty
    NSInteger advanceKeyAmount = -1;
    // Medium difficulty
    if (self.difficultyMatrix.selectedColumn == 1) {
        advanceKeyAmount = -3;
    }
    // Hard difficulty
    else if (self.difficultyMatrix.selectedColumn == 2) {
        advanceKeyAmount = -5;
    }
    
    NSMutableString *rescrambledKeys = [NSMutableString stringWithCapacity:guess.length];
    for (NSUInteger index = 0; index < guess.length; index++) {
        NSString *key = [guess substringWithRange:NSMakeRange(index, 1)];
        NSInteger indexOfKey = [self.letters indexOfObject:key];
        NSInteger scrambledIndex = indexOfKey + advanceKeyAmount;
        // Key indices loop
        if (scrambledIndex < 0) {
            scrambledIndex += self.letters.count;
        }
        NSString *scrambledKey = self.letters[scrambledIndex];
        [rescrambledKeys appendString:scrambledKey];
    }
    
    [self.solutionTextField setStringValue:rescrambledKeys];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView
{
    return self.words.count;
}

- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row
{
    return [self.words objectAtIndex:row];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification
{
    NSUInteger selectedRow = self.wordsTableView.selectedRow;
    NSString *selectedWord = [self.words objectAtIndex:selectedRow];
    selectedWord = [selectedWord uppercaseString];
    
    // Easy difficulty
    NSInteger advanceKeyAmount = -1;
    // Medium difficulty
    if (self.difficultyMatrix.selectedColumn == 1) {
        advanceKeyAmount = -3;
    }
    // Hard difficulty
    else if (self.difficultyMatrix.selectedColumn == 2) {
        advanceKeyAmount = -5;
    }
    
    NSMutableString *rescrambledKeys = [NSMutableString stringWithCapacity:selectedWord.length];
    for (NSUInteger index = 0; index < selectedWord.length; index++) {
        NSString *key = [selectedWord substringWithRange:NSMakeRange(index, 1)];
        NSInteger indexOfKey = [self.letters indexOfObject:key];
        NSInteger unscrambledIndex = indexOfKey + advanceKeyAmount;
        // Key indices loop
        if (unscrambledIndex < 0) {
            unscrambledIndex += self.letters.count;
        }
        NSString *unscrambledKey = self.letters[unscrambledIndex];
        [rescrambledKeys appendString:unscrambledKey];
    }
    
    [self.solutionTextField setStringValue:rescrambledKeys];
}


@end
