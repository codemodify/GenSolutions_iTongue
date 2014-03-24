
// Local Libraries
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#import "BookViewController.h"
#import "OcrApi.h"
//#import "ASIFormDataRequest.h"
#import "LanguagePickerViewDataSource.h"
#import <GenSolutions/GenSolutions.Api.ImageMagick/ImageMagick.h>


@implementation CameraViewController

@synthesize ocrApi;
@synthesize cameraApi;
@synthesize delegate;
@synthesize lastAcceleration;
@synthesize imageResult, overlayTopLeft, overlayTopRight, overlayBottomLeft, overlayBottomRight;
@synthesize sourceLanguageImage, sourceLanguageLabel, destinationLanguageImage, destinationLanguageLabel;


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark Global Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

- (NSString*) applicationDocumentsDirectory {

    NSArray* paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );
    
    NSString* basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : @"";
    
    return basePath;
}

-(OcrInputLanguage) getTongueLanguageCodeAsOcrApiInputLanguage:(NSString*)languageCode {

    if( [languageCode isEqualToString:@"zh-CN"] )
        return OcrInputLanguageChinese;

    else if( [languageCode isEqualToString:@"de"] )
        return OcrInputLanguageGerman;
    
    else if( [languageCode isEqualToString:@"en"] )
        return OcrInputLanguageEnglish;
        
    else if( [languageCode isEqualToString:@"fr"] )
        return OcrInputLanguageFrench;
    
    else if( [languageCode isEqualToString:@"it"] )
        return OcrInputLanguageItalian;
        
    else if( [languageCode isEqualToString:@"ja"] )
        return OcrInputLanguageJapanese;
        
    else if( [languageCode isEqualToString:@"pt"] )
        return OcrInputLanguagePortuguese;

    else if( [languageCode isEqualToString:@"ru"] )
        return OcrInputLanguageRussian;
    
    else if( [languageCode isEqualToString:@"es"] )
        return OcrInputLanguageSpanish;

    return OcrInputLanguageEnglish;
}

-(void) initTessaract:(id)sender {
    
    if( ocrApi != nil ) {
        
        [ocrApi release];
        ocrApi = nil;
    }

    NSDictionary* sourceLanguages = [TextViewController getInputLanguages];
    NSString* sourceLanguageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:sourceLanguages index:sourceLanguageIndex];
    [sourceLanguages release];

    // Set up the tessdata path. This is included in the application bundle but is copied to the Documents directory on the first run
    NSString* tessdataPath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"tessdata"];
    {
        // If the expected store doesn't exist, copy the default store.
        NSFileManager* fileManager = [NSFileManager defaultManager];
        if( ![fileManager fileExistsAtPath:tessdataPath] ) {
            
            NSString *bundlePath = [[NSBundle mainBundle] bundlePath]; // get the path to the app bundle (with the tessdata dir)
            
            NSString *tessdataBundlePath = [bundlePath stringByAppendingPathComponent:@"tessdata.bundle"];
            if( tessdataBundlePath ) {
                [fileManager copyItemAtPath:tessdataBundlePath toPath:tessdataPath error:NULL];
            }
        }
    }

    ocrApi = [[OcrApi alloc] initWithDataPath:tessdataPath andInputLanguage:[self getTongueLanguageCodeAsOcrApiInputLanguage:sourceLanguageCode]];
    [ocrApi setCurrentLanguage:sourceLanguageCode];
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark Internl Helpers
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) theMethod:(id)image {

    @synchronized( self ) {
        
        NSString* text = [self extractTextFromImage:image];
        
        [textFromImage setString: text];

        [text release];
        
        [image release];

        ocrThreadFinished = true;
    }
}

-(UIImage*) croppedImage:(UIImage*)image fromRect:(CGRect)fromRect{
    
    CGImageRef imageRef = CGImageCreateWithImageInRect( [image CGImage], fromRect );
    UIImage* crop = [UIImage imageWithCGImage:imageRef]; 
    CGImageRelease( imageRef );
    
    return crop;
}

