
// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "BookViewController.h"

@implementation BookViewController

@synthesize progress, panelResult, cameraButton;


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark Internl Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) updateBookMode {

    // iPhone 3Gs + iPhone 4 == AVCaptureSessionPresetMedium == 480 x 360
    
    //CGFloat capturedImageWidth  = 480.0;
    //CGFloat capturedImageHeight = 360.0;
    
    CGFloat overlaysWidth   = 0.0;
    CGFloat overlaysHeight  = 0.0;

    switch( _bookMode ) {
            
        case eWord:
            overlaysWidth  = 250;
            overlaysHeight = 60;
            break;
            
        case eLine:
            overlaysWidth  = 480;
            overlaysHeight = 60;
            break;
            
        case eParagraph:
            overlaysWidth  = 480;
            overlaysHeight = 140;
            break;
            
        default:
            break;
    }
    
    [self setImageProcessingWidth:overlaysWidth AndHeight:overlaysHeight];
    [self moveOverlaysWidth:overlaysWidth AndHeight:overlaysHeight];
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController overrides
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) viewDidLoad {

    _bookMode = eWord;
    
    canUpdateImageCopy = false;
    
    isFlashOn = FALSE;
    
    [self updateBookMode];
    
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:panelResult];
}

- (void) dealloc {
    
    [super dealloc];

}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    BOOL supportedOrientation1 = ( interfaceOrientation == UIInterfaceOrientationLandscapeRight );

    return supportedOrientation1;
}



#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController overrides
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(IBAction) showHelp:(id)sender{
    
    InfoViewController* 
        controller = [[InfoViewController alloc] initForContext:HelpInfoBook];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        [controller release];
}

-(IBAction) changeBookMode:(id)sender {

    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;

    // _bookMode = ( _bookMode == eBookModeEnd ) ? eBookModeStart : ( _bookMode + 1 );
    _bookMode = [segmentedControl selectedSegmentIndex];

    [self updateBookMode];
}

-(IBAction) ocr:(id)sender {

    @synchronized( self ) {

        cameraButton.enabled = false;
        
        UIView* flashView = [[UIView alloc] initWithFrame:self.view.frame];
        [flashView setBackgroundColor:[UIColor whiteColor]];
        [flashView setAlpha:0.f];
        
        [[self.view window] addSubview:flashView];
        
        [UIView animateWithDuration:.4f
                         animations:^{
                             [flashView setAlpha:1.f];
                             [flashView setAlpha:0.f];
                         }
                         completion:^(BOOL finished){
                             [flashView removeFromSuperview];
                             [flashView release];
                         }
         ];    
        
        canUpdateImageCopy  = true;
        translateTapped     = true;

        imageResult.hidden  = FALSE;
        progress.hidden     = FALSE;

        ocrThreadFinished   = false;
    }
}

-(IBAction) turnFlashOnOff:(id)sender {
    
    isFlashOn = !isFlashOn;
    
    if( isFlashOn )
        [cameraApi turnFlashOn];
    else 
        [cameraApi turnFlashOff];
}



#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark CameraApi Delegates
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) imageAvailable:(CGImageRef)image {

    @synchronized( self ) {

        [super imageAvailable:image];

        if( canUpdateImageCopy ) {

            canUpdateImageCopy = false;

            UIImage* largeImage = [UIImage imageWithCGImage:image];
            
            UIImage* smallImage = [self croppedImage:largeImage fromRect:rectToCopy];
            
            [imageResult setImage:smallImage];
            
            UIImage* image = [[UIImage imageWithCGImage:[imageResult.image CGImage]] retain];
            [self performSelectorInBackground:@selector(theMethod:) withObject: image];  
        }

        else if( ocrThreadFinished && translateTapped ) {

            TextViewController*
                controller = [[TextViewController alloc] initWithNibName:@"TextView" bundle:nil];
                controller.delegate = self;
                controller.image = [imageResult.image retain];
                controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                [controller autoTranslate];

            [self presentModalViewController:controller animated:YES];
            controller.textSource.text = textFromImage;

            [controller release];            
        }
    }
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark TextView Delegates
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) textViewControllerDelegateDidFinish:(TextViewController*)controller {
    
    translateTapped = false;
    
    progress.hidden = TRUE;
    imageResult.hidden  = TRUE;
    
    cameraButton.enabled = true;
    
    [self dismissModalViewControllerAnimated:YES];
    
    // languages
    [self loadSettings];
    [self setSourceLanguages];    
}


@end
