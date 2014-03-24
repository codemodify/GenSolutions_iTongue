
#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize facebookSwitch;
@synthesize tweeterSwitch;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    if( [[FacebookApi facebook] isSessionValid] ){
        
        facebookSwitch.on = TRUE;
    }        
}


- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)facebookOnOff:(id)sender {

//    NSLog(@"--BEGIN-----------------------------------------------------");
//    NSLog([FacebookApi faceBook_GenSoltions_GiftPicker_ApplicationID]);
//    NSLog([FacebookApi faceBook_GenSoltions_GiftPicker_ApiKey]);
//    NSLog([FacebookApi faceBook_GenSoltions_GiftPicker_ApplicationSecret]);
//    NSLog(@"--END-----------------------------------------------------");
    
    UISwitch* onOffButton = (UISwitch*)sender;

    if( onOffButton.on ){

        [FacebookApi loadSessionWithAuthorize:self];
    }
    else {

        [[FacebookApi facebook] logout:self];
        [FacebookApi deleteSavedSession];
    }
}

- (IBAction)twitterOnOff:(id)sender {
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)dealloc {
    [super dealloc];
}


// Facebook delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

- (void)fbDidLogin {

    [[NSUserDefaults standardUserDefaults] setObject:[FacebookApi facebook].accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:[FacebookApi facebook].expirationDate forKey:@"ExpirationDate"];
}

-(void)fbDidNotLogin:(BOOL)cancelled {
}

- (void)fbDidLogout {
}


@end
