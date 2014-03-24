
// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "ScannerViewController.h"

@implementation ScannerViewController

@synthesize panelResult, progress, scanButton, validateButton, cancelButton;


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark Internl Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

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

-(void) moveOverlays:(CGRect)adaptedRct {
    
    int width  = adaptedRct.size.width;
    int height = adaptedRct.size.height;
    
    // Move the overlays to the processing area
    int compensation = 0;
    CGRect tempFrame;
    
    tempFrame = overlayTopLeft.frame;
    tempFrame.origin.x     =   adaptedRct.origin.x                                               - compensation;
    tempFrame.origin.y     =   adaptedRct.origin.y                                               - compensation;
    overlayTopLeft.frame = tempFrame;
    
    tempFrame = overlayTopRight.frame;
    tempFrame.origin.x    = ( adaptedRct.origin.x + width  ) - overlayTopRight.frame.size.width  + compensation;
    tempFrame.origin.y    = ( adaptedRct.origin.y          )                                     - compensation;
    overlayTopRight.frame = tempFrame;
    
    tempFrame = overlayBottomLeft.frame;
    tempFrame.origin.x  =   adaptedRct.origin.x                                                  - compensation;
    tempFrame.origin.y  = ( adaptedRct.origin.y + height ) - overlayBottomLeft.frame.size.height + compensation;
    overlayBottomLeft.frame = tempFrame;
    
    tempFrame = overlayBottomRight.frame;
    tempFrame.origin.x = ( adaptedRct.origin.x + width  ) - overlayBottomRight.frame.size.width  + compensation;
    tempFrame.origin.y = ( adaptedRct.origin.y + height ) - overlayBottomRight.frame.size.height + compensation;
    overlayBottomRight.frame = tempFrame;
    
    // Resize the output image
    imageResult.frame = adaptedRct;
}

-(void) makeOverlaysVisible:(bool)visible {

    overlayTopLeft.hidden = visible;
    overlayTopRight.hidden = visible;
    overlayBottomLeft.hidden = visible;
    overlayBottomRight.hidden = visible;
}

-(void) doubleTapDelegate:(id)ignored {
    
    if( canUpdateImage )
        return;
    
    isCropVisible = !isCropVisible;

    [self makeOverlaysVisible: !isCropVisible ];
}

-(void) panDelegate:(UIPanGestureRecognizer*)gestureRecognizer {

    if( !isCropVisible )
        return;

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
            
            [self moveOverlays:adaptedRect];
            
            previousOWH.origin = point;
            previousOWH.size   = CGSizeMake( width, height );
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
            
            [self moveOverlays:adaptedRect];
            
            previousOWH.origin = point;            
        }

    }
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController overrides
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) viewDidLoad {

    isCropVisible               = false;
    isPanOnOverlayTopLeft       = false;
    isPanOnOverlayTopRight      = false;
    isPanOnOverlayBottonLeft    = false;
    isPanOnOverlayBottonRight   = false;
    previousOWH                 = CGRectZero;
    
    [super viewDidLoad];
    
    [self.view bringSubviewToFront:panelResult];
    
    // gestures
    UITapGestureRecognizer* 
        doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapDelegate:)];
        doubleTap.numberOfTouchesRequired = 1;
        doubleTap.numberOfTapsRequired = 2;
    
    UIPanGestureRecognizer*
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panDelegate:)];
        [pan setMinimumNumberOfTouches:1];
        [pan setMaximumNumberOfTouches:1];
    
    [self.view addGestureRecognizer:doubleTap];
    [self.view addGestureRecognizer:pan];
    
    [doubleTap release];
    [pan release];
}

-(void) dealloc {
    
    [super dealloc];
}

