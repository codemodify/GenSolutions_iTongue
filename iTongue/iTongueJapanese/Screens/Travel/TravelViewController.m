
// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "TravelViewController.h"

@implementation TravelViewController

@synthesize panelResult, progress, cameraButton;


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark Internl Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) updateZoom {

    CGFloat xZoom = 0.0;
    CGFloat yZoom = 0.0;

    switch( _zoom ) {

        case eFourX:
            xZoom = ( oneXzoomSize.size.width  / 2 );
            yZoom = ( oneXzoomSize.size.height / 2 );
            break;

        case eThreeX:
            xZoom = ( oneXzoomSize.size.width  / 3 );
            yZoom = ( oneXzoomSize.size.height / 3 );
            break;

        case eTwoX:
            xZoom = ( oneXzoomSize.size.width  / 4 );
            yZoom = ( oneXzoomSize.size.height / 4 );
            break;

        case eOneX:

            xZoom = 0;
            yZoom = 0;
            break;

        default:
            break;
    }

    rectToCopy.origin.x    = oneXzoomSize.origin.x    + xZoom;
    rectToCopy.origin.y    = oneXzoomSize.origin.y    + yZoom;
    rectToCopy.size.width  = oneXzoomSize.size.width  - xZoom;
    rectToCopy.size.height = oneXzoomSize.size.height - yZoom;
}

-(bool) isInRangeOfPoint:(CGPoint)point pointToCheck:(CGPoint)pointToCheck{
    
    CGFloat radius = 30.0;
    
    if
    ( 
         ( (point.x - radius) < pointToCheck.x ) && ( pointToCheck.x < (point.x + radius) )
         &&
         ( (point.y - radius) < pointToCheck.y ) && ( pointToCheck.y < (point.y + radius) )
    )
        return true;
    
    return false;
}

-(void) moveOverlays:(CGRect)adaptedRect {
    
    int width  = adaptedRect.size.width;
    int height = adaptedRect.size.height;
    
    // Move the overlays to the processing area
    int compensation = 0;
    CGRect tempFrame;
    
    tempFrame = overlayTopLeft.frame;
    tempFrame.origin.x     =   adaptedRect.origin.x                                               - compensation;
    tempFrame.origin.y     =   adaptedRect.origin.y                                               - compensation;
    overlayTopLeft.frame = tempFrame;
    
    tempFrame = overlayTopRight.frame;
    tempFrame.origin.x    = ( adaptedRect.origin.x + width  ) - overlayTopRight.frame.size.width  + compensation;
    tempFrame.origin.y    = ( adaptedRect.origin.y          )                                     - compensation;
    overlayTopRight.frame = tempFrame;
    
    tempFrame = overlayBottomLeft.frame;
    tempFrame.origin.x  =   adaptedRect.origin.x                                                  - compensation;
    tempFrame.origin.y  = ( adaptedRect.origin.y + height ) - overlayBottomLeft.frame.size.height + compensation;
    overlayBottomLeft.frame = tempFrame;
    
    tempFrame = overlayBottomRight.frame;
    tempFrame.origin.x = ( adaptedRect.origin.x + width  ) - overlayBottomRight.frame.size.width  + compensation;
    tempFrame.origin.y = ( adaptedRect.origin.y + height ) - overlayBottomRight.frame.size.height + compensation;
    overlayBottomRight.frame = tempFrame;
    
    // Resize the output image
    CGFloat deltaPixels      = 15.0;
    adaptedRect.origin.x    += deltaPixels;
    adaptedRect.origin.y    += deltaPixels;
    adaptedRect.size.width  -= deltaPixels*2;
    adaptedRect.size.height -= deltaPixels*2;

    imageResult.frame = adaptedRect;
    
    CGFloat yShift = 30.0;
    rectToCopy = adaptedRect;
    rectToCopy.origin.y += yShift;
    
    oneXzoomSize = rectToCopy;
    
    [self updateZoom];
}

