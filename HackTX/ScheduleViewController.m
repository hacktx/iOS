//
//  ScheduleViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 8/31/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "ScheduleViewController.h"
#import "HTXTableViewCell.h"
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

    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 40;
    self.tableView.allowsSelection = NO;
    [_tableView registerClass:[HTXTableViewCell class] forCellReuseIdentifier:reuseIdentifier];
    
    [self initData];
}

- (void)refresh {
    [HTXAPI refreshEvents:^(NSDictionary *response) {
        if (response[@"status"]) {
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
            
            NSLog(@"[HTX] Data refresh failed");
        }
    }];
}

- (void)initData {
    RLMResults<Event *> *eventResult = [Event allObjects];
    self.tableView.hidden = YES;

    if (eventResult.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [self transformRLMEventsArray:eventResult];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                // hide the spinner or whatever
                self.tableView.hidden = NO;
                [self.tableView reloadData];

            });
        });
        
    } else {
        [self refresh];
    }
}

- (void)transformRLMEventsArray:(RLMResults <Event *> *)eventData {

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
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
