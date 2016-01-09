//
//  BA_SelectableCollectionView.h
//  SelectableCollectionView
//
//  Created by Baris Atamer on 1/8/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import <UIKit/UIKit.h>

// Protocols
@protocol BA_SelectableCollectionViewDelegate <UICollectionViewDelegate>
@optional
- (void)collectionView:(nonnull UICollectionView*)collectionView selectionDidChanged:(NSUInteger) selectionCount;
@end

@protocol BA_SelectableCollectionViewDataSource <UICollectionViewDataSource>
@end


@interface BA_SelectableCollectionView : UICollectionView <UIGestureRecognizerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    // Delegates
    id <UICollectionViewDelegate,   BA_SelectableCollectionViewDelegate>    __weak _selectableDelegate;
    id <UICollectionViewDataSource, BA_SelectableCollectionViewDataSource>  __weak _selectableDataSource;
}


//@property (nonatomic, weak, nullable) IBOutlet id selectableDelegate;
//@property (nonatomic, weak, nullable) IBOutlet id selectableDataSource;
@property (nonatomic, weak) id <BA_SelectableCollectionViewDelegate> delegate;
@property (nonatomic, weak) id <BA_SelectableCollectionViewDataSource> dataSource;

@property (nonatomic, readonly, weak) id<BA_SelectableCollectionViewDelegate> selectableDelegate;
@property (nonatomic, readonly, weak) id<BA_SelectableCollectionViewDataSource> selectableDataSource;

@end
