//
//  ScheduleViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 8/31/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "ScheduleViewController.h"
#import "ScheduleTableViewCell.h"

#import "AutolayoutHelper.h"
#import "UIColor+Palette.h"
#import "FCAlertView.h"
#import "HTXAPI.h"
#import "Event.h"

@interface ScheduleViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSArray<NSArray<Event *> *> *events;

@end

static NSString *reuseIdentifier = @"com.HackTX.schedule";

@implementation ScheduleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 100;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor htx_white];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    UINib *nib = [UINib nibWithNibName:@"ScheduleTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    
    [AutolayoutHelper configureView:self.view fillWithSubView:self.tableView];
    
    [self initData];
}

- (void)refresh {
    [HTXAPI refreshEvents:^(BOOL success) {
        if (success) {
            [self initData];
        } else {
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error fetching the schedule, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
            NSLog(@"[HTX] Schedule refresh failed");
        }
    }];
}

- (void)initData {
    RLMResults<Event *> *eventResult = [[Event allObjects] sortedResultsUsingProperty:@"serverID" ascending:YES];
    self.tableView.hidden = YES;

    if (eventResult.count > 0) {
        RLMResults<Event *> *eventResult = [[Event allObjects] sortedResultsUsingProperty:@"serverID" ascending:YES];

        [self transformRLMArray:eventResult];
        
        self.tableView.hidden = NO;
        [self.tableView reloadData];
        
        [HTXAPI refreshSponsors:^(BOOL success) {
            if (success) {
                [self refreshData];
            }
        }];
        
    } else {
        [self refresh];
    }
}

- (void)refreshData {
    RLMResults<Event *> *eventResult = [[Event allObjects] sortedResultsUsingProperty:@"serverID" ascending:YES];
    [self transformRLMArray:eventResult];
    [self.tableView reloadData];
}


- (void)transformRLMArray:(RLMResults <Event *> *)eventData {
    NSMutableArray <NSMutableArray<Event *> *> *eventArray = [[NSMutableArray alloc] init];
    NSMutableArray *innerArray = [[NSMutableArray alloc] init];
    
    NSInteger currentDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:eventData[0].startDate];

    for (Event *event in eventData) {
        NSInteger testDay = [[NSCalendar currentCalendar] component:NSCalendarUnitDay fromDate:event.startDate];

        if (currentDay == testDay) {
            [innerArray addObject:event];
        } else {
            currentDay = testDay;
            
            [eventArray addObject:innerArray];
            innerArray = [[NSMutableArray alloc] init];
            [innerArray addObject:event];
        }
    }
    [eventArray addObject:innerArray];
    
    self.events = eventArray;
}

- (NSInteger)getYear:(NSDate *)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];

    NSInteger day = [components day];
    
    return day;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScheduleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.name.text = self.events[indexPath.section][indexPath.row].name;
    cell.desc.text = self.events[indexPath.section][indexPath.row].desc;
    cell.time.text = self.events[indexPath.section][indexPath.row].location.room;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.events.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.events[section].count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
