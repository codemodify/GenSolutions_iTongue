
#import "UploadToFacebook.h"


@implementation UploadToFacebook

@synthesize delegate;
@synthesize image;
@synthesize uploadedPhotoId;

@synthesize doneButton;
@synthesize facebookUploadPictureView;
@synthesize facebookUploadPostAndAskButton;
@synthesize activityIndicatorView;
@synthesize comment;


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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    facebookUploadPictureView.image = image;
    [activityIndicatorView stopAnimating];
    
    self.comment.delegate = self;
    
    [FacebookApi setDelegate:self];
}

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
    
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    [FacebookApi setDelegate:nil];
}

- (void)dealloc {
    [super dealloc];
    
//    [albumId release];
//    [uploadedPhotoId release];
//    [userPhotoId release];
    
//    if( nil != uploadedPhotoId )
//        [uploadedPhotoId release];
//
//    [image release];
}





- (IBAction)done:(id)sender {
	[self.delegate uploadToFacebookViewControllerDidFinish:self];	
}

-(BOOL) textFieldShouldReturn:(UITextField*) textField{

    [textField resignFirstResponder];
    return TRUE;
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self done:self];
}


// Facebook delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
- (IBAction)facebookUploadPostAndAsk:(id)sender {

    facebookUploadPostAndAskButton.enabled = FALSE;
    [activityIndicatorView startAnimating];

    self.doneButton.enabled = FALSE;
    self.doneButton.highlighted = FALSE;
    self.facebookUploadPostAndAskButton.enabled = FALSE;
    self.facebookUploadPostAndAskButton.highlighted = FALSE;

    [comment resignFirstResponder];
    
    [FacebookApi uploadPicture:self.image withComment:comment.text];
}

-(void) uploadPictureWithCommentDidFinish:(NSString*)pictureId{

    uploadedPhotoId = [[NSString alloc] initWithString:pictureId];
    
    [activityIndicatorView stopAnimating];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Photo upload Success"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert autorelease];
    [alert show];    
}

-(void) uploadPictureWithCommentDidNotFinish:(NSString *)errorMessage{
    
    [activityIndicatorView stopAnimating];
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Photo upload Error"
                                                    message:@"Check your netowrk conneciton or if you're logged into Facebook."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert autorelease];
    [alert show];
    
    self.doneButton.enabled = TRUE;
    self.doneButton.highlighted = TRUE;
    self.facebookUploadPostAndAskButton.enabled = TRUE;
    self.facebookUploadPostAndAskButton.highlighted = TRUE;
}

// Called when a UIServer Dialog successfully return.
- (void)dialogDidComplete:(FBDialog *)dialog {
    NSLog(@"dialogDidComplete()");
}




@end
