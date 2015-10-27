//
//  WXClient.h
//  weather
//
//  Created by Luan Zhang on 10/22/15.
//  Copyright (c) 2015 Luan Zhang. All rights reserved.
//


#import <Foundation/Foundation.h>
@import CoreLocation;
#import <ReactiveCocoa/ReactiveCocoa.h>
@import Foundation;

@interface WXClient : NSObject
- (RACSignal *)fetchJSONFromURL:(NSURL *)url;
- (RACSignal *)fetchCurrentConditionsForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchHourlyForecastForLocation:(CLLocationCoordinate2D)coordinate;
- (RACSignal *)fetchDailyForecastForLocation:(CLLocationCoordinate2D)coordinate;

@end
