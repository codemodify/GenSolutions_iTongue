
#import "FacebookApi.h"
#import "FacebookApiHelper.h"

static NSString*                s_facebookApplicationID     = nil;
static NSString*                s_facebookApiKey            = nil;
static NSString*                s_facebookApplicationSecret = nil;
static NSString*                s_facebookPermissions       = nil;
static Facebook*                s_facebook                  = nil;
static id<FacebookApiDelegate>  s_delegate                  = nil;
static FacebookApiHelper*       s_facebookApiHelper         = nil;
static NSMutableString*         s_helperInText              = nil;



@implementation FacebookApi

// Step helper
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) stepAdvancer:(Step)stepToBeTaken{
    
    s_facebookApiHelper.nextStep = s_facebookApiHelper.currentStep;
    s_facebookApiHelper.currentStep = stepToBeTaken;
}

+(void) stepAdvancer{

    Step stepBackup = s_facebookApiHelper.currentStep;
    
    s_facebookApiHelper.currentStep = s_facebookApiHelper.nextStep;
    s_facebookApiHelper.nextStep = eNothing;
    
    if( s_facebookApiHelper.currentStep == eNothing ) {

        s_facebookApiHelper.currentStep = eNotify;
        s_facebookApiHelper.nextStep = stepBackup;
    }
}

+(void) stepRunner{
    
    if( 0 == 1 ){
    }
    
    else if( s_facebookApiHelper.currentStep == eNothing ){
    }

    else if( s_facebookApiHelper.currentStep == eUploadPicture ){
    }
    
    else if( s_facebookApiHelper.currentStep == eUploadPictureWithComment ){

        // getting here means we have uploaded a photo, now we have to post a comment to it
        // IN: s_helperInText == comment to post
        NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                        s_helperInText, @"text",
                                        s_facebookApiHelper.uploadedPhotoId, @"object_id",
                                        nil];
        
        [s_facebook requestWithMethodName:@"comments.add"
                                andParams:params
                            andHttpMethod:@"POST"
                              andDelegate:s_facebookApiHelper];
    }

    else if( s_facebookApiHelper.currentStep == eGetUserIdListWithCommentsWhoLikedThePhoto ){
    }

    else if( s_facebookApiHelper.currentStep == eGetListOfUsersWhoLikedThePhoto ){

        NSMutableString* uids = [NSMutableString new];
        for (int i=0; i < [s_facebookApiHelper.userIdList count]; i++) {
            [uids appendFormat:@"%@,",[s_facebookApiHelper.userIdList objectAtIndex:i]];
        }
        if( [uids length] > 0 ){
            
            NSRange range;
                range.length = 1;
                range.location = [uids length] - 1;
            [uids replaceCharactersInRange:range withString:@""];

            NSMutableString* fields = [NSMutableString new];
            [fields appendString:@"pic_small,first_name,last_name"];
        
            NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                           uids, @"uids",
                                           fields, @"fields",
                                           nil];

            [s_facebook requestWithMethodName:@"users.getInfo"
                                    andParams:params
                                andHttpMethod:@"POST"
                                  andDelegate:s_facebookApiHelper];
            
            [fields release];
        }
        
        [uids release];
    }
    
    else if( s_facebookApiHelper.currentStep == eNotify ){
        
        if( s_delegate != nil ){

            switch( s_facebookApiHelper.nextStep ) {
                case eUploadPicture                     : [s_delegate uploadPictureDidFinish:s_facebookApiHelper.uploadedPhotoId]; break;
                case eUploadPictureWithComment          : [s_delegate uploadPictureWithCommentDidFinish:s_facebookApiHelper.uploadedPhotoId]; break;
                case eUploadPictureWithTag              : [s_delegate uploadPictureWithTagDidFinish:s_facebookApiHelper.uploadedPhotoId]; break;
                case eGetListOfUsersWhoLikedThePhoto    : [s_delegate getListOfUsersWhoLikedThePhotoDidFinish:s_facebookApiHelper.userIdList 
                                                                                                  commentList:s_facebookApiHelper.commentList
                                                                                                     firstName:s_facebookApiHelper.firstName
                                                                                                     lastName:s_facebookApiHelper.lastName
                                                                                                      picture:s_facebookApiHelper.picture]; break;

                default:
                    break;
            }
        }
        
        s_facebookApiHelper.currentStep = eNothing;
        s_facebookApiHelper.nextStep = eNothing;        
    }
}

