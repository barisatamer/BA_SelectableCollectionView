//
//  ViewController.m
//  SelectableCollectionView
//
//  Created by Baris Atamer on 08/01/16.
//  Copyright © 2016 Baris Atamer. All rights reserved.
//

#import "ViewController.h"
#import "Cell.h"

NSString *kCellID = @"cellID";                          // UICollectionViewCell storyboard id

@interface ViewController ()

@end

@implementation ViewController
{
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView delegates
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 32;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // we're going to use a custom UICollectionViewCell, which will hold an image and its label
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:kCellID forIndexPath:indexPath];
    
    // make the cell's title the actual NSIndexPath value
    cell.label.text = [NSString stringWithFormat:@"{%ld,%ld}", (long)indexPath.row, (long)indexPath.section];
    
    // load the image for this cell
    NSString *imageToLoad = [NSString stringWithFormat:@"%ld.jpg", (long)indexPath.row];
    cell.image.image = [UIImage imageNamed:imageToLoad];
    
    return cell;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //
}

- (void) collectionView:(UICollectionView *)collectionView selectionDidChanged:(NSUInteger)selectionCount{
    self.title = [NSString stringWithFormat:@"%d selected", selectionCount ];
    NSLog(@"%d selected",selectionCount);
}

@end