-(BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {

    BOOL supportedOrientation1 = ( interfaceOrientation == UIInterfaceOrientationLandscapeRight );

    return supportedOrientation1;
}

-(void) addBarx:(CGFloat)x
              y:(CGFloat)y
          width:(CGFloat)width
         height:(CGFloat)height {

    UIView* 
        flashViewA = [[UIView alloc] initWithFrame: CGRectMake( x, y, width, height) ];
        [flashViewA setBackgroundColor:[UIColor whiteColor]];
        [flashViewA setAlpha:0.45];
    UIView* 
        flashViewB = [[UIView alloc] initWithFrame: CGRectMake( x, y+height, width, height) ];
        [flashViewB setBackgroundColor:[UIColor whiteColor]];
        [flashViewB setAlpha:0.50f];
    UIView* 
        flashViewC = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*2, width, height) ];
        [flashViewC setBackgroundColor:[UIColor whiteColor]];
        [flashViewC setAlpha:0.55f];
    UIView* 
        flashViewD = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*3, width, height) ];
        [flashViewD setBackgroundColor:[UIColor whiteColor]];
        [flashViewD setAlpha:0.60f];
    UIView* 
        flashViewE = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*4, width, height) ];
        [flashViewE setBackgroundColor:[UIColor whiteColor]];
        [flashViewE setAlpha:0.65f];
    UIView* 
        flashViewF = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*5, width, height) ];
        [flashViewF setBackgroundColor:[UIColor whiteColor]];
        [flashViewF setAlpha:0.70f];
    UIView* 
        flashViewG = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*6, width, height) ];
        [flashViewG setBackgroundColor:[UIColor whiteColor]];
        [flashViewG setAlpha:0.75f];
    UIView* 
        flashViewH = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*7, width, height) ];
        [flashViewH setBackgroundColor:[UIColor whiteColor]];
        [flashViewH setAlpha:0.80f];
    UIView* 
        flashViewI = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*8, width, height) ];
        [flashViewI setBackgroundColor:[UIColor whiteColor]];
        [flashViewI setAlpha:0.85f];
    UIView* 
        flashViewJ = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*9, width, height) ];
        [flashViewJ setBackgroundColor:[UIColor whiteColor]];
        [flashViewJ setAlpha:0.90f];
    UIView*
        flashViewK = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*10, width, height) ];
        [flashViewK setBackgroundColor:[UIColor whiteColor]];
        [flashViewK setAlpha:0.95f];
    UIView*
        flashViewL = [[UIView alloc] initWithFrame: CGRectMake( x, y+height*11, width, height) ];
        [flashViewL setBackgroundColor:[UIColor whiteColor]];
        [flashViewL setAlpha:1.00f];
    
    [[self.view window] addSubview:flashViewA];
    [[self.view window] addSubview:flashViewB];
    [[self.view window] addSubview:flashViewC];
    [[self.view window] addSubview:flashViewD];
    [[self.view window] addSubview:flashViewE];
    [[self.view window] addSubview:flashViewF];
    [[self.view window] addSubview:flashViewG];
    [[self.view window] addSubview:flashViewH];
    [[self.view window] addSubview:flashViewI];
    [[self.view window] addSubview:flashViewJ];
    [[self.view window] addSubview:flashViewK];
    [[self.view window] addSubview:flashViewL];

    [UIView animateWithDuration:0.001f
                     animations:^{

                         [flashViewA setAlpha:0.40];
                         [flashViewB setAlpha:0.45];
                         [flashViewC setAlpha:0.50];
                         [flashViewD setAlpha:0.55];
                         [flashViewE setAlpha:0.60];
                         [flashViewF setAlpha:0.65];
                         [flashViewG setAlpha:0.70];
                         [flashViewH setAlpha:0.75];
                         [flashViewI setAlpha:0.80];
                         [flashViewJ setAlpha:0.85];
                         [flashViewK setAlpha:0.90];
                         [flashViewL setAlpha:0.95];
                     }
                     completion:^(BOOL finished){
                         [flashViewA removeFromSuperview]; [flashViewA release];
                         [flashViewB removeFromSuperview]; [flashViewB release];
                         [flashViewC removeFromSuperview]; [flashViewC release];
                         [flashViewD removeFromSuperview]; [flashViewD release];
                         [flashViewE removeFromSuperview]; [flashViewE release];
                         [flashViewF removeFromSuperview]; [flashViewF release];
                         [flashViewG removeFromSuperview]; [flashViewG release];
                         [flashViewH removeFromSuperview]; [flashViewH release];
                         [flashViewI removeFromSuperview]; [flashViewI release];
                         [flashViewJ removeFromSuperview]; [flashViewJ release];
                         [flashViewK removeFromSuperview]; [flashViewK release];
                         [flashViewL removeFromSuperview]; [flashViewL release];

                         if( y < self.view.frame.size.height-height*7) {  // height
                             [self addBarx:x y:(y+height*2) width:width height:height];
                         }
                     }
     ];
}

