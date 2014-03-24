//
//  ButtonsHolderViewController.m
//  GenSolutions.ImageMagickTests
//
//  Created by nicu on 11/6/15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ButtonsHolderViewController.h"


@implementation ButtonsHolderViewController


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [super dealloc];
}

-(IBAction) cameraButtonTap:(id)sender {

    UIImagePickerController*
        mediaPicker = [[UIImagePickerController alloc] init];
        mediaPicker.delegate = self;
        mediaPicker.allowsEditing = YES;    
        mediaPicker.sourceType = UIImagePickerControllerSourceTypeCamera;

    [self presentModalViewController:mediaPicker animated:YES];
}

-(IBAction) libraryButtonTap:(id)sender {
    
    UIImagePickerController*
        mediaPicker = [[UIImagePickerController alloc] init];
        mediaPicker.delegate = self;
        mediaPicker.allowsEditing = YES;    
        mediaPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentModalViewController:mediaPicker animated:YES];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo {
    
    UIImage* selectedImage = img;

    [[picker parentViewController] dismissModalViewControllerAnimated:YES];

    ImageMagickWorkspaceViewController*
        imageMagickWorkspaceViewController = [[ImageMagickWorkspaceViewController alloc] initWithNibName:@"ImageMagickWorkspaceViewController" bundle:[NSBundle mainBundle]];
        [imageMagickWorkspaceViewController initHelper:selectedImage];
        imageMagickWorkspaceViewController.delegate = self;
	
	[self.navigationController pushViewController:imageMagickWorkspaceViewController animated:YES];
}

-(void) imageMagickWorkspaceDidFinished:(ImageMagickWorkspaceViewController*)sender {
    
	[self.navigationController popToRootViewControllerAnimated:YES];
}

@end
