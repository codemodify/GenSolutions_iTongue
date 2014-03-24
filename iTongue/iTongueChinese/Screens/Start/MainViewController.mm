
// Helper Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import <GenSolutions/GenSolutions.Api.Logger/Logger.h>

// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "MainViewController.h"

#import "BookViewController.h"
#import "TravelViewController.h"
#import "ScannerViewController.h"

#import "OcrApi.h"
#import "CameraApi.h"

// Class Implementation
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@implementation MainViewController

static OcrApi* ocrApi = nil;
static CameraApi* cameraApi = nil;


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

/*
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {

	[self dismissModalViewControllerAnimated:YES];
}

/*
- (IBAction)showSettings:(id)sender {

	FlipsideViewController*
        controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
        controller.delegate = self;
		controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
		[controller release];
}

- (void) dumpDirectoryContent:(NSString*)path {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError* error;
    NSArray* dirContent = [fileManager contentsOfDirectoryAtPath:path error:&error];
    
    if( 0 != [dirContent count] ){
        
        for( NSString* fileName in dirContent ) {
            
            NSString* fullFilePath = [ [NSString alloc] initWithFormat:@"%@/%@", path, fileName ];
            
            [Logger logInfo:fullFilePath];

            [fullFilePath release];
        }
    }
}
*/

-(void) cameraViewControllerDelegateDidFinish:(CameraViewController*)controller {
    
    [[UIApplication sharedApplication] setStatusBarHidden:FALSE withAnimation:UIStatusBarAnimationFade];
    
    ocrApi = controller.ocrApi;
    
	[self dismissModalViewControllerAnimated:YES];
}

-(void) textViewControllerDelegateDidFinish:(TextViewController*)controller {

    [self dismissModalViewControllerAnimated:YES];
}

-(void) infoViewControllerDelegateDidFinish:(InfoViewController*)controller {
    
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController Overrides
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

- (void) viewDidLoad {

	[super viewDidLoad];

    cameraApi = [[CameraApi alloc] init];
}

- (void) viewDidUnload {
}

- (void) didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

- (void) dealloc {

    [ocrApi release];
    [cameraApi release];
    
    [super dealloc];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    BOOL supportedOrientation1 = ( interfaceOrientation == UIInterfaceOrientationPortrait );
    
    return supportedOrientation1;
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UI Controls Handlers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
-(void) actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if( buttonIndex == 0 ) { // OK pressed
        
        // reinit tessaract
    }
}

-(IBAction) showHelp:(id)sender {
    
    InfoViewController* 
        controller = [[InfoViewController alloc] initForContext:HelpInfoHome];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        [controller release];
}

-(IBAction) showBookMode:(id)sender {

    [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
    
	BookViewController*
        controller = [[BookViewController alloc] initWithNibName:@"BookView" bundle:nil];
        controller.ocrApi = ocrApi;
        controller.cameraApi = cameraApi;
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

	[self presentModalViewController:controller animated:YES];

	[controller release];
}

-(IBAction) showTravelMode:(id)sender {
    
    [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];
    
	TravelViewController*
        controller = [[TravelViewController alloc] initWithNibName:@"TravelView" bundle:nil];
        controller.ocrApi = ocrApi;
        controller.cameraApi = cameraApi;
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;

	[self presentModalViewController:controller animated:YES];
    
	[controller release];
}

-(IBAction) showScannerMode:(id)sender{

    [[UIApplication sharedApplication] setStatusBarHidden:TRUE withAnimation:UIStatusBarAnimationFade];

	ScannerViewController*
        controller = [[ScannerViewController alloc] initWithNibName:@"ScannerView" bundle:nil];
        controller.ocrApi = ocrApi;
        controller.cameraApi = cameraApi;
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
	[self presentModalViewController:controller animated:YES];
    
	[controller release];    
}

-(IBAction) showTextMode:(id)sender{
    
	TextViewController*
        controller = [[TextViewController alloc] initWithNibName:@"TextView" bundle:nil];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
	[self presentModalViewController:controller animated:YES];
    
	[controller release];    
}

@end
