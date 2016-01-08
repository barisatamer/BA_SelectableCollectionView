//
//  BA_MarkableCollectionViewCell.h
//  InspectTHIS
//
//  Created by Baris Atamer on 29/12/15.
//  Copyright © 2015, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * @class BA_MarkableCollectionViewCell
 * @author Baris Atamer
 * @date 29/12/15
 *
 * @version 1.0
 *
 * @discussion This class is used for showing check mark icons in UICollectionViewCells.
 */
@interface BA_MarkableCollectionViewCell : UICollectionViewCell

- (void) setChecked:(BOOL) checked;
- (BOOL) isChecked;
- (void) setSelectionEnabled:(BOOL) enabled;
@end
