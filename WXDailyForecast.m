//
//  WXDailyForecast.m
//  weather
//
//  Created by Luan Zhang on 10/22/15.
//  Copyright (c) 2015 Luan Zhang. All rights reserved.
//

#import "WXDailyForecast.h"

@implementation WXDailyForecast

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    NSMutableDictionary *paths = [[ super  JSONKeyPathsByPropertyKey] mutableCopy];
    paths[@ "tempHigh" ] = @ "temp.max" ;
    paths[@ "tempLow" ] = @ "temp.min" ;
    return  paths;
}

@end
