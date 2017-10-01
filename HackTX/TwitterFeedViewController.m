//
//  TwitterFeedViewController.m
//  HackTX
//
//  Created by Ashwin Gupta on 9/30/17.
//  Copyright © 2017 HackTX. All rights reserved.
//

#import "TwitterFeedViewController.h"
#import "TwitterFeedTableViewCell.h"

#import "AutolayoutHelper.h"
#import "UIColor+Palette.h"
#import "SVProgressHUD.h"
#import "FCAlertView.h"
#import "HTXAPI.h"
#import "Tweet.h"

@interface TwitterFeedViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray<Tweet*> *tweets;

@end

static NSString *reuseIdentifier = @"com.HackTX.twitterFeed";

@implementation TwitterFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 100;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor htx_white];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView setRefreshControl:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(hardRefresh) forControlEvents:UIControlEventValueChanged];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    UINib *nib = [UINib nibWithNibName:@"ScheduleTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    
    [AutolayoutHelper configureView:self.view fillWithSubView:self.tableView];
    
    [self initData];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
    
}

- (void)hardRefresh {
    
    [HTXAPI refreshTweets:^(BOOL success) {
        if (success) {
            [self.refreshControl endRefreshing];
            [self refreshData];
        } else {
            [self.refreshControl endRefreshing];
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error fetching tweets, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
            NSLog(@"[HTX] Twitter Feed refresh failed");
        }
    }];
    
}

- (void)refresh {
    [HTXAPI refreshTweets:^(BOOL success) {
        if (success) {
            [self initData];
        } else {
            [SVProgressHUD dismiss];
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error fetching tweets, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
            NSLog(@"[HTX] Tweets refresh failed");
        }
    }];
}

- (void)initData {
    RLMResults<Tweet *> *tweetResult = [[Tweet allObjects] sortedResultsUsingProperty:@"tweetTime" ascending:YES];
    [SVProgressHUD show];
    
    if (tweetResult.count > 0) {
        RLMResults<Tweet *> *tweetResult = [[Tweet allObjects] sortedResultsUsingProperty:@"tweetTime" ascending:YES];

        [self transformRLMArray:tweetResult];
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
//        [HTXAPI refreshSponsors:^(BOOL success) {
//            if (success) {
//                [self refreshData];
//            }
//        }];
        
    } else {
        [self refresh];
    }
}

- (void)refreshData {
    RLMResults<Tweet *> *tweetResult = [[Tweet allObjects] sortedResultsUsingProperty:@"startDate" ascending:YES];

    [self transformRLMArray:tweetResult];
    [self.tableView reloadData];
}


- (void)transformRLMArray:(RLMResults <Tweet *> *)tweetData {
    NSMutableArray <Tweet *> *tweetArray = [[NSMutableArray alloc] init];

    for(Tweet* tweet in tweetArray){
        [tweetArray addObject: tweet];
    }
    
    self.tweets = tweetArray;
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
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TwitterFeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterNoStyle;
    
    NSString *tweetTime = [formatter stringFromDate:self.tweets[indexPath.row].tweetTime];
    cell.tweetTime.text = tweetTime;
    //NSString *endTS =[formatter stringFromDate:self.tweets[indexPath.section][indexPath.row].endDate];
    
    NSString *description = [NSString stringWithFormat:@"%@", self.tweets[indexPath.row].tweetDesc];
    
    cell.tweetDesc.text = description;
    
    [cell updateConstraintsIfNeeded];
    cell.tweetDesc.preferredMaxLayoutWidth = cell.tweetDesc.frame.size.width;
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.tweets.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tweets.count;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
