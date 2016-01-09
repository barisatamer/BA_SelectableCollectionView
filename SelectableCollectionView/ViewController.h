//
//  ViewController.h
//  SelectableCollectionView
//
//  Created by Baris Atamer on 08/01/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BA_SelectableCollectionView.h"

@interface ViewController : UIViewController <BA_SelectableCollectionViewDelegate, BA_SelectableCollectionViewDataSource>

@property (weak, nonatomic) IBOutlet BA_SelectableCollectionView *collectionView;

@end

