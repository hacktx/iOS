//
//  AnnouncementsViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 8/31/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "AnnouncementsViewController.h"
#import "AnnouncementTableViewCell.h"

#import "AutolayoutHelper.h"
#import "UIColor+Palette.h"
#import "SVProgressHUD.h"
#import "Announcement.h"
#import "FCAlertView.h"
#import "HTXAPI.h"

@interface AnnouncementsViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) RLMResults<Announcement *> *announcements;

@end

static NSString *reuseIdentifier = @"com.HackTX.announcement";

@implementation AnnouncementsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 85;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor htx_white];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView setRefreshControl:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(hardRefresh) forControlEvents:UIControlEventValueChanged];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    UINib *nib = [UINib nibWithNibName:@"AnnouncementTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    
    [AutolayoutHelper configureView:self.view fillWithSubView:self.tableView];
    
    [self initData];
    [self.tableView layoutIfNeeded];
    [self.tableView reloadData];
    
}

- (void)hardRefresh {
    
    [HTXAPI refreshAnnouncements:^(BOOL success) {
        if (success) {
            [self.refreshControl endRefreshing];
            [self refreshData];
        } else {
            [self.refreshControl endRefreshing];
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error fetching the announcements, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
            NSLog(@"[HTX] Announcements refresh failed");
        }
    }];
}

- (void)refresh {
    [HTXAPI refreshAnnouncements:^(BOOL success) {
        if (success) {
            [self initData];
        } else {
            [self.refreshControl endRefreshing];
            [SVProgressHUD dismiss];
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error fetching the announcements, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
            NSLog(@"[HTX] Schedule refresh failed");
        }
    }];
}

- (void)initData {
    self.announcements = [[Announcement allObjects] sortedResultsUsingProperty:@"timestamp" ascending:NO];
    [SVProgressHUD show];
    
    if (self.announcements.count > 0) {
        self.announcements = [[Announcement allObjects] sortedResultsUsingProperty:@"timestamp" ascending:NO];
        
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
        
        [HTXAPI refreshAnnouncements:^(BOOL success) {
            if (success) {
                [self refreshData];
            }
        }];
        
    } else {
        [self refresh];
    }
}

- (void)refreshData {
    self.announcements = [[Announcement allObjects] sortedResultsUsingProperty:@"timestamp" ascending:NO];
    [self.tableView reloadData];
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
    AnnouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.timeStyle = NSDateFormatterShortStyle;
    formatter.dateStyle = NSDateFormatterNoStyle;
          
    cell.text.text = self.announcements[indexPath.row].text;
    cell.time.text = [formatter stringFromDate:self.announcements[indexPath.row].timestamp];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.announcements.count;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