-(void) panDelegate:(UIPanGestureRecognizer*)gestureRecognizer {

    if( false );

    else if( gestureRecognizer.state == UIGestureRecognizerStateBegan ) {

        previousOWH.origin          = [gestureRecognizer locationInView:[gestureRecognizer view]];
        previousOWH.size.width      = (overlayTopRight.frame.origin.x   + overlayTopRight.frame.size.width   ) - overlayTopLeft.frame.origin.x;
        previousOWH.size.height     = (overlayBottomLeft.frame.origin.y + overlayBottomLeft.frame.size.height) - overlayTopLeft.frame.origin.y;

        isPanOnOverlayTopLeft       = [self isInRangeOfPoint:CGPointMake(overlayTopLeft.frame.origin.x    +30                                     , overlayTopLeft.frame.origin.y     +30                                     ) pointToCheck:previousOWH.origin];
        isPanOnOverlayTopRight      = [self isInRangeOfPoint:CGPointMake(overlayTopRight.frame.origin.x   -30+overlayTopRight.frame.size.width    , overlayTopRight.frame.origin.y    +30                                     ) pointToCheck:previousOWH.origin];
        isPanOnOverlayBottonLeft    = [self isInRangeOfPoint:CGPointMake(overlayBottomLeft.frame.origin.x +30                                     , overlayBottomLeft.frame.origin.y  -30+overlayBottomLeft.frame.size.height ) pointToCheck:previousOWH.origin];
        isPanOnOverlayBottonRight   = [self isInRangeOfPoint:CGPointMake(overlayBottomRight.frame.origin.x-30+overlayBottomRight.frame.size.width , overlayBottomRight.frame.origin.y -30+overlayBottomRight.frame.size.height) pointToCheck:previousOWH.origin];
    }

    else if( gestureRecognizer.state == UIGestureRecognizerStateEnded ) {

        isPanOnOverlayTopLeft       = false;
        isPanOnOverlayTopRight      = false;
        isPanOnOverlayBottonLeft    = false;
        isPanOnOverlayBottonRight   = false;
    }

    else if( gestureRecognizer.state == UIGestureRecognizerStateChanged ) {

        if( isPanOnOverlayTopLeft || isPanOnOverlayTopRight || isPanOnOverlayBottonLeft || isPanOnOverlayBottonRight ) {

            CGPoint point = [gestureRecognizer locationInView:[gestureRecognizer view]];

            //     y1                           y2
            //  x1 o -------------------------- o x2
            //     |                            |
            //     |                            |
            //     |                            |
            //     |                            |
            //  x3 o -------------------------- o x4
            //     y3                           y4

            CGFloat deltaX = point.x - previousOWH.origin.x;
            CGFloat deltaY = point.y - previousOWH.origin.y;

            CGFloat x      = 0.0;
            CGFloat y      = 0.0;
            CGFloat width  = 0.0;
            CGFloat height = 0.0;

            if( false );

            else if( isPanOnOverlayTopLeft ){

                x      = overlayTopLeft.frame.origin.x + deltaX;
                y      = overlayTopLeft.frame.origin.y + deltaY;
                width  = previousOWH.size.width        - deltaX;
                height = previousOWH.size.height       - deltaY;
            }
            else if( isPanOnOverlayTopRight ) {
                
                x      = overlayTopLeft.frame.origin.x + 0;
                y      = overlayTopLeft.frame.origin.y + deltaY;
                width  = previousOWH.size.width        + deltaX;
                height = previousOWH.size.height       - deltaY;
            }
            else if( isPanOnOverlayBottonLeft ) {
                
                x      = overlayTopLeft.frame.origin.x + deltaX;
                y      = overlayTopLeft.frame.origin.y + 0;
                width  = previousOWH.size.width        - deltaX;
                height = previousOWH.size.height       + deltaY;
            }
            else if( isPanOnOverlayBottonRight ) {
                
                x      = overlayTopLeft.frame.origin.x + 0;
                y      = overlayTopLeft.frame.origin.y + 0;
                width  = previousOWH.size.width        + deltaX;
                height = previousOWH.size.height       + deltaY;
            }
            
            CGRect
                adaptedRect;
                adaptedRect.origin.x    = x;
                adaptedRect.origin.y    = y;
                adaptedRect.size.width  = width;
                adaptedRect.size.height = height;

            if( adaptedRect.origin.x < 0 )
                adaptedRect.origin.x = 0;

            if( adaptedRect.origin.y < 0 )
                adaptedRect.origin.y = 0;

            if( adaptedRect.origin.x + adaptedRect.size.width > 480 )  // AVCaptureSessionPresetMedium == 480 x 360
                adaptedRect.size.width = 480 - adaptedRect.origin.x - 1;

            if( adaptedRect.origin.y + adaptedRect.size.height > 320 ) // AVCaptureSessionPresetMedium == 480 x 360
                adaptedRect.size.height = 320 - adaptedRect.origin.y - 1;

            previousOWH.origin = point;
            previousOWH.size   = CGSizeMake( width, height );

            [self moveOverlays:adaptedRect];
        }
        
        else {
            
            CGPoint point = [gestureRecognizer locationInView:[gestureRecognizer view]];
            
            CGFloat x1 = overlayTopLeft.frame.origin.x;
            CGFloat x2 = point.x-previousOWH.origin.x;
            
            CGFloat y1 = overlayTopLeft.frame.origin.y;
            CGFloat y2 = point.y-previousOWH.origin.y;
            
            CGRect 
                adaptedRect;
                adaptedRect.origin.x = x1 + x2;
                adaptedRect.origin.y = y1 + y2;
                adaptedRect.size     = previousOWH.size;
            
            if( adaptedRect.origin.x < 0 )
                adaptedRect.origin.x = 0;
            
            if( adaptedRect.origin.y < 0 )
                adaptedRect.origin.y = 0;
            
            if( adaptedRect.origin.x + adaptedRect.size.width > 480 )  // AVCaptureSessionPresetMedium == 480 x 360
                adaptedRect.origin.x = overlayTopLeft.frame.origin.x;
            
            if( adaptedRect.origin.y + adaptedRect.size.height > 320 ) // AVCaptureSessionPresetMedium == 480 x 360
                adaptedRect.origin.y = overlayTopLeft.frame.origin.y;
            
            previousOWH.origin = point;
            
            [self moveOverlays:adaptedRect];
        }
        
    }
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController overrides
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) viewDidLoad {

    _zoom = eOneX;
    
    canUpdateImageCopy = true;
    
    isPanOnOverlayTopLeft       = false;
    isPanOnOverlayTopRight      = false;
    isPanOnOverlayBottonLeft    = false;
    isPanOnOverlayBottonRight   = false;
    previousOWH                 = CGRectZero;
    
    isFlashOn = FALSE;
    
//    [self updateZoom];
    
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:panelResult];
    
    // gestures
    UIPanGestureRecognizer*
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDelegate:)];
        [pan setMinimumNumberOfTouches:1];
        [pan setMaximumNumberOfTouches:1];
    
    [self.view addGestureRecognizer:pan];
    
    [pan release];
}

