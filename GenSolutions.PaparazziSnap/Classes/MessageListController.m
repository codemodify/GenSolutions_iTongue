
#import "MessageListController.h"

@implementation MessageListController



#pragma mark Table Controller methods
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(id) initWithShapeImage:(UIImage*)shapeImage 
        parentLeftOffset:(CGFloat)parentLeftOffset 
         parentTopOffset:(CGFloat)parentTopOffset
       contentLeftOffset:(CGFloat)contentLeftOffset
        contentTopOffset:(CGFloat)contentTopOffset
      contentRightOffset:(CGFloat)contentRightOffset
     contentBottomOffset:(CGFloat)contentBottomOffset {

    // init the UIView
    UIImageView*
        backgroundAndShapeImageView = [[UIImageView alloc] initWithImage:shapeImage];
        backgroundAndShapeImageView.frame = CGRectMake( 0, 0, shapeImage.size.width, shapeImage.size.height );

    view = [[UIView alloc] initWithFrame:CGRectMake( parentLeftOffset, parentTopOffset, shapeImage.size.width, shapeImage.size.height )];
    view.opaque = NO;
    view.backgroundColor = [UIColor clearColor];
    [view addSubview:backgroundAndShapeImageView];

    [backgroundAndShapeImageView release];
    
    
    // init the data source
    userPictureList = nil;
    userNameList = nil;
    userCommentList = nil;
    

    // init the UITableViewController
    [super initWithStyle:UITableViewStylePlain];

    self.tableView.frame             = CGRectMake( contentLeftOffset, contentTopOffset, view.frame.size.width  - contentRightOffset - contentLeftOffset, view.frame.size.height - contentBottomOffset - contentTopOffset );
    self.tableView.backgroundColor   = [UIColor clearColor];
    self.tableView.allowsSelection   = FALSE;
    self.tableView.tableFooterView   = nil;
    self.tableView.tableHeaderView   = nil;
    self.tableView.separatorStyle    = UITableViewCellSeparatorStyleNone;
    
    [view addSubview:self.tableView];
    
    return self;
}

-(void) dealloc{

    [view release];
    
    if( nil != userPictureList ){
        
        [userPictureList release];
        [userNameList release];
        [userCommentList release];
    }
	
	[super dealloc];
}

-(void) viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
	
    [self syncViewWithModel];
}

-(void) didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

-(void) setUserPictureList:(NSArray*)listOfUsersPictures 
              userNameList:(NSArray*)listOfUsersNames 
           userCommentList:(NSArray*)listOfUsersComments {
    
    if( nil != userPictureList ){
        
        [userPictureList release];
        [userNameList release];
        [userCommentList release];
    }

    userPictureList = listOfUsersPictures;
    userNameList = listOfUsersNames;
    userCommentList = listOfUsersComments;
    
    [userPictureList retain];
    [userNameList retain];
    [userCommentList retain];
}

-(void) syncViewWithModel {
    
    [self.tableView reloadData];
}

-(UIView*) getView {
    
    return view;
}



#pragma mark TableView methods
#pragma mark ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if( nil == userPictureList )
        return 0;
    
    return [userPictureList count];
}

-(CGFloat) calculateTextHeight:(NSString*)text font:(UIFont*)font widthConstraint:(CGFloat)width wrapText:(BOOL)wrapText {

    // calculate the current text's font's height
	CGFloat height = [text sizeWithFont:font
                               forWidth:width
                          lineBreakMode:UILineBreakModeTailTruncation].height;
    if( wrapText ) {

        height = [text sizeWithFont:font
                           forWidth:width
                      lineBreakMode:UILineBreakModeWordWrap].height;
    }

    int nrOfLines = [[text componentsSeparatedByString:@"\n"] count];
    int nrOfCharsPerLine = 30;

    if( [text length] > nrOfCharsPerLine )
        nrOfLines = nrOfLines + ( [text length] / nrOfCharsPerLine );

    height = height * nrOfLines;

	return height;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    // UI
	static NSString* cellIdentifier = @"UICell";

    if( (nil != userPictureList) && (indexPath.row < [userPictureList count]) )
        cellIdentifier = @"MessageListCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    if( cell == nil ) {

        if( FALSE ) {
            
        }

        else if( [cellIdentifier isEqualToString:@"UICell"] ) {
            
            cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:cellIdentifier] autorelease];
            cell.textLabel.textAlignment = UITextAlignmentCenter;
            cell.textLabel.font = [UIFont systemFontOfSize:16];;
        }
        
        else if( [cellIdentifier isEqualToString:@"MessageListCell"] ){

            int index = [indexPath row];
            UIImage* userPicture = [userPictureList objectAtIndex:index];
            NSString* userName = [userNameList objectAtIndex:index];
            NSString* userComment = [userCommentList objectAtIndex:index];
            
            UIFont* userNameFont = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
            UIFont* userCommentFont = [UIFont systemFontOfSize:[UIFont systemFontSize]];

            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier]autorelease];
            cell.backgroundColor = [UIColor clearColor];

            cell.textLabel.text= userName;
            cell.textLabel.numberOfLines = 50;
            cell.textLabel.textColor = [UIColor whiteColor];
            cell.textLabel.font = userNameFont;
            cell.textLabel.lineBreakMode = UILineBreakModeTailTruncation;
            
            cell.detailTextLabel.text= userComment;
            cell.detailTextLabel.numberOfLines = 50;
            cell.detailTextLabel.textColor = [UIColor whiteColor];
            cell.detailTextLabel.font = userCommentFont;
            cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
            
            [cell.imageView setImage:userPicture];
            [cell.imageView setContentMode:UIViewContentModeTopLeft];
        }
    }

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if( (nil != userPictureList) && (indexPath.row >= [userPictureList count]) )
        return 50;

    UITableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    CGFloat h1 = [self calculateTextHeight:cell.textLabel.text font:cell.textLabel.font widthConstraint:cell.textLabel.frame.size.width wrapText:FALSE];
    CGFloat h2 = [self calculateTextHeight:cell.detailTextLabel.text font:cell.detailTextLabel.font widthConstraint:cell.detailTextLabel.frame.size.width wrapText:TRUE];
    CGFloat height1 = h1 + h2;
    CGFloat height2 = cell.imageView.image.size.height + 10;

    CGFloat height = ( height1 > height2 ) ? height1 : height2;
    
	return height;
}


@end
