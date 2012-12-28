//
//  Test3AppDelegate.h
//  Test3
//
//  Created by Joseph on 6/15/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GLView;

@interface Test3AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GLView *glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GLView *glView;
@property (nonatomic, retain) IBOutlet UILabel *lblPoints;
@property (nonatomic, retain) IBOutlet UILabel *lblSliderValue;
@property (nonatomic, retain) IBOutlet UILabel *lblDebug;
@property (nonatomic, retain) IBOutlet UILabel *lblFast;
@property (nonatomic, retain) IBOutlet UILabel *lblSlow;
@property (nonatomic, retain) IBOutlet UILabel *lblAuto;
@property (nonatomic, retain) IBOutlet UISlider *sliderRed;
@property (nonatomic, retain) IBOutlet UISlider *sliderYellow;
@property (nonatomic, retain) IBOutlet UISlider *sliderGreen;
@property (nonatomic, retain) IBOutlet UISlider *sliderScale;
@property (nonatomic, retain) IBOutlet UISwitch *switchTimer;
@property (nonatomic, retain) IBOutlet UILabel *lblRed;
@property (nonatomic, retain) IBOutlet UILabel *lblGreen;
@property (nonatomic, retain) IBOutlet UILabel *lblYellow;

@end

