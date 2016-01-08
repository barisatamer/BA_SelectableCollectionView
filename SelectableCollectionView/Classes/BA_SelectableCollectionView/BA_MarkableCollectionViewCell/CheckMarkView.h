//
//  CheckMarkView.h
//  InspectTHIS
//
//  Created by Baris Atamer on 31/12/15.
//  Copyright © 2015 Avandel, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM( NSUInteger, SSCheckMarkStyle )
{
    SSCheckMarkStyleOpenCircle,
    SSCheckMarkStyleGrayedOut
};

@interface CheckMarkView : UIView

@property (readwrite, nonatomic) BOOL checked;


@end
