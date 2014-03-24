
#import "FacebookApi.h"
#import "FacebookApiHelper.h"


@implementation FacebookApiHelper

@synthesize currentStep;
@synthesize nextStep;
@synthesize uploadedPhotoId;
@synthesize userIdList;
@synthesize commentList;
@synthesize firstName;
@synthesize lastName;
@synthesize picture;
@synthesize lastErrorMessage;

-(id) init{
    
    self.currentStep = eNothing;
    self.nextStep = eNothing;
    
    uploadedPhotoId = [[NSMutableString alloc] init];
    userIdList = [[NSMutableArray alloc]init];
    commentList = [[NSMutableArray alloc]init];
    firstName = [[NSMutableDictionary alloc]init];
    lastName = [[NSMutableDictionary alloc]init];
    picture = [[NSMutableDictionary alloc]init];
    lastErrorMessage = [[NSMutableString alloc] init];
    
    return [super init];
}

-(void) dealloc{
    
    [uploadedPhotoId release];
    [userIdList release];
    [commentList release];
    [firstName release];
    [lastName release];
    [picture release];
    [lastErrorMessage release];
    
    [super dealloc];
}


// "Threaded" notification helhers
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
- (void)eUploadPictureOK                            { [FacebookApi uploadPictureOK];            }
- (void)eUploadPictureKO                            { [FacebookApi uploadPictureKO];            }
- (void)eUploadPictureWithCommentOK                 { [FacebookApi uploadPictureWithCommentOK]; }
- (void)eUploadPictureWithCommentKO                 { [FacebookApi uploadPictureWithCommentKO]; }
- (void)eUploadPictureWithTagOK                     { [FacebookApi uploadPictureWithTagOK];     }
- (void)eUploadPictureWithTagKO                     { [FacebookApi uploadPictureWithTagKO];     }
- (void)eGetUserIdListWithCommentsWhoLikedThePhotoOK{ [FacebookApi getUserIdListWithCommentsWhoLikedThePhotoOK]; }
- (void)eGetUserIdListWithCommentsWhoLikedThePhotoKO{ [FacebookApi getUserIdListWithCommentsWhoLikedThePhotoKO]; }
- (void)eGetListOfUsersWhoLikedThePhotoOK           { [FacebookApi getListOfUsersWhoLikedThePhotoOK]; }
- (void)eGetListOfUsersWhoLikedThePhotoKO           { [FacebookApi getListOfUsersWhoLikedThePhotoKO]; }


// INFO: this is the first delegate called, has the response as raw
- (void)request:(FBRequest*)request didReceiveResponse:(NSURLResponse *)response {
    // NSLog( [[response URL] absoluteString] );
}

// INFO: this is the second delegate if the request is OK, has the response as object
- (void)request:(FBRequest*)request didLoad:(id)result {

    if( 0 == 1 ){
    }
    
    else if( self.currentStep == eNothing ){
        
//        if( [result isKindOfClass:[NSArray class]] ) {
//            for( int i=0; i < [result count]; i++ ){
//                NSLog( [result objectAtIndex:i] );
//            }
//        }
//        
//        if( [result isKindOfClass:[NSDictionary class]] ){
//            for( id key in result ) {
//                NSLog( @"key: %@, value: %@", key, [result objectForKey:key]);
//            }
//        }        
    }
    
    else if( self.currentStep == eUploadPicture ){

        // result is in NSDictionary, for( id key in result ){ NSLog( @"key: %@, value: %@", key, [result objectForKey:key]); }
        if( [result objectForKey:@"owner"] ){
            
            NSArray* link = [[result objectForKey:@"link"] componentsSeparatedByString: @"fbid="]; // http://www.facebook.com/photo.php?fbid=127575567306520&set=a.127562920641118.21088.100001622314705
            
            if( 0 != [link count] ){
                
                NSArray* fbidValue = [[link objectAtIndex:1] componentsSeparatedByString: @"&"]; // 127575567306520&set=a.127562920641118.21088.100001622314705
                
                NSString* uid = [fbidValue objectAtIndex:0]; 
                
                [uploadedPhotoId setString:uid];
            }
            else {
                [uploadedPhotoId setString:@""];
            }
         }
        else {
            [uploadedPhotoId setString:@""];
        }

        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eUploadPictureOK) userInfo:nil repeats:NO];
    }

    else if( self.currentStep == eUploadPictureWithComment ){
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eUploadPictureWithCommentOK) userInfo:nil repeats:NO];
    }

    else if( self.currentStep == eUploadPictureWithTag ){

        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eUploadPictureWithTagOK) userInfo:nil repeats:NO];
    }

    else if( self.currentStep == eGetUserIdListWithCommentsWhoLikedThePhoto ){
        
        [userIdList removeAllObjects];
        [commentList removeAllObjects];
        
        if( [result isKindOfClass:[NSArray class]] ) {
            
            NSArray* array = result;

            for( int i=0; i < [array count]; i++ ) {

                NSDictionary* dictionary = [array objectAtIndex:i];
                
                [userIdList addObject:[dictionary objectForKey:@"fromid"]];
                [commentList addObject:[dictionary objectForKey:@"text"]];
            }
        }
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eGetUserIdListWithCommentsWhoLikedThePhotoOK) userInfo:nil repeats:NO];        
    }

    else if( self.currentStep == eGetListOfUsersWhoLikedThePhoto ){

        [firstName removeAllObjects];
        [lastName removeAllObjects];
        [picture removeAllObjects];
        
        if( [result isKindOfClass:[NSArray class]] ) {
            
            NSArray* array = result;
            
            for( int i=0; i < [array count]; i++ ) {
                
                NSDictionary* dictionary = [array objectAtIndex:i];
                
                [firstName setObject:[dictionary objectForKey:@"first_name"] forKey:[dictionary objectForKey:@"uid"]];
                [lastName setObject:[dictionary objectForKey:@"last_name"] forKey:[dictionary objectForKey:@"uid"]];
                [picture setObject:[dictionary objectForKey:@"pic_small"] forKey:[dictionary objectForKey:@"uid"]];
            }
        }

        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eGetListOfUsersWhoLikedThePhotoOK) userInfo:nil repeats:NO];        
    }
}

// INFO: this is the second delegate if the request is not OK
- (void)request:(FBRequest*)request didFailWithError:(NSError *)error {
    
    [lastErrorMessage setString:[error localizedDescription]];
//    NSLog(lastErrorMessage);

    if( 0 == 1 ){
    }

    else if( self.currentStep == eNothing ){
    }

    else if( self.currentStep == eUploadPicture ){

        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eUploadPictureKO) userInfo:nil repeats:NO];
    }

    else if( self.currentStep == eUploadPictureWithComment ){

        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eUploadPictureWithCommentKO) userInfo:nil repeats:NO];
    }

    else if( self.currentStep == eUploadPictureWithTag ){
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eUploadPictureWithTagKO) userInfo:nil repeats:NO];
    }

    else if( self.currentStep == eGetUserIdListWithCommentsWhoLikedThePhoto ){

        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eGetUserIdListWithCommentsWhoLikedThePhotoKO) userInfo:nil repeats:NO];        
    }

    else if( self.currentStep == eGetListOfUsersWhoLikedThePhoto ){
        
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(eGetListOfUsersWhoLikedThePhotoKO) userInfo:nil repeats:NO];        
    }
}

@end
