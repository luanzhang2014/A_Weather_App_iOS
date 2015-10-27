//
//  WXManager.h
//  weather
//
//  Created by Luan Zhang on 10/22/15.
//  Copyright (c) 2015 Luan Zhang. All rights reserved.
//

@import Foundation;
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa.h>
// 1
#import "WXCondition.h"

@interface WXManager : NSObject
<CLLocationManagerDelegate>

// 2
+ (instancetype)sharedManager;

// 3
@property (nonatomic, strong, readonly) CLLocation *currentLocation;
@property (nonatomic, strong, readonly) WXCondition *currentCondition;
@property (nonatomic, strong, readonly) NSArray *hourlyForecast;
@property (nonatomic, strong, readonly) NSArray *dailyForecast;

// 4
- (void)findCurrentLocation;
- (void) setLocation: (CLLocation *) destination;
- (RACSignal *)updateCurrentConditions;
- (RACSignal *)updateHourlyForecast;
- (RACSignal *)updateDailyForecast;
@end