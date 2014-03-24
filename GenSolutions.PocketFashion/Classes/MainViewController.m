
#import "MainViewController.h"
#import "AFOpenFlowView.h"
#import <GenSolutions.Api.Image.Resize/Image.Resize.h>
#import <GenSolutions.Api.Facebook/iOS/FacebookApi.h>


@implementation MainViewController

@synthesize likesCount;
@synthesize likesButton;
@synthesize facebookRequestIndicator;

// Helpers start
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
-(void)saveSettings{
    
    [imagesPathsIds writeToFile:imagesPathsIdsFile atomically:TRUE];
}

-(void)readSettings{

    if( nil != imagesPathsIds )
        [imagesPathsIds release];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    if( [fileManager fileExistsAtPath:imagesPathsIdsFile] ){
        imagesPathsIds = [[NSMutableDictionary alloc] initWithContentsOfFile:imagesPathsIdsFile];
    }
    else {
        imagesPathsIds = [NSMutableDictionary new];
    }
}

-(void)rescanImages {

    NSMutableDictionary* imagesPathsIdsCopy = [[NSMutableDictionary alloc] initWithDictionary:imagesPathsIds];
    [imagesPathsIds removeAllObjects];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSError* error;
    NSArray* dirContent = [fileManager contentsOfDirectoryAtPath:imagesPath error:&error];
    NSArray* onlyJPGs = [dirContent filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.jpg'"]];

    if( 0 != [onlyJPGs count] ){

        for( NSString* imageName in onlyJPGs ) {

            NSString* fullImagePath = [ [NSString alloc] initWithFormat:@"%@/%@", imagesPath, imageName ];

            [imagesPathsIds setObject:@"0" forKey:fullImagePath];

            UIImage* image = [[UIImage alloc] initWithContentsOfFile:fullImagePath];

            [(AFOpenFlowView *)self.view setImage:image forIndex:([imagesPathsIds count]-1)];
            
            [image release];
            [fullImagePath release];
        }

        // update the photos Ids from the previous ones
        NSArray* paths = [imagesPathsIds allKeys];

        for( int i=0; i < [paths count]; i++ ) {
            
            NSString* imagePath = [paths objectAtIndex:i];

            NSString* imageId = [imagesPathsIdsCopy valueForKey:imagePath];

            if( nil != imageId )
                [imagesPathsIds setObject:imageId forKey:imagePath];
        }
    }

    [imagesPathsIdsCopy release];
    
    [(AFOpenFlowView *)self.view setNumberOfImages:[imagesPathsIds count]];
}

NSInteger compare(id imagePath1, id imagePath2, void* context) {
    
    NSString* v1 = (NSString*) imagePath1;
    NSString* v2 = (NSString*) imagePath2;
    
    if( NSOrderedAscending ==  [v1 compare:v2] )
        return NSOrderedAscending;
    
    return NSOrderedDescending;
}

-(NSString*) getImagePathByIndex{

    NSArray* sortedArray = [[imagesPathsIds allKeys] sortedArrayUsingFunction:compare context:NULL];
    NSString* imagePath = [sortedArray objectAtIndex:currentImageIndex];
    
//    return [[NSString alloc]initWithString:imagePath];
    return imagePath;
}






// Flow delegates start
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
- (void)updatePhotoLikeCount{

    likesButton.hidden = TRUE;
    likesCount.hidden = TRUE;
    likesCount.text = @"*";
    [facebookRequestIndicator stopAnimating];

    if( 0 == [imagesPathsIds count] )
        return;
    
    NSString* imageId = [imagesPathsIds valueForKey:[self getImagePathByIndex]];
    
    if( NSOrderedSame != [imageId compare:@"0"] ){

        likesButton.hidden = FALSE;
        likesCount.hidden = FALSE;
        
        // get likes for current photo
        [facebookRequestIndicator startAnimating];
        
        NSString* query = [NSString stringWithFormat:@"select user_id from like where object_id == %@", imageId ];
        
        NSMutableDictionary* params = [[NSMutableDictionary alloc]init];
        [params setValue:query forKey:@"query"];
        
        [[FacebookApi facebook] requestWithMethodName:@"fql.query" andParams:params andHttpMethod:@"POST" andDelegate:self];

        [params release];
    }
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView selectionDidChange:(int)index{
    
    currentImageIndex = index;

    [self updatePhotoLikeCount];
}

- (UIImage *)defaultImage {
    
    // setting the image 1 as the default pic
	return [UIImage imageNamed:@"camera.png"];
}

- (void)openFlowView:(AFOpenFlowView *)openFlowView requestImageForIndex:(int)index {
/*
	AFGetImageOperation *getImageOperation = [[AFGetImageOperation alloc] initWithIndex:index viewController:self];
    
	if (interestingnessRequest) {
		// We're getting our images from the Flickr API.
		NSDictionary *photoDictionary = [[interestingPhotosDictionary valueForKeyPath:@"photos.photo"] objectAtIndex:index];
		NSURL *photoURL = [flickrContext photoSourceURLFromDictionary:photoDictionary size:OFFlickrMediumSize];
		getImageOperation.imageURL = photoURL;
	}
	
	[loadImagesOperationQueue addOperation:getImageOperation];
	[getImageOperation release];
 */
}

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller {
    
	[self dismissModalViewControllerAnimated:YES];
}

- (void)uploadToFacebookViewControllerDidFinish:(UploadToFacebook *)controller {

    NSString* imagePath = [self getImagePathByIndex];

    if( nil != controller.uploadedPhotoId ){
        [imagesPathsIds setValue:controller.uploadedPhotoId forKey:imagePath];
    }
    
	[self dismissModalViewControllerAnimated:NO];

    [controller release];
    
    [self saveSettings];
    [self updatePhotoLikeCount];
}










// Facebook delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
    [facebookRequestIndicator stopAnimating];
}

- (void)request:(FBRequest *)request didLoad:(id)result {

    if( [result isKindOfClass:[NSArray class]] ) {
        
        NSArray* array = (NSArray*) result;

        likesCount.text = [NSString stringWithFormat:@"%d", [array count]];
    }
}

- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
//    NSLog(@"request didFailWithError()");
//    NSLog(@"cannot get photo info, check facebook connection");
//    NSLog([error localizedDescription]);
//    NSLog([error localizedDescription]);
//    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Photo Info Error"
                                                    message:@"Please check your network connection."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert autorelease];
    [alert show];
}










