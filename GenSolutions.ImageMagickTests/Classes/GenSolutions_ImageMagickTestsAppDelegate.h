//
//  GenSolutions_ImageMagickTestsAppDelegate.h
//  GenSolutions.ImageMagickTests
//
//  Created by nicu on 11/6/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenSolutions_ImageMagickTestsAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UINavigationController *navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end

