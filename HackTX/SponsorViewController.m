//
//  SponsorViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "SponsorViewController.h"
#import "SponsorTableViewCell.h"

#import "UIImageView+AFNetworking.h"
#import "AutolayoutHelper.h"
#import "UIColor+Palette.h"
#import "SVProgressHUD.h"
#import "FCAlertView.h"
#import "Sponsor.h"
#import "HTXAPI.h"

#import <ChameleonFramework/Chameleon.h>

@interface SponsorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSArray<NSArray<Sponsor *> *> *sponsors;

@end

static NSString *reuseIdentifier = @"com.HackTX.sponsor";

@implementation SponsorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.allowsSelection = YES;
    self.tableView.backgroundColor = [UIColor htx_white];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView setRefreshControl:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(hardRefresh) forControlEvents:UIControlEventValueChanged];
    
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f, 0.0f, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    UINib *nib = [UINib nibWithNibName:@"SponsorTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    
    [AutolayoutHelper configureView:self.view fillWithSubView:self.tableView];
    
    [self initData];
}

- (void)hardRefresh {
    
    [HTXAPI refreshSponsors:^(BOOL success) {
        if (success) {
            [self.refreshControl endRefreshing];
            [self refreshData];
        } else {
            [self.refreshControl endRefreshing];
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error fetching the sponsors, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
            NSLog(@"[HTX] Sponsor refresh failed");
        }
    }];
}

- (void)refresh {
    [HTXAPI refreshSponsors:^(BOOL success) {
        if (success) {
            [self initData];
        } else {
            [SVProgressHUD dismiss];
            FCAlertView *alert = [[FCAlertView alloc] init];
            
            [alert showAlertInView:self
                         withTitle:@"Network error"
                      withSubtitle:@"There was an error fetching the sponsors, please try again later. 😥"
                   withCustomImage:nil
               withDoneButtonTitle:@"Okay"
                        andButtons:nil];
            [alert makeAlertTypeCaution];
            
            NSLog(@"[HTX] Sponsor refresh failed");
            
        }
    }];
}

- (void)initData {
    RLMResults<Sponsor *> *sponsorResult = [[Sponsor allObjects] sortedResultsUsingProperty:@"level" ascending:YES];
    [SVProgressHUD show];

    if (sponsorResult.count > 0) {
        RLMResults<Sponsor *> *sponsorResult = [[Sponsor allObjects] sortedResultsUsingProperty:@"level" ascending:YES];
        [self transformRLMArray:sponsorResult];
        
        [SVProgressHUD dismiss];
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
    RLMResults<Sponsor *> *sponsorResult = [[Sponsor allObjects] sortedResultsUsingProperty:@"level" ascending:YES];
    [self transformRLMArray:sponsorResult];
    [self.tableView reloadData];
}

- (void)transformRLMArray:(RLMResults <Sponsor *> *)eventData {
    NSMutableArray <NSMutableArray<Sponsor *> *> *sponsorArray = [[NSMutableArray alloc] init];
    NSMutableArray *innerArray = [[NSMutableArray alloc] init];
    
    NSInteger i = eventData[0].level;
    
    for (Sponsor *sponsor in eventData) {
        
        if (i == [sponsor[@"level"] integerValue]) {
            [innerArray addObject:sponsor];
        } else {            
            i = [sponsor[@"level"] integerValue];
            
            [sponsorArray addObject:innerArray];
            innerArray = [[NSMutableArray alloc] init];
            [innerArray addObject:sponsor];
        }
    }
    [sponsorArray addObject:innerArray];

    self.sponsors = sponsorArray;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (CGFloat)tableView:(UITableView*)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSURL *sponsorURL = [NSURL URLWithString:self.sponsors[indexPath.section][indexPath.row].website];
    [[UIApplication sharedApplication] openURL:sponsorURL];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SponsorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.name.text = self.sponsors[indexPath.section][indexPath.row].name;
    cell.url.text = self.sponsors[indexPath.section][indexPath.row].website;
    UIImage *placeholderImage = [UIImage imageNamed:@"icon_htx"];
    
    __weak SponsorTableViewCell *weakCell = cell;
    NSURL *url = [NSURL URLWithString:self.sponsors[indexPath.section][indexPath.row].logoImage];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [cell.image setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       weakCell.image.image = image;
                                       
                                   } failure:nil];
    
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
}


@end
