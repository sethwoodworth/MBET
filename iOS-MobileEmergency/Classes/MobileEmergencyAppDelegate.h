//
//  MobileEmergencyAppDelegate.h
//  MobileEmergency
//
//  Created by Seung Woon Lee on 11. 2. 11..
//  Copyright 2011 Soongsil. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MobileEmergencyAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