-(void) dealloc {
    
    [super dealloc];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    
    BOOL supportedOrientation1 = ( interfaceOrientation == UIInterfaceOrientationLandscapeRight );
    
    return supportedOrientation1;
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UI controls
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(IBAction) showHelp:(id)sender{

    InfoViewController* 
        controller = [[InfoViewController alloc] initForContext:HelpInfoTravel];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        [controller release];
}

-(IBAction) changeZoom:(id)sender {

    UISegmentedControl* segmentedControl = (UISegmentedControl*)sender;

    _zoom = [segmentedControl selectedSegmentIndex];

    [self updateZoom];
}

-(IBAction) ocr:(id)sender {

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

    canUpdateImageCopy = false;
    translateTapped    = true;

    progress.center = CGPointMake
    (
        overlayTopLeft.frame.origin.x + ( ( overlayTopRight.frame.origin.x   + overlayTopRight.frame.size.width    - overlayTopLeft.frame.origin.x ) / 2 ),
        overlayTopLeft.frame.origin.y + ( ( overlayBottomLeft.frame.origin.y + overlayBottomLeft.frame.size.height - overlayTopLeft.frame.origin.y ) / 2 )
    );
    progress.hidden    = FALSE;

    ocrThreadFinished  = false;

    UIImage* image = [[UIImage imageWithCGImage:[imageResult.image CGImage]] retain];
    [self performSelectorInBackground:@selector(theMethod:) withObject: image ];
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

    [super imageAvailable:image];

    if( canUpdateImageCopy ) {

        UIImage* largeImage = [UIImage imageWithCGImage:image];
        
        UIImage* smallImage = [self croppedImage:largeImage fromRect:rectToCopy];
        
        [imageResult setImage:smallImage];        
    }

    else if( ocrThreadFinished && translateTapped ) { // && !canUpdateImageCopy

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


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark TextView Delegates
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) textViewControllerDelegateDidFinish:(TextViewController*)controller {
    
    canUpdateImageCopy   = true;
    translateTapped      = false;
    progress.hidden      = TRUE;
    cameraButton.enabled = true;
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