// UI controls handlers
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if( 0 == buttonIndex ){
        
        NSError* error;
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:[self getImagePathByIndex] error:&error];

        if( currentImageIndex > 0 )
            currentImageIndex = currentImageIndex - 1;
        
        [self rescanImages];
        [self updatePhotoLikeCount];
        
        [(AFOpenFlowView *)self.view setSelectedCover:currentImageIndex];
    }
}

- (IBAction)removeImage:(id)sender{
    
    if( 0 == [imagesPathsIds count] )
        return;

    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Photo Delete Confirmation"
                                                    message:nil
                                                   delegate:self
                                          cancelButtonTitle:@"Yes"
                                          otherButtonTitles:@"No",nil];
    [alert autorelease];
    [alert show];
}

- (IBAction)showSettings:(id)sender {    
	
	FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideView" bundle:nil];
	controller.delegate = self;
	
	controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
	[self presentModalViewController:controller animated:YES];
	
	[controller release];
}

- (IBAction)takePicture:(id)sender {
    
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; //UIImagePickerControllerSourceTypeCamera
    
    [self presentModalViewController:imagePickerController animated:YES];       
}

- (IBAction)showWhoLikedThePhoto:(id)sender{

    if( messageListController == nil ){
        
        [FacebookApi freeTempData];
        
        UIImage* image = [UIImage imageNamed:@"titanium-texture-popup.png"];
        messageListController = [[MessageListController alloc] initWithShapeImage:image
                                                                 parentLeftOffset:5.0 
                                                                  parentTopOffset:30.0
                                                                contentLeftOffset:20.0 
                                                                 contentTopOffset:45.0 
                                                               contentRightOffset:20.0
                                                              contentBottomOffset:30.0];

        UIView* view = [messageListController getView];
        
        [self.view addSubview:view];
        [self.view bringSubviewToFront:view];
        
        [facebookRequestIndicator startAnimating];
        
        NSString* imageId = [imagesPathsIds valueForKey:[self getImagePathByIndex]];
        [FacebookApi setDelegate:self];
        [FacebookApi getListOfUsersWhoLikedThePhoto:imageId];
    }
    else {

        [facebookRequestIndicator stopAnimating];

        UIView* view = [messageListController getView];

        [view removeFromSuperview];
        [messageListController release];
        messageListController = nil;
    }
}

