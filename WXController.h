//
//  WXController.h
//  weather
//
//  Created by Luan Zhang on 10/21/15.
//  Copyright (c) 2015 Luan Zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXManager.h"
@import CoreLocation;
@interface WXController : UIViewController
<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UITextField *latitude;
@property (nonatomic, strong) UITextField *longitude;
@property (nonatomic, strong, readonly) CLLocation *location;



@end