#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UI controls
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(IBAction) showHelp:(id)sender {
    
    InfoViewController* 
        controller = [[InfoViewController alloc] initForContext:HelpInfoScanner];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:controller animated:YES];
        [controller release];
}

-(IBAction) scan:(id)sender {

    canUpdateImage = false;

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
    
    scanButton.hidden = TRUE;
    
    validateButton.hidden = FALSE;
    cancelButton.hidden = FALSE;
    
//    CGFloat width  = self.view.frame.size.width;
//    CGFloat yInc = 3.0;
//    CGFloat x = 0;
//    CGFloat y = 0;
//
//    [self addBarx:x y:y width:width height:yInc];
}

-(IBAction) translate:(id)sender {

    translateTapped = true;
    
    validateButton.hidden = TRUE;
    cancelButton.hidden = TRUE;

    progress.center = CGPointMake
    (
        overlayTopLeft.frame.origin.x + ( ( overlayTopRight.frame.origin.x   + overlayTopRight.frame.size.width    - overlayTopLeft.frame.origin.x ) / 2 ),
        overlayTopLeft.frame.origin.y + ( ( overlayBottomLeft.frame.origin.y + overlayBottomLeft.frame.size.height - overlayTopLeft.frame.origin.y ) / 2 )
    );
    progress.hidden = FALSE;

    ocrThreadFinished = false;
    UIImage* image = [[UIImage imageWithCGImage:_image] retain];

    if( isCropVisible ) {

        CGRect 
            cropRect;
            cropRect.origin = overlayTopLeft.frame.origin;
            cropRect.size   = CGSizeMake
            (
                overlayBottomRight.frame.origin.x + overlayBottomRight.frame.size.width  - overlayTopLeft.frame.origin.x,
                overlayBottomRight.frame.origin.y + overlayBottomRight.frame.size.height - overlayTopLeft.frame.origin.y
            );

        [image release];
        
        UIImage* imageCopy = [[UIImage alloc] initWithCGImage:_image];

        image = [[self croppedImage:imageCopy fromRect:cropRect] retain];

        [imageCopy release];
    }

    [self performSelectorInBackground:@selector(theMethod:) withObject: image ];    
}

-(IBAction) cancel:(id)sender {
    
    scanButton.hidden = FALSE;
    
    imageResult.hidden = TRUE;
    validateButton.hidden = TRUE;
    cancelButton.hidden = TRUE;
    
    canUpdateImage = true;
    
    isCropVisible = false;
    [self makeOverlaysVisible: !isCropVisible ];
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark CameraApi Delegates
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) imageAvailable:(CGImageRef)image {

    [super imageAvailable:image];

    if( ocrThreadFinished && translateTapped && !canUpdateImage ) {

        TextViewController*
            controller = [[TextViewController alloc] initWithNibName:@"TextView" bundle:nil];
            controller.delegate = self;
            controller.image = [[UIImage alloc] initWithCGImage:_image];
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
    
    canUpdateImage = true;

    translateTapped = false;
    
    scanButton.hidden = FALSE;
    
    progress.hidden = TRUE;
    validateButton.hidden = TRUE;
    cancelButton.hidden = TRUE;
    
    isCropVisible = false;
    [self makeOverlaysVisible: !isCropVisible ];
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
