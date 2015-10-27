//
//  WXController.m
//  weather
//
//  Created by Luan Zhang on 10/21/15.
//  Copyright (c) 2015 Luan Zhang. All rights reserved.
//

#import <LBBlurredImage/UIImageView+LBBlurredImage.h>
#import "WXController.h"
#import "WXManager.h"

@interface WXController ()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *blurredImageView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) NSDateFormatter *hourlyFormatter;
@property (nonatomic, strong) NSDateFormatter *dailyFormatter;
@property(nonatomic, weak) id< UITextFieldDelegate > dele;

@end

@implementation WXController

- (id)init {
    if (self = [super init]) {
        _hourlyFormatter = [[NSDateFormatter alloc] init];
        _hourlyFormatter.dateFormat = @"h a";
        
        _dailyFormatter = [[NSDateFormatter alloc] init];
        _dailyFormatter.dateFormat = @"EEEE";
    }
    return self;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenHeight = [UIScreen mainScreen].bounds.size.height;

    UIImage *background = [UIImage imageNamed:@"bg.png"];
    
    self.backgroundImageView = [[UIImageView alloc] initWithImage:background];
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.backgroundImageView];
    
    self.blurredImageView = [[UIImageView alloc] init];
    self.blurredImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.blurredImageView.alpha = 0;
    [self.blurredImageView setImageToBlur:background blurRadius:10 completionBlock:nil];
    [self.view addSubview:self.blurredImageView];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.2];
    self.tableView.pagingEnabled = YES; 
    [self.view addSubview:self.tableView];
    CGRect headerFrame = [UIScreen mainScreen].bounds;
    CGFloat inset = 20;
    CGFloat temperatureHeight = 110;
    CGFloat hiloHeight = 40;
    CGFloat iconHeight = 30;

    CGRect hiloFrame = CGRectMake(inset,
                                  headerFrame.size.height - hiloHeight,
                                  headerFrame.size.width - (2 * inset),
                                  hiloHeight);
    
    CGRect temperatureFrame = CGRectMake(inset,
                                         headerFrame.size.height - (temperatureHeight + hiloHeight),
                                         headerFrame.size.width - (2 * inset),
                                         temperatureHeight);
    
    CGRect iconFrame = CGRectMake(inset,
                                  temperatureFrame.origin.y - iconHeight,
                                  iconHeight,
                                  iconHeight);

    CGRect conditionsFrame = iconFrame;
    conditionsFrame.size.width = self.view.bounds.size.width - (((2 * inset) + iconHeight) + 10);
    conditionsFrame.origin.x = iconFrame.origin.x + (iconHeight + 10);
    
    CGRect buttonFrame = CGRectMake(inset,
                                    headerFrame.size.height - 350,
                                    headerFrame.size.width - (2 * inset),
                                    hiloHeight);

    CGRect latitudeFrame = CGRectMake(90.0f, 60.0f, 90.0f, 40.0f);
    CGRect longitudeFrame = CGRectMake(190.0f, 60.0f, 90.0f, 40.0f);
    CGRect lableFrame = CGRectMake(5, 65, 70, 30);
    CGRect cityFrame = CGRectMake(0, 20, self.view.bounds.size.width, 30);

    UIView *header = [[UIView alloc] initWithFrame:headerFrame];
    header.backgroundColor = [UIColor clearColor];
    self.tableView.tableHeaderView = header;
    
    //Add search function
    UIButton* button = [UIButton buttonWithType: UIButtonTypeRoundedRect];
    button.frame = buttonFrame;
    [button setTitle:@"Search" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor]forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    button.backgroundColor = [UIColor clearColor];
    button.layer.borderWidth = 1.5;
    button.layer.cornerRadius = 4.5;
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    [button addTarget:self action:@selector(zoomInAction:) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview: button];
    
    UILabel* label = [[UILabel alloc] initWithFrame:lableFrame];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont fontWithName:@"Helvetica-Bold"size:18];
    label.text = @"Search:";
    label.textColor = [UIColor whiteColor];
    [header addSubview:label];
    
    self.latitude = [[UITextField alloc] initWithFrame:latitudeFrame];
    [self.latitude setBorderStyle:UITextBorderStyleRoundedRect];
    self.latitude.placeholder = @"latitude";
    self.latitude.returnKeyType =UIReturnKeyDone;
    [header addSubview:self.latitude];
    
    self.longitude = [[UITextField alloc] initWithFrame:longitudeFrame];
    [self.longitude setBorderStyle:UITextBorderStyleRoundedRect];
    self.longitude.placeholder = @"longitude";
    self.longitude.returnKeyType =UIReturnKeyDone;
    [header addSubview:self.longitude];
    
    // bottom left
    UILabel *temperatureLabel = [[UILabel alloc] initWithFrame:temperatureFrame];
    temperatureLabel.backgroundColor = [UIColor clearColor];
    temperatureLabel.textColor = [UIColor whiteColor];
    temperatureLabel.text = @ "0°" ;
    temperatureLabel.font = [UIFont fontWithName:@ "HelveticaNeue-UltraLight"  size:120];
    [header addSubview:temperatureLabel];
    
    // bottom left
    UILabel *hiloLabel = [[UILabel alloc] initWithFrame:hiloFrame];
    hiloLabel.backgroundColor = [UIColor clearColor];
    hiloLabel.textColor = [UIColor whiteColor];
    hiloLabel.text = @ "0° / 0°" ;
    hiloLabel.font = [UIFont fontWithName:@ "HelveticaNeue-Light"  size:28];
    [header addSubview:hiloLabel];
    
    // top
    UILabel *cityLabel = [[UILabel alloc] initWithFrame:cityFrame];
    cityLabel.backgroundColor = [UIColor clearColor];
    cityLabel.textColor = [UIColor whiteColor];
    cityLabel.text = @ "Loading..." ;
    cityLabel.font = [UIFont fontWithName:@ "HelveticaNeue-Light"  size:18];
    cityLabel.textAlignment = NSTextAlignmentCenter;
    [header addSubview:cityLabel];
    
    UILabel *conditionsLabel = [[UILabel alloc] initWithFrame:conditionsFrame];
    conditionsLabel.backgroundColor = [UIColor clearColor];
    conditionsLabel.font = [UIFont fontWithName:@ "HelveticaNeue-Light"  size:18];
    conditionsLabel.textColor = [UIColor whiteColor];
    [header addSubview:conditionsLabel];
   
    // bottom left
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:iconFrame];
    iconView.contentMode = UIViewContentModeScaleAspectFit; 
    iconView.backgroundColor = [UIColor clearColor];
    [header addSubview:iconView];
    [[RACObserve([WXManager sharedManager], currentCondition)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(WXCondition *newCondition) {
         temperatureLabel.text = [NSString stringWithFormat:@"%.0f°",newCondition.temperature.floatValue];
         conditionsLabel.text = [newCondition.condition capitalizedString];
         cityLabel.text = [newCondition.locationName capitalizedString];
         
        iconView.image = [UIImage imageNamed:[newCondition imageName]];
         
         self.backgroundImageView.image = [UIImage imageNamed:[newCondition bgimageName]];
         NSString *tmp;
         
         if([[newCondition bgimageName] isEqualToString: @"clear.png"]){
             tmp = @"clear.png";
         }
         else if([[newCondition bgimageName] isEqualToString: @"few.png"]){
             tmp = @"few.png";
         } else if([[newCondition bgimageName] isEqualToString: @"rain.png"]){
             tmp = @"rain.png";
         }else if([[newCondition bgimageName] isEqualToString: @"tstorm.png"]){
             tmp = @"tstorm.png";
         }else if([[newCondition bgimageName] isEqualToString: @"moon.png"]){
             tmp = @"moon.png";
         }else if([[newCondition bgimageName] isEqualToString: @"snow.png"]){
             tmp = @"snow.png";
         }else if([[newCondition bgimageName] isEqualToString: @"rain-night"]){
             tmp = @"rain-night";
         }else if([[newCondition bgimageName] isEqualToString: @"few-night.png"]){
             tmp = @"few-night.png";
         }else if([[newCondition bgimageName] isEqualToString: @"shower.png"]){
             tmp = @"shower.png";
         }else if([[newCondition bgimageName] isEqualToString: @"broken.png"]){
             tmp = @"broken.png";
         }else {
             tmp = @"mist.png";
         };
         
         
         [self.blurredImageView setImageToBlur:[UIImage imageNamed:tmp] blurRadius:10 completionBlock:nil];
         
     }];
    
    
    RAC(hiloLabel, text) = [[RACSignal combineLatest:@[
                                                       RACObserve([WXManager sharedManager], currentCondition.tempHigh),
                                                       RACObserve([WXManager sharedManager], currentCondition.tempLow)]
                                              reduce:^(NSNumber *hi, NSNumber *low) {
                                                  return [NSString  stringWithFormat:@"%.0f° / %.0f°",hi.floatValue,low.floatValue];
                                              }] 
                            deliverOn:RACScheduler.mainThreadScheduler];
    [[WXManager sharedManager] findCurrentLocation];
    
    
    [[RACObserve([WXManager sharedManager], hourlyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];
    
    [[RACObserve([WXManager sharedManager], dailyForecast)
      deliverOn:RACScheduler.mainThreadScheduler]
     subscribeNext:^(NSArray *newForecast) {
         [self.tableView reloadData];
     }];

}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return  2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // TODO: Return count of forecast
    
    if (section == 0) {
        return MIN([[WXManager sharedManager].hourlyForecast count], 6) + 1;
    }
    return MIN([[WXManager sharedManager].dailyForecast count], 6) + 1;
    return  0;
}


//action after clicking button
-(void)zoomInAction:(id)sender {
    self.backgroundImageView.image = [UIImage imageNamed:@"bg.png"];
    
    _location = [[CLLocation alloc]
                 initWithLatitude:[ _latitude.text floatValue]
                 longitude:[ _longitude.text floatValue]];
    [[WXManager sharedManager] setLocation: _location];
    [[WXManager sharedManager] updateCurrentConditions];
    [[WXManager sharedManager] updateHourlyForecast];
    [[WXManager sharedManager] updateDailyForecast];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static  NSString *CellIdentifier = @ "CellIdentifier" ;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if  (! cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];
    
    // TODO: Setup the cell
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Hourly Forecast"];
        }
        else {
            WXCondition *weather = [WXManager sharedManager].hourlyForecast[indexPath.row - 1];
            [self configureHourlyCell:cell weather:weather];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self configureHeaderCell:cell title:@"Daily Forecast"];
        }
        else {
            WXCondition *weather = [WXManager sharedManager].dailyForecast[indexPath.row - 1];
            [self configureDailyCell:cell weather:weather]; 
        } 
    }
    
    return  cell;
}
- (void)configureHeaderCell:(UITableViewCell *)cell title:(NSString *)title {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = title;
    cell.detailTextLabel.text = @"";
    cell.imageView.image = nil;
}

- (void)configureHourlyCell:(UITableViewCell *)cell weather:(WXCondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.hourlyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f°",weather.temperature.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

- (void)configureDailyCell:(UITableViewCell *)cell weather:(WXCondition *)weather {
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:18];
    cell.detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:18];
    cell.textLabel.text = [self.dailyFormatter stringFromDate:weather.date];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0f° / %.0f°",
                                 weather.tempHigh.floatValue,
                                 weather.tempLow.floatValue];
    cell.imageView.image = [UIImage imageNamed:[weather imageName]];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
}
//#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Determine cell height based on screen
    NSInteger cellCount = [self tableView:tableView numberOfRowsInSection:indexPath.section];
    return self.screenHeight / (CGFloat)cellCount;
    return  44;
}

- ( void )viewWillLayoutSubviews {
    [ super  viewWillLayoutSubviews];
    
    CGRect bounds = self.view.bounds;
    
    self.backgroundImageView.frame = bounds;
    self.blurredImageView.frame = bounds;
    self.tableView.frame = bounds;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat height = scrollView.bounds.size.height;
    CGFloat position = MAX(scrollView.contentOffset.y, 0.0);
    CGFloat percent = MIN(position / height, 1.0);
    self.blurredImageView.alpha = percent;
}

@end