-(CGImageRef) rotatedCGImageByAngle:(CGImageRef)imgRef angle:(CGFloat)angle {
    
    CGFloat angleInRadians = angle * (M_PI / 180);
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGRect imgRect = CGRectMake(0, 0, width, height);
    CGAffineTransform transform = CGAffineTransformMakeRotation(angleInRadians);
    CGRect rotatedRect = CGRectApplyAffineTransform(imgRect, transform);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef bmContext = CGBitmapContextCreate(NULL,
                                                   rotatedRect.size.width,
                                                   rotatedRect.size.height,
                                                   8,
                                                   0,
                                                   colorSpace,
                                                   kCGImageAlphaPremultipliedFirst);
    CGContextSetAllowsAntialiasing(bmContext, FALSE);
    CGContextSetInterpolationQuality(bmContext, kCGInterpolationNone);
    CGColorSpaceRelease(colorSpace);
    CGContextTranslateCTM(bmContext,
                          +(rotatedRect.size.width/2),
                          +(rotatedRect.size.height/2));
    CGContextRotateCTM(bmContext, angleInRadians);
    CGContextTranslateCTM(bmContext,
                          -(rotatedRect.size.width/2),
                          -(rotatedRect.size.height/2));
    CGContextDrawImage(bmContext, CGRectMake(0, 0,
                                             rotatedRect.size.width,
                                             rotatedRect.size.height),
                       imgRef);
    
    CGImageRef rotatedImage = CGBitmapContextCreateImage(bmContext);
    CFRelease(bmContext);
    [(id)rotatedImage autorelease];
    
    return rotatedImage;
}


//-(void) uploadImage:(UIImage*)image andText:(NSString*)text {
//
//    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"file"];
//
//	NSData*
//        imageData = UIImageJPEGRepresentation( image, 90 );
//        [imageData writeToFile:path atomically:NO];
//	
//    ASIFormDataRequest*
//        formDataRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:@"http://debugitongue.p4pcdn.com/post.php"]];
//        [formDataRequest setPostValue:text forKey:@"text"];
//        [formDataRequest setTimeOutSeconds:20];
//
//        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
//        [formDataRequest setShouldContinueWhenAppEntersBackground:YES];
//        #endif
//        [formDataRequest setFile:path forKey:@"img"];
//        [formDataRequest startSynchronous];
//}


