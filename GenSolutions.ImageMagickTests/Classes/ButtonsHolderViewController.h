//
//  ButtonsHolderViewController.h
//  GenSolutions.ImageMagickTests
//
//  Created by nicu on 11/6/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageMagickWorkspaceViewController.h"


@interface ButtonsHolderViewController : UIViewController<UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImageMagickWorkspaceDelegate> {
}

-(IBAction) cameraButtonTap:(id)sender;
-(IBAction) libraryButtonTap:(id)sender;

@end
