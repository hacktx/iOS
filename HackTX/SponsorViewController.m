//
//  SponsorViewController.m
//  HackTX
//
//  Created by Jose Bethancourt on 9/17/16.
//  Copyright © 2016 HackTX. All rights reserved.
//

#import "SponsorViewController.h"
#import "SponsorTableViewCell.h"

#import "AutolayoutHelper.h"
#import "UIColor+Palette.h"
#import "FCAlertView.h"
#import "Sponsor.h"
#import "HTXAPI.h"

#import <ChameleonFramework/Chameleon.h>

@interface SponsorViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
@property (nonatomic, strong) NSArray<NSArray<Sponsor *> *> *sponsors;

@end

static NSString *reuseIdentifier = @"com.HackTX.sponsor";

@implementation SponsorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    self.tableView.estimatedRowHeight = 40;
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = [UIColor flatWhiteColor];
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, -35);
    
    
    UINib *nib = [UINib nibWithNibName:@"SponsorTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    
    [AutolayoutHelper configureView:self.view subViews:VarBindings(_tableView)
                            metrics:VarBindings(_tableView)
                        constraints:@[@"V:|[_tableView]|",
                                      @"H:|[_tableView]|"]];

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
    RLMResults<Sponsor *> *sponsorResult = [[Sponsor allObjects] sortedResultsUsingProperty:@"level" ascending:YES];
    self.tableView.hidden = YES;

    if (sponsorResult.count > 0) {
        RLMResults<Sponsor *> *sponsorResult = [[Sponsor allObjects] sortedResultsUsingProperty:@"level" ascending:YES];
        [self transformRLMEventsArray:sponsorResult];
        
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
    RLMResults<Sponsor *> *sponsorResult = [[Sponsor allObjects] sortedResultsUsingProperty:@"level" ascending:YES];
    [self transformRLMEventsArray:sponsorResult];
    [self.tableView reloadData];
}

- (void)transformRLMEventsArray:(RLMResults <Sponsor *> *)eventData {

    NSMutableArray <NSMutableArray<Sponsor *> *> *sponsorArray = [[NSMutableArray alloc] init];
    NSMutableArray *innerArray = [[NSMutableArray alloc] init];
    
    for (Sponsor *sponsor in eventData) {
        NSInteger i = 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SponsorTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    
    cell.name.text = self.sponsors[indexPath.section][indexPath.row].name;
    cell.url.text = self.sponsors[indexPath.section][indexPath.row].website;
    
    cell.layer.cornerRadius = 5;
    cell.layer.masksToBounds = true;
    
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
