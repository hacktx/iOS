//
//  SponsorViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "SponsorViewController.h"

#import "HTXTableViewCell.h"
#import "FCAlertView.h"
#import "Sponsor.h"
#import "HTXAPI.h"

@interface SponsorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSArray<NSArray<Sponsor *> *> *sponsors;

@end

static NSString *reuseIdentifier = @"com.HackTX.sponsor";

@implementation SponsorViewController

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

    [self initData];
}

- (void)refresh {
    [HTXAPI refreshSponsors:^(BOOL success) {
        if (success) {
            [self initData];
        } else {
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error fetching the sponsors, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
            NSLog(@"[HTX] Data refresh failed");
            
        }
    }];
}

- (void)initData {
    RLMResults<Sponsor *> *sponsorResult = [Sponsor allObjects];
    self.tableView.hidden = YES;
    NSLog(@"%@", sponsorResult);
    if (sponsorResult.count > 0) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [self transformRLMEventsArray:sponsorResult];
            
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

- (void)transformRLMEventsArray:(RLMResults <Sponsor *> *)eventData {
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HTXTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.sponsors.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sponsors[section].count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
