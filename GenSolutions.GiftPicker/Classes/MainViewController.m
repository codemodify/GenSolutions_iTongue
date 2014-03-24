
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
        
        [imagesPathsIdsCopy release];
    }
    
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

    if( _popup == nil ){
        
        [FacebookApi freeTempData];

        CGRect rect1 = CGRectMake( 10, 30, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
        _popup = [[PopupTopLeft alloc] initWithFrame:rect1];

        
        CGRect rect2 = CGRectMake( _popup.frame.origin.x + 10, _popup.frame.origin.y + 10, _popup.frame.size.width - 40, _popup.frame.size.height - 60 );
        _tableView = [[UITableView alloc] initWithFrame:rect2 style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.allowsSelection = FALSE;
        _tableView.tableFooterView = nil;
        _tableView.tableHeaderView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        _tableView.backgroundView = _popup;
        
        [_popup addSubview:_tableView];
        
        [self.view addSubview:_popup];
        [self.view bringSubviewToFront:_popup];
        
        [facebookRequestIndicator startAnimating];
        
        NSString* imageId = [imagesPathsIds valueForKey:[self getImagePathByIndex]];
        [FacebookApi setDelegate:self];
        [FacebookApi getListOfUsersWhoLikedThePhoto:imageId];
    }
    else {
        [facebookRequestIndicator stopAnimating];
        
        [_tableView removeFromSuperview];
        [_tableView release];

        [_popup removeFromSuperview];
        [_popup release];
        
        _popup = nil;
        _tableView = nil;
    }

}

-(void) getListOfUsersWhoLikedThePhotoDidFinish:(NSArray*)userIdList 
                                    commentList:(NSArray*)commentList 
                                       firstName:(NSDictionary*)firstName 
                                       lastName:(NSDictionary*)lastName
                                        picture:(NSDictionary*)picture{

    _userIdList = userIdList;
    _commentList = commentList;
    _firstName = firstName;
    _lastName = lastName;
    _picture = picture;

    [facebookRequestIndicator stopAnimating];
    [_tableView reloadData];
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




#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if( nil != _userIdList ) {
        return [_userIdList count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // data
    int index = [indexPath row];
    NSString* userId = [_userIdList objectAtIndex:index];
    NSString* comment = [_commentList objectAtIndex:index];
    NSString* firstName = [_firstName objectForKey:userId];
    NSString* lastName = [_lastName objectForKey:userId];
    NSString* picture = [_picture objectForKey:userId];
    
    NSMutableString*
        value = [[NSMutableString alloc]init];
        [value appendFormat:@"%@ %@\r\n", firstName, lastName];
        [value appendString:comment];

    // UI
	static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0,0,_tableView.frame.size.width, 200) reuseIdentifier:MyIdentifier];

        NSData* imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: picture]];
        
        //cell.backgroundView = _popup;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.text= value;
        cell.textLabel.numberOfLines = 50;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        [cell.imageView setImage:[UIImage imageWithData:imageData]];
        [cell.imageView setContentMode:UIViewContentModeTopLeft];
        
        [imageData release];
    }
    
    [value release];
    
    return cell;
}

- (CGFloat) tableView: (UITableView *) tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {

    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];

	CGFloat height = [cell.textLabel.text sizeWithFont:cell.textLabel.font 
                                               forWidth:_tableView.frame.size.width
                                          lineBreakMode:UILineBreakModeWordWrap].height;
	
    int nrOfLines = 2;
    if( [cell.textLabel.text length] > 20 )
        nrOfLines = ( [cell.textLabel.text length] / 20 ) + 2;

    height = height * nrOfLines + 10;

    int temp = cell.imageView.image.size.height;
    if( height < temp )
        return temp + 10;
    
	return height;
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

    NSString* GenSoltions_GiftPicker_ApplicationID      = @"138489422872480";
    NSString* GenSoltions_GiftPicker_ApiKey             = @"5f55c0ada9c2796919f80b17c332db6e";
    NSString* GenSoltions_GiftPicker_ApplicationSecret  = @"7ffb9770f41991223dd631e75ac3ea03";
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
    
    _popup = nil;
    
    
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