+(void) stepResseter{

    if( s_delegate != nil ){

        if( 0 == 1 ){
        }

        else if( s_facebookApiHelper.currentStep == eNothing ){
        }

        else if( s_facebookApiHelper.currentStep == eUploadPicture ){
            [s_delegate uploadPictureDidNotFinish:s_facebookApiHelper.lastErrorMessage];
        }

        else if( s_facebookApiHelper.currentStep == eUploadPictureWithComment ){
            [s_delegate uploadPictureWithCommentDidNotFinish:s_facebookApiHelper.lastErrorMessage];
        }

        else if( s_facebookApiHelper.currentStep == eUploadPictureWithTag ){
            [s_delegate uploadPictureWithTagDidNotFinish:s_facebookApiHelper.lastErrorMessage];
        }

        else if( s_facebookApiHelper.currentStep == eGetUserIdListWithCommentsWhoLikedThePhoto &&
                 s_facebookApiHelper.nextStep == eGetListOfUsersWhoLikedThePhoto ){
            [s_delegate getListOfUsersWhoLikedThePhotoDidNotFinish:s_facebookApiHelper.lastErrorMessage];
        }
        
        else if( s_facebookApiHelper.currentStep == eGetListOfUsersWhoLikedThePhoto ){
            [s_delegate getListOfUsersWhoLikedThePhotoDidNotFinish:s_facebookApiHelper.lastErrorMessage];
        }
    }

    s_facebookApiHelper.currentStep = eNothing;
    s_facebookApiHelper.nextStep = eNothing;
}



// Session related
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) initWithApplicationID:(NSString*)applicationID
                       apiKey:(NSString*)apiKey
            applicationSecret:(NSString*)applicationSecret
                  permissions:(NSString*)permissions{
    
    if( nil == s_facebook ){
        
        s_facebookApplicationID     = [[NSString alloc] initWithString:applicationID];
        s_facebookApiKey            = [[NSString alloc] initWithString:apiKey];
        s_facebookApplicationSecret = [[NSString alloc] initWithString:applicationSecret];
        s_facebookPermissions       = [[NSString alloc] initWithString:permissions];
        s_facebook                  = [[Facebook alloc] initWithAppId:s_facebookApplicationID];
        s_facebookApiHelper         = [[FacebookApiHelper alloc] init];
        s_helperInText              = [[NSMutableString alloc] init];
    }    
}

+(void) setDelegate:(id <FacebookApiDelegate>)delegate{
    
    s_delegate = delegate;
}


+(void) loadSession{
    
    s_facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
    s_facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];
}

+(void) loadSessionWithAuthorize:(id <FBSessionDelegate>)delegate{
 
    s_facebook.accessToken    = [[NSUserDefaults standardUserDefaults] stringForKey:@"AccessToken"];
    s_facebook.expirationDate = (NSDate *) [[NSUserDefaults standardUserDefaults] objectForKey:@"ExpirationDate"];

    if (![s_facebook isSessionValid]) {
        
        [s_facebook authorize:[FacebookApi permissions] delegate:delegate];
    }
    else {

        [s_facebook requestWithGraphPath:@"me" andDelegate:nil];
    }    
}

+(NSString*) applicationID{
    return s_facebookApplicationID;
}
+(NSString*) apiKey{
    return s_facebookApiKey;
}
+(NSString*) applicationSecret{
    return s_facebookApplicationSecret;
}
+(NSArray*) permissions{
    return [s_facebookPermissions componentsSeparatedByString:@","];
}
+(Facebook*) facebook{
    return s_facebook;
}