-(void) getListOfUsersWhoLikedThePhotoDidFinish:(NSArray*)userIdList 
                                    commentList:(NSArray*)commentList 
                                       firstName:(NSDictionary*)firstName 
                                       lastName:(NSDictionary*)lastName
                                        picture:(NSDictionary*)picture{

    [facebookRequestIndicator stopAnimating];

    NSMutableArray* userPictureList = [[NSMutableArray alloc]init];
    NSMutableArray* userNameList    = [[NSMutableArray alloc]init];
    NSMutableArray* userCommentList = [[NSMutableArray alloc]initWithArray:commentList];

    for( int index=0; index < [userIdList count]; index++ ) {

        NSString* _userId   = [userIdList objectAtIndex:index];
        NSString* _firstName = [firstName objectForKey:_userId];
        NSString* _lastName = [lastName objectForKey:_userId];
        NSString* _picture  = [picture objectForKey:_userId];

        NSData* imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: _picture]];

        [userPictureList addObject:[UIImage imageWithData:imageData]];
        [userNameList addObject:[NSString stringWithFormat:@"%@ %@", _firstName, _lastName]];
        
        [imageData release];
    }

    [messageListController setUserPictureList:userPictureList userNameList:userNameList userCommentList:userCommentList];
    [messageListController syncViewWithModel];

    [userPictureList release];
    [userNameList release];
    [userCommentList release];
}

-(void) getListOfUsersWhoLikedThePhotoDidNotFinish:(NSString*)errorMessage{
    
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Photo Info Error"
                                                    message:@"Please check your network connection."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert autorelease];
    [alert show];
    
    [self showWhoLikedThePhoto:nil];
}

- (void)handleLongPress:(UILongPressGestureRecognizer*)recognizer {

    if( 0 == [imagesPathsIds count] )
        return;

    UIImage* image = [[UIImage alloc] initWithContentsOfFile:[self getImagePathByIndex]];
    
	UploadToFacebook*
        controller = [[UploadToFacebook alloc] initWithNibName:@"UploadToFacebook" bundle:nil];
        controller.delegate = self;
        controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        controller.image = image;
    
	[self presentModalViewController:controller animated:NO];
	
    [image release];
}

- (void)handleDoubleTap:(UIPanGestureRecognizer *)recognizer {

    toolbar.hidden = !toolbar.hidden;
}





// Image taking start
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
CGFloat DegreesToRadians(CGFloat degrees) {return degrees * M_PI / 180;};

- (UIImage*)imageRotatedByDegrees:(UIImage*)image degrees:(CGFloat)degrees {

    // calculate the size of the rotated view's containing box for our drawing space
    CGAffineTransform t = CGAffineTransformMakeRotation(DegreesToRadians(degrees));

    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,image.size.width, image.size.height)];
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    [rotatedViewBox release];
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    //   // Rotate the image context
    CGContextRotateCTM(bitmap, DegreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-image.size.width / 2, -image.size.height / 2, image.size.width, image.size.height), [image CGImage]);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
    
}

