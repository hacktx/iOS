//
//  FCAlertView.h
//  ShiftRide
//
//  Created by Nima Tahami on 2016-07-10.
//  Copyright © 2016 Nima Tahami. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@protocol FCAlertViewDelegate;

@interface FCAlertView : UIView {
    
    // Default UI adjustments
    
    CGFloat defaultHeight;
    CGFloat defaultSpacing;
    
    // AlertView & Contents
    
    UIView *alertView;
    UIView *alertViewContents;
    CAShapeLayer *circleLayer;
    
    // Customizations made to UI
    
    NSMutableArray *alertButtons;
    NSInteger alertViewWithVector;
    NSString *doneTitle;
    UIImage *vectorImage;
    NSString *alertType;
    
}

// Delegate

@property (nonatomic, weak) id<FCAlertViewDelegate> delegate;

// AlertView Title & Subtitle Text

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *subTitle;

// AlertView Background

@property (nonatomic, retain) UIView *alertBackground;

// AlertView Customizations

@property NSInteger numberOfButtons;
@property NSInteger autoHideSeconds;
@property CGFloat cornerRadius;

@property BOOL dismissOnOutsideTouch;
@property BOOL hideAllButtons;
@property BOOL hideDoneButton;
@property BOOL avoidCustomImageTint;

// Default Types of Alerts

- (void) makeAlertTypeWarning;
- (void) makeAlertTypeCaution;
- (void) makeAlertTypeSuccess;

// Presenting AlertView

- (void) showAlertInView:(UIViewController *)view withTitle:(NSString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons;

- (void) showAlertInWindow:(UIWindow *)window withTitle:(NSString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons;

- (void) showAlertWithTitle:(NSString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons;

- (void)setAlertViewAttributes:(NSString *)title withSubtitle:(NSString *)subTitle withCustomImage:(UIImage *)image withDoneButtonTitle:(NSString *)done andButtons:(NSArray *)buttons;

// Dismissing AlertView

- (void) dismissAlertView;

// Alert Action Block Method

typedef void (^FCActionBlock)(void);
@property (nonatomic, copy) FCActionBlock actionBlock;
@property (nonatomic, copy) FCActionBlock doneBlock;
- (void)addButton:(NSString *)title withActionBlock:(FCActionBlock)action;
- (void)doneActionBlock:(FCActionBlock)action;

// Color Schemes

@property (nonatomic, retain) UIColor * colorScheme;
@property (nonatomic, retain)  UIColor * titleColor;
@property (nonatomic, retain)  UIColor * subTitleColor;

// Preset Flat Colors

@property (nonatomic, retain) UIColor * flatTurquoise;
@property (nonatomic, retain) UIColor * flatGreen;
@property (nonatomic, retain) UIColor * flatBlue;
@property (nonatomic, retain) UIColor * flatMidnight;
@property (nonatomic, retain) UIColor * flatPurple;
@property (nonatomic, retain) UIColor * flatOrange;
@property (nonatomic, retain) UIColor * flatRed;
@property (nonatomic, retain) UIColor * flatSilver;
@property (nonatomic, retain) UIColor * flatGray;

@end

@protocol FCAlertViewDelegate <NSObject>
@optional
- (void)FCAlertView:( FCAlertView *)alertView clickedButtonIndex:(NSInteger)index buttonTitle:(NSString *)title;
- (void)FCAlertViewDismissed:(FCAlertView *)alertView;
- (void)FCAlertViewWillAppear:(FCAlertView *)alertView;
- (void)FCAlertDoneButtonClicked:(FCAlertView *)alertView;

@end