+(void) saveSession{

    [[NSUserDefaults standardUserDefaults] setObject:s_facebook.accessToken forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:s_facebook.expirationDate forKey:@"ExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

+(void) deleteSavedSession{
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"AccessToken"];
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"ExpirationDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];    
}

+(void) deInit{
    
    [FacebookApi saveSession];
    
    [s_facebookApplicationID        release];
    [s_facebookApiKey               release];
    [s_facebookApplicationSecret    release];
    [s_facebookPermissions          release];
    [s_facebook                     release];
    [s_facebookApiHelper            release];
    
    if (s_helperInText != nil) {
        
        [s_helperInText release];
    }
}

+(void) freeTempData{

    [s_facebookApiHelper.userIdList removeAllObjects];
    [s_facebookApiHelper.commentList removeAllObjects];
    [s_facebookApiHelper.firstName removeAllObjects];
    [s_facebookApiHelper.lastName removeAllObjects];
    [s_facebookApiHelper.picture removeAllObjects];
}


// Picture related
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) uploadPicture:(UIImage*)picture{

    [FacebookApi stepAdvancer:eUploadPicture];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: picture , @"picture", nil];

    [s_facebook requestWithMethodName:@"photos.upload"
                            andParams:params
                        andHttpMethod:@"POST"
                          andDelegate:s_facebookApiHelper];
}

+(void) uploadPicture:(UIImage*)picture 
          withComment:(NSString*)comment{

    [FacebookApi stepAdvancer:eUploadPictureWithComment];

    [s_helperInText setString:comment];
    [FacebookApi uploadPicture:picture];
}

+(void) uploadPicture:(UIImage*)picture 
              withTag:(NSString*)tag{

    [FacebookApi stepAdvancer:eUploadPictureWithTag];

    [s_helperInText setString:tag];
    [FacebookApi uploadPicture:picture];
}

+(void) uploadPictureOK{
    
    [FacebookApi stepAdvancer];
    [FacebookApi stepRunner];
}

+(void) uploadPictureKO{

    [FacebookApi stepResseter];
}

+(void) uploadPictureWithCommentOK{
    
    [FacebookApi stepAdvancer];
    [FacebookApi stepRunner];    
}

+(void) uploadPictureWithCommentKO{
    
    [FacebookApi stepResseter];
}

+(void) uploadPictureWithTagOK{
    
    [FacebookApi stepAdvancer];
    [FacebookApi stepRunner];
}

+(void) uploadPictureWithTagKO{
    
    [FacebookApi stepResseter];
}


// Profile related
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) getListOfUsersWhoLikedThePhoto:(NSString*)photoId{

    [FacebookApi stepAdvancer:eGetListOfUsersWhoLikedThePhoto];
    
    [FacebookApi getUserIdListWithCommentsWhoLikedThePhoto:photoId];
}

+(void) getUserIdListWithCommentsWhoLikedThePhoto:(NSString*)photoId{
    
    [FacebookApi stepAdvancer:eGetUserIdListWithCommentsWhoLikedThePhoto];
    
    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: 
                                   photoId, @"object_id",
                                   nil];
    
    [s_facebook requestWithMethodName:@"comments.get"
                            andParams:params
                        andHttpMethod:@"POST"
                          andDelegate:s_facebookApiHelper];    
}

+(void) getListOfUsersWhoLikedThePhotoOK{
    
    [FacebookApi stepAdvancer];
    [FacebookApi stepRunner];
}

+(void) getListOfUsersWhoLikedThePhotoKO{
    
    [FacebookApi stepResseter];
}

+(void) getUserIdListWithCommentsWhoLikedThePhotoOK{
    
    [FacebookApi stepAdvancer];
    [FacebookApi stepRunner];
}

+(void) getUserIdListWithCommentsWhoLikedThePhotoKO{

    [FacebookApi stepResseter];
}


// Album related
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
/*
 
 -(void) step1{
 
 //    currentOperation = eCreateAlbum;
 //    
 //    // create the album
 //    NSMutableDictionary* params = [NSMutableDictionary dictionaryWithObjectsAndKeys: [facebookUploadAlbumName text], @"name", nil];
 //    [[FacebookApi facebookApi] requestWithGraphPath:@"me/albums" andParams:params andHttpMethod:@"POST" andDelegate:self];
 //    [params release];    
 }
 
 */

@end
