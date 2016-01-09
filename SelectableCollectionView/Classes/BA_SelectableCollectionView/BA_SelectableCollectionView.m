//
//  BA_SelectableCollectionView.m
//  SelectableCollectionView
//
//  Created by Baris Atamer on 1/8/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import "BA_SelectableCollectionView.h"
#import "BA_MarkableCollectionViewCell.h"

#import <objc/runtime.h>

static BOOL protocol_containsSelector(Protocol *protocol, SEL selector)
{
    return protocol_getMethodDescription(protocol, selector, YES, YES).name != NULL || protocol_getMethodDescription(protocol, selector, NO, YES).name != NULL;
}

@implementation BA_SelectableCollectionView
{
    BOOL _isSelectionModeEnabled;
    NSMutableArray *_selectedItems; // Keep all the selected items in a mutable array
    
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (protocol_containsSelector(@protocol(UICollectionViewDataSource), aSelector)) {
        return [super respondsToSelector:aSelector] || [_selectableDataSource respondsToSelector:aSelector];
    } else if (protocol_containsSelector(@protocol(UICollectionViewDelegate), aSelector)) {
        return [super respondsToSelector:aSelector] || [_selectableDelegate respondsToSelector:aSelector];
    }
    
    return [super respondsToSelector:aSelector];
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if (protocol_containsSelector(@protocol(UICollectionViewDataSource), aSelector)) {
        return _selectableDataSource;
    } else if (protocol_containsSelector(@protocol(UICollectionViewDelegate), aSelector)) {
        return _selectableDelegate;
    }
    
    return [super forwardingTargetForSelector:aSelector];
}

#pragma mark - Initialization
-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self _initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        [self _initialize];
    }
    return self;
}


- (void) _initialize{
    _selectedItems = [[NSMutableArray alloc] init];

    // Attach long press gesture to collectionView
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.delegate = self;
    lpgr.delaysTouchesBegan = NO;
    [self addGestureRecognizer:lpgr];

}

- (id<UICollectionViewDelegate>)delegate {
    return [super delegate];
}

- (void)setDelegate:(id<BA_SelectableCollectionViewDelegate>)delegate {
    _selectableDelegate = delegate;
    [super setDelegate:self];
}

- (id<UICollectionViewDataSource>)dataSource {
    return [super dataSource];
}

- (void)setDataSource:(id<BA_SelectableCollectionViewDataSource>)dataSource {
    _selectableDataSource = dataSource;
    [super setDataSource:self];
}

#pragma mark - Delegates
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    // Selection
    if (_isSelectionModeEnabled) {
        
        BA_MarkableCollectionViewCell *fileCell = (BA_MarkableCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
        
        if ([fileCell isChecked]) {
            [_selectedItems removeObject:indexPath];
        }
        else{
            [_selectedItems addObject:indexPath];
        }
        
        // Switch check icon
        [fileCell setChecked:![fileCell isChecked]];
        
        [self selectionChanged];
        
        return;
    }
    
    [self.selectableDelegate collectionView:collectionView didSelectItemAtIndexPath:indexPath];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BA_MarkableCollectionViewCell *cell = (BA_MarkableCollectionViewCell*) [self.selectableDataSource collectionView:cv cellForItemAtIndexPath:indexPath];

    // Selection handling
    [cell setSelectionEnabled:_isSelectionModeEnabled];
    if(_selectedItems != nil && [_selectedItems containsObject:indexPath] ){
        [cell setChecked:YES];
    }
    else{
        [cell setChecked:NO];
    }
    
    return cell;
}

#pragma - Data Source
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.selectableDataSource collectionView:collectionView numberOfItemsInSection:section];
}

- (void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!_isSelectionModeEnabled) return;
    
    BA_MarkableCollectionViewCell *cell = (BA_MarkableCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.3f animations:^{
        
        cell.transform = CGAffineTransformMakeScale(0.9f, 0.9f);
        
    } completion:^(BOOL finished) {
    }];
}

- (void) collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if(!_isSelectionModeEnabled) return;
    
    BA_MarkableCollectionViewCell *cell = (BA_MarkableCollectionViewCell*) [collectionView cellForItemAtIndexPath:indexPath];
    [UIView animateWithDuration:0.5f animations:^{
        cell.transform = CGAffineTransformMakeScale(1, 1);
    } completion:^(BOOL finished) {}];
}

#pragma mark - Gesture
-(void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (_isSelectionModeEnabled) return;
    
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded) {
        // return;
    }
    CGPoint p = [gestureRecognizer locationInView:self];
    
    NSIndexPath *indexPath = [self indexPathForItemAtPoint:p];
    if (indexPath == nil){
        NSLog(@"couldn't find index path");
    } else {
        // get the cell at indexPath (the one you long pressed)
        BA_MarkableCollectionViewCell* cell = (BA_MarkableCollectionViewCell*) [self cellForItemAtIndexPath:indexPath];
        
        if(cell.isChecked) return;
        
        // Selection mode enabled
        [self setSelectionEnabled:YES];
        
        // Set the selected cell checked
        [cell setChecked:YES];
        _isSelectionModeEnabled = true;
        
        // Add to array
        [_selectedItems addObject:indexPath];
        
        [self selectionChanged];
    }
}


#pragma mark - Accessors
- (NSArray*) selectedItems{
    return _selectedItems;
}

#pragma mark - Helpers
- (void) setSelectionEnabled:(BOOL) enabled
{
    // Remove check marks on views
    for(BA_MarkableCollectionViewCell* cell in [self  visibleCells]){
        [cell setSelectionEnabled:enabled];
    }
}

- (void) selectionChanged{
    // Delegate
    if([self.selectableDelegate respondsToSelector:@selector(collectionView:selectionDidChanged:)]){
        [self.selectableDelegate collectionView:self selectionDidChanged:_selectedItems.count];
    }
}

@end
