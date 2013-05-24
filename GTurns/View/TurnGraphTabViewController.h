//
//  TurnGraphTabViewController.h
//  GTurns
//
//  Created by Matt Higgins on 5/21/13.
//  Copyright (c) 2013 Matt Higgins. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CorePlot-CocoaTouch.h"
#import "BTManager.h"

@interface TurnGraphTabViewController : UIViewController <CPTPlotDataSource, CLLocationManagerDelegate, BTManagerDelegate>


@end
