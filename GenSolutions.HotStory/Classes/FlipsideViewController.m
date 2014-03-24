
#import "FlipsideViewController.h"


@implementation FlipsideViewController

@synthesize delegate;
@synthesize facebookOnButton;
@synthesize facebookOffButton;


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // self.view.backgroundColor = [UIColor viewFlipsideBackgroundColor];
    
    BOOL facebookSessionValidity  = [[FacebookApi facebook] isSessionValid];
    
    self.facebookOnButton.hidden  = !facebookSessionValidity;
    self.facebookOffButton.hidden = facebookSessionValidity;
}

- (IBAction)done:(id)sender {
	[self.delegate flipsideViewControllerDidFinish:self];	
}

- (IBAction)facebookOn:(id)sender{
    
    [[FacebookApi facebook] logout:self];
    [FacebookApi deleteSavedSession];

    self.facebookOnButton.hidden  = TRUE;
    self.facebookOffButton.hidden = FALSE;
}

- (IBAction)facebookOff:(id)sender{

    [FacebookApi loadSessionWithAuthorize:self];

    self.facebookOnButton.hidden  = FALSE;
    self.facebookOffButton.hidden = TRUE;
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