-(void) saveSettings {

    NSNumber* sourceLanguageIndexAsNumber = [NSNumber numberWithInt:sourceLanguageIndex];
    NSNumber* destinationLanguageIndexAsNumber = [NSNumber numberWithInt:destinationLanguageIndex];

    [[NSUserDefaults standardUserDefaults] setObject:sourceLanguageIndexAsNumber forKey:@"sourceLanguageIndex"];
    [[NSUserDefaults standardUserDefaults] setObject:destinationLanguageIndexAsNumber forKey:@"destinationLanguageIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

-(void) loadSettings {
    
    sourceLanguageIndex      = [(NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:@"sourceLanguageIndex"] intValue];
    destinationLanguageIndex = [(NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:@"destinationLanguageIndex"] intValue];
    isOfflineTranslationMode  = [(NSNumber*) [[NSUserDefaults standardUserDefaults] objectForKey:@"isOfflineTranslationMode"] intValue];
    
    if( sourceLanguageIndex <= 0 )
        sourceLanguageIndex = 0; // English
    
    if( destinationLanguageIndex <= 0 )
        destinationLanguageIndex = 0; // French
}

-(void) setSourceLanguages {

    NSDictionary* sourceLanguages = [TextViewController getInputLanguages];
//    NSDictionary* destinationLanguages = [TextViewController getOutputLanguages];
    NSDictionary* destinationLanguages = isOfflineTranslationMode ? sourceLanguages :  [TextViewController getOutputLanguages];

    NSString* sourceLanguageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:sourceLanguages index:sourceLanguageIndex];
    NSString* destinationLanguageCode = [LanguagePickerViewDataSource getSelectedLanguageCode:destinationLanguages index:destinationLanguageIndex];

    NSString* sourceLanguageText = [LanguagePickerViewDataSource getSelectedLanguageLabel:sourceLanguages index:sourceLanguageIndex];
    NSString* destinationLanguageText = [LanguagePickerViewDataSource getSelectedLanguageLabel:destinationLanguages index:destinationLanguageIndex];

    sourceLanguageButton.imageView.image = [LanguagePickerViewDataSource getImageByCode:sourceLanguageCode];
    destinationLanguageButton.imageView.image = [LanguagePickerViewDataSource getImageByCode:destinationLanguageCode];

    
    [sourceLanguageLabel setTitle:@"_______________" forState:UIControlStateNormal];
    [destinationLanguageLabel setTitle:@"_______________"  forState:UIControlStateNormal];

    [sourceLanguageLabel setTitle:sourceLanguageText forState:UIControlStateNormal];
    [destinationLanguageLabel setTitle:destinationLanguageText  forState:UIControlStateNormal];

    [sourceLanguages release];
    if( !isOfflineTranslationMode )
        [destinationLanguages release];

    if( ![[ocrApi getCurrentLanguage] isEqualToString:sourceLanguageCode] ){
        
        [self initTessaract:nil];
    }
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UIViewController overrides
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) viewDidLoad {
    
    [super viewDidLoad];
    
    translateTapped   = false;
    ocrThreadFinished = true;
    canUpdateImage    = true;
//    isImageInUse      = false;

//    imageSaturate = [[ImageSaturate alloc] init];

    textFromImage = [[NSMutableString alloc] init];

    // languages
    [self loadSettings];
    [self setSourceLanguages];

    // preview layer
    _previewLayer = [CALayer layer];
    _previewLayer.frame = self.view.bounds;
    //_previewLayer.transform = CATransform3DRotate( CATransform3DIdentity, M_PI/2.0f, 0, 0, 1 );
    _previewLayer.contentsGravity = kCAGravityResizeAspectFill;
	[self.view.layer addSublayer:_previewLayer];
}

-(void) viewWillAppear:(BOOL)animated {
    
    cameraApi.delegate = self;
    [cameraApi startCaptureFrames];
}

-(void) viewWillDisappear:(BOOL)animated {
    
    [cameraApi stopCaptureFrames];
    cameraApi.delegate = nil;
}

-(void) dealloc {

    [self saveSettings];
    
	[super dealloc];

    [textFromImage release];

//    [imageSaturate release];
//    [_imageResize release];
}

-(void) didReceiveMemoryWarning {

	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];

	// Release any cached data, images, etc that aren't in use.
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UI controls
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(IBAction) viewControllerDone:(id)sender {
    
    cameraApi.delegate = nil;
    
    if( delegate != nil ){
        
        [self.delegate cameraViewControllerDelegateDidFinish:self];
    }
}

-(IBAction) showHelp:(id)sender{
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark UI controls - Language Selection
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(IBAction) chooseSourceLanguage:(id)sender {

    isSourceLanguageMode = TRUE;

    BOOL isLandscape = ( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) || ( self.interfaceOrientation == UIInterfaceOrientationLandscapeRight );
    
	LanguagePickerActionSheet*
        sheet = [[LanguagePickerActionSheet alloc] initWithForParentView:self.view
                                                               languages:[TextViewController getInputLanguages]
                                                                delegate:self];
        [sheet showInView:self.view];
        [sheet adjustSize:isLandscape];
        [sheet selectLanguage:sourceLanguageIndex];
        [sheet release];
}

-(IBAction) chooseDestinationLanguage:(id)sender{
    
    isSourceLanguageMode = FALSE;

    BOOL isLandscape = ( self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft ) || ( self.interfaceOrientation == UIInterfaceOrientationLandscapeRight );

//	LanguagePickerActionSheet*
//        sheet = [[LanguagePickerActionSheet alloc] initWithForParentView:self.view
//                                                           languages:[TextViewController getOutputLanguages]
//                                                            delegate:self];

    LanguagePickerActionSheet* sheet = nil;

    if( isOfflineTranslationMode ) {
        sheet = [[LanguagePickerActionSheet alloc] initWithForParentView:self.view
                                                               languages:[TextViewController getInputLanguages]
                                                                delegate:self];
    }
    else {
        sheet = [[LanguagePickerActionSheet alloc] initWithForParentView:self.view
                                                               languages:[TextViewController getOutputLanguages]
                                                                delegate:self];
    }

    [sheet showInView:self.view];
    [sheet adjustSize:isLandscape];
    [sheet selectLanguage:destinationLanguageIndex];
    [sheet release];
}

-(void) languagePickerActionSheetDidFinishWithLanguageIndex:(int)languageIndex
                                               languageCode:(NSString*)languageCode 
                                              languageLabel:(NSString*)languageLabel {

    if( isSourceLanguageMode ) { // reinit tessaract

        sourceLanguageIndex = languageIndex;
        sourceLanguageButton.imageView.image = [LanguagePickerViewDataSource getImageByCode:languageCode];
        sourceLanguageLabel.titleLabel.text = languageLabel;
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(initTessaract:) userInfo:nil repeats: NO];
    }

    else {
        
        destinationLanguageIndex = languageIndex;        
        destinationLanguageButton.imageView.image = [LanguagePickerViewDataSource getImageByCode:languageCode];
        destinationLanguageLabel.titleLabel.text = languageLabel;
    }
    
    [self  saveSettings];
}


-(void) infoViewControllerDelegateDidFinish:(InfoViewController*)controller {
    
    [self dismissModalViewControllerAnimated:YES];
}


#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
#pragma mark CameraApi Delegates
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(void) imageAvailable:(CGImageRef)image {

    if( canUpdateImage ) {

        _previewLayer.contents = (id)image;
        _image = (CGImage*)_previewLayer.contents;
    }

//    if( canUpdateImage ) {
//        
//        if( isImageInUse ) {
//            
//            CGImageRelease( _image );
//            isImageInUse = false;
//        }
//        
//        _previewLayer.contents = (id)image;
//    }
//    
//    else if( !isImageInUse ) {
//        
//        _previewLayer.contents = (id)image;
//
//        _image = image;
//        isImageInUse = true;
//        CGImageRetain( _image );
//    }

        
}

-(NSString*) extractTextFromImage:(UIImage*)image {
    
    if( image.CGImage == nil )
        return @"";

    NSAutoreleasePool* myPool = [[NSAutoreleasePool alloc] init];    
    
    // Do the magick
    NSString* docsFolder = [self applicationDocumentsDirectory];
    NSString* inFile = [docsFolder stringByAppendingPathComponent:@"tempimage1.jpg"];
    NSString* outFile = [docsFolder stringByAppendingPathComponent:@"tempimage2.jpg"];
    NSString* tifFile = [docsFolder stringByAppendingPathComponent:@"tempimage3.tif"];
    
    [UIImageJPEGRepresentation(image,1.0) writeToFile:inFile atomically:YES];

    
    // TEXTCLEANER
    NSString* command01 = [NSString stringWithFormat:@"convert ( %@ -colorspace gray -type grayscale -contrast-stretch 0 ) ( -clone 0 -colorspace gray -negate -contrast-stretch 0 ) -compose copy_opacity -composite -fill white -opaque none +matte %@", 
                          inFile, outFile];

    // 2COLORTHRESH                                    convert $infile +dither -colors 2 -colorspace gray -contrast-stretch 0 $outfile                  30x0+10+0
    NSString* command02 = [NSString stringWithFormat:@"convert %@ +dither -colors 2 -colorspace gray -contrast-stretch 0 -gaussian-blur 10.0 -unsharp 15x2.4+10+0 %@",
                           outFile, inFile];
    
    // TIF
    NSString* command03 = [NSString stringWithFormat:@"convert -density 200 -units PixelsPerInch -type Grayscale +compress %@ %@", 
                           inFile, tifFile];
    
    [ImageMagick convertImage:nil command:command01]; 
    [ImageMagick convertImage:nil command:command02]; 
    [ImageMagick convertImage:nil command:command03]; 

    NSString* text = @"";

    UIImage* preprocessedImage = [UIImage imageWithContentsOfFile:tifFile];
    if( preprocessedImage != nil ) {
        
        text = [ocrApi analyzeImageAndGetText:[preprocessedImage CGImage]];
        text = [[NSString alloc] initWithString: [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "]];

        //        NSLog( text );
        
//       [self uploadImage:image andText:@""];
//       [self uploadImage:preprocessedImage andText:text];
        
        //[preprocessedImage release];
    }

    [myPool release];
    
    return text;
}

-(void) textTranslated:(NSString*)text translator:(GoogleTranslate*)translator{
}

-(void) textFailedToTranslate:(NSString*)error translator:(GoogleTranslate*)translator {
}

-(void) setImageProcessingWidth:(CGFloat)width AndHeight:(CGFloat)height{
    
    int yDelta = 10;
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    rectToCopy.origin.x    = ( screenRect.size.height / 2 ) - ( width  / 2 );
    rectToCopy.origin.y    = ( screenRect.size.width  / 2 ) - ( height / 2 ) + yDelta;
    rectToCopy.size.width  = width;
    rectToCopy.size.height = height;
}

-(void) moveOverlaysWidth:(CGFloat)width AndHeight:(CGFloat)height{

    int yDelta = 20;

    CGRect screenRect = [[UIScreen mainScreen] bounds];

    CGRect 
        adaptedRct;
        adaptedRct.origin.x    = ( screenRect.size.height / 2 ) - ( width  / 2 );
        adaptedRct.origin.y    = ( screenRect.size.width  / 2 ) - ( height / 2 ) - yDelta;
        adaptedRct.size.width  = height;
        adaptedRct.size.height = width;
    
    // Move the overlays to the processing area
    int compensation = 20;
    CGRect tempFrame;
    
    tempFrame = overlayTopLeft.frame;
    tempFrame.origin.x     =   adaptedRct.origin.x                                               - compensation;
    tempFrame.origin.y     =   adaptedRct.origin.y                                               - compensation;
    if( tempFrame.origin.x < 0 ) tempFrame.origin.x = 0 - compensation;
    if( tempFrame.origin.y < 0 ) tempFrame.origin.y = 0 - compensation;
    overlayTopLeft.frame = tempFrame;
    
    tempFrame = overlayTopRight.frame;
    tempFrame.origin.x    = ( adaptedRct.origin.x + width  ) - overlayTopRight.frame.size.width  + compensation;
    tempFrame.origin.y    = ( adaptedRct.origin.y          )                                     - compensation;
    if( tempFrame.origin.x < 0 ) tempFrame.origin.x = 0 + compensation;
    if( tempFrame.origin.y < 0 ) tempFrame.origin.y = 0 - compensation;
    overlayTopRight.frame = tempFrame;
    
    tempFrame = overlayBottomLeft.frame;
    tempFrame.origin.x  =   adaptedRct.origin.x                                                  - compensation;
    tempFrame.origin.y  = ( adaptedRct.origin.y + height ) - overlayBottomLeft.frame.size.height + compensation;
    if( tempFrame.origin.x < 0 ) tempFrame.origin.x = 0 - compensation;
    if( tempFrame.origin.y < 0 ) tempFrame.origin.y = 0 + compensation;
    overlayBottomLeft.frame = tempFrame;
    
    tempFrame = overlayBottomRight.frame;
    tempFrame.origin.x = ( adaptedRct.origin.x + width  ) - overlayBottomRight.frame.size.width  + compensation;
    tempFrame.origin.y = ( adaptedRct.origin.y + height ) - overlayBottomRight.frame.size.height + compensation;
    if( tempFrame.origin.x < 0 ) tempFrame.origin.x = 0 + compensation;
    if( tempFrame.origin.y < 0 ) tempFrame.origin.y = 0 + compensation;
    overlayBottomRight.frame = tempFrame;
    
    // Resize the output image
    tempFrame = imageResult.frame;
    tempFrame.origin.x     = adaptedRct.origin.x;
    tempFrame.origin.y     = adaptedRct.origin.y;
    tempFrame.size.width   = width;
    tempFrame.size.height  = height;
    if( tempFrame.origin.x < 0 ) tempFrame.origin.x = 0 - compensation;
    if( tempFrame.origin.y < 0 ) tempFrame.origin.y = 0 - compensation;
    imageResult.frame = tempFrame;

//    // Move the delete button
//    tempFrame = deleteCurrentImage.frame;
//    tempFrame.origin.x = adaptedRct.origin.x + ( adaptedRct.size.width  / 2 ) - ( deleteCurrentImage.frame.size.width  / 2 );
//    tempFrame.origin.y = adaptedRct.origin.y + ( adaptedRct.size.height / 2 ) - ( deleteCurrentImage.frame.size.height / 2 );
//    deleteCurrentImage.frame = tempFrame;
}


@end

