//
//  BA_MarkableCollectionViewCell.m
//  InspectTHIS
//
//  Created by Baris Atamer on 29/12/15.
//  Copyright © 2015 Avandel, Inc. All rights reserved.
//

#import "BA_MarkableCollectionViewCell.h"
#import "CheckMarkView.h"

@implementation BA_MarkableCollectionViewCell
{
    BOOL _isChecked;
    CheckMarkView *_checkMarkView;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        [self _initialize];
    }
    
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self _initialize];
    }
    return self;
}

- (void) _initialize
{
    // Create a checkmark
    CGRect rect = self.frame;
    float width = 40;
    float height = 40;
    
    // Init checkmark
    _checkMarkView = [[CheckMarkView alloc] initWithFrame:CGRectMake(rect.size.width  - width  * 1.1f,
                                                                     rect.size.height - height * 1.5f,
                                                                     width,
                                                                     height)];
    _checkMarkView.hidden = YES;
    [self addSubview:_checkMarkView];
    
}

/**
 * Show a checkmark on right-down side of the CollectionViewCell.
 *
 * @param checked Checked value.
 * @return void
 */
- (void) setChecked:(BOOL) checked
{
    _isChecked = checked;
    [_checkMarkView setChecked:checked];
}

/**
 * Sets the selection mode enabled.
 * (Draws empty circles on bottom of the Cells)
 *
 * @param enabled If enabled, enters selection mode.
 * @return void
 */
- (void) setSelectionEnabled:(BOOL) enabled
{
    _checkMarkView.hidden = !enabled;
    
    // Reset checkview
    [_checkMarkView setChecked:NO];
    _isChecked = NO;
}

- (BOOL) isChecked
{
    return _isChecked;
}

@end