- (IBAction) imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary*)info {

    UIImage* takenPicture = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    ImageResize* imageResize = [[ImageResize alloc] init];
    UIImage* resizedImage = [imageResize resize:takenPicture toWidth:320 toHeight:213];

    UIImage* resizedImageAndRotated = [self imageRotatedByDegrees:resizedImage degrees:90.0];
    
    NSDateFormatter* dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-hh-mm-ss"];
    
    NSString* fullImagePath = [ [NSString alloc] initWithFormat:@"%@/%@.jpg", imagesPath, [dateFormatter stringFromDate:[NSDate date]] ];

    NSData* imageData = UIImageJPEGRepresentation( resizedImageAndRotated, 1.0 );
    [imageData writeToFile:fullImagePath atomically:YES];
    
    [fullImagePath release];
//    [resizedImageAndRotated release];
//    [resizedImage release];
    [imageResize release];
    
    [[picker parentViewController] dismissModalViewControllerAnimated:YES];
    [picker release];
    
    [self rescanImages];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
}










// UIView standard start
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
- (void)delayedSettings{

    NSString* GenSoltions_GiftPicker_ApplicationID      = @"177334298972345";
    NSString* GenSoltions_GiftPicker_ApiKey             = @"0c53a5b3c46842117dcca8a3cbcc8ffd";
    NSString* GenSoltions_GiftPicker_ApplicationSecret  = @"ac119b0da1fc8bc9186f7a43212290f5";
    NSString* GenSoltions_GiftPicker_Permissions        = @"offline_access,publish_stream,user_about_me,friends_about_me,user_likes,friends_likes,user_photos,read_friendlists,manage_friendlists,read_stream,xmpp_login";
    
    [FacebookApi initWithApplicationID:GenSoltions_GiftPicker_ApplicationID
                                apiKey:GenSoltions_GiftPicker_ApiKey
                     applicationSecret:GenSoltions_GiftPicker_ApplicationSecret
                           permissions:GenSoltions_GiftPicker_Permissions]; // sigleton
    
    [FacebookApi loadSession]; // will try to load the previus session

    if( [[FacebookApi facebook] isSessionValid] ){
        [self updatePhotoLikeCount];
    }
    else {
        [self showSettings:nil];
    } 
}

- (void)viewDidLoad {
    
	[super viewDidLoad];
    
    messageListController = nil;
    
    
    [facebookRequestIndicator stopAnimating];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES );

    imagesPath = [[NSString alloc] initWithString:([paths count] > 0) ? [paths objectAtIndex:0] : nil];
    imagesPathsIdsFile = [[NSString alloc] initWithFormat:@"%@/filesids", imagesPath];
    imagesPathsIds = nil;
    [self readSettings];
    
	loadImagesOperationQueue = [[NSOperationQueue alloc] init];
    
    longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    /*
    longPressGestureRecognizer.minimumPressDuration = 0.5;
    longPressGestureRecognizer.numberOfTouchesRequired = 1;
    longPressGestureRecognizer.numberOfTapsRequired = 1;
    longPressGestureRecognizer.allowableMovement = FALSE;
    */
    [self.view addGestureRecognizer:longPressGestureRecognizer];

    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapGestureRecognizer.numberOfTouchesRequired = 1;
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];

//    singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
//    singleTapGestureRecognizer.numberOfTouchesRequired = 1;
//    singleTapGestureRecognizer.numberOfTapsRequired = 1;
//    [self.view addGestureRecognizer:singleTapGestureRecognizer];

    [(AFOpenFlowView *)self.view setViewDelegate:self];

//    CGAffineTransform transform = self.view.transform;
//    transform = CGAffineTransformRotate(transform, (M_PI / 2.0));
//    self.view.transform = transform;    
    

    [self rescanImages];

    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(delayedSettings) userInfo:nil repeats:NO];
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
    
    [self saveSettings];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations.
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)dealloc {
    [super dealloc];
    
    [FacebookApi deInit];
    [doubleTapGestureRecognizer release];
    [longPressGestureRecognizer release];
    [loadImagesOperationQueue release];
    [imagesPathsIds release];
    [imagesPath release];    
}




@end
