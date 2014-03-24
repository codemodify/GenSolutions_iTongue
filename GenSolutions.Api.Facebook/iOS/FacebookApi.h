
#import <Foundation/Foundation.h>
#import "FBConnect/FBConnect.h"

@protocol FacebookApiDelegate <NSObject> 

@optional
-(void) uploadPictureDidFinish:(NSString*)pictureId;
-(void) uploadPictureDidNotFinish:(NSString*)errorMessage;

-(void) uploadPictureWithCommentDidFinish:(NSString*)pictureId;
-(void) uploadPictureWithCommentDidNotFinish:(NSString*)errorMessage;

-(void) uploadPictureWithTagDidFinish:(NSString*)pictureId;
-(void) uploadPictureWithTagDidNotFinish:(NSString*)errorMessage;

-(void) getListOfUsersWhoLikedThePhotoDidFinish:(NSArray*)userIdList 
                                    commentList:(NSArray*)commentList 
                                       firstName:(NSDictionary*)firstName 
                                       lastName:(NSDictionary*)lastName
                                        picture:(NSDictionary*)picture;
-(void) getListOfUsersWhoLikedThePhotoDidNotFinish:(NSString*)errorMessage;
@end


@interface FacebookApi : NSObject {}

// Session related
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) initWithApplicationID:(NSString*)applicationID
                       apiKey:(NSString*)apiKey
            applicationSecret:(NSString*)applicationSecret
                  permissions:(NSString*)permissions;

+(void) setDelegate:(id <FacebookApiDelegate>)delegate;
+(void) loadSession;
+(void) loadSessionWithAuthorize:(id <FBSessionDelegate>)delegate;

+(NSString*) applicationID;
+(NSString*) apiKey;
+(NSString*) applicationSecret;
+(NSArray*) permissions;
+(Facebook*) facebook;

+(void) saveSession;
+(void) deleteSavedSession;
+(void) deInit;
+(void) freeTempData;


// Picture related
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) uploadPicture:(UIImage*)picture;
+(void) uploadPicture:(UIImage*)picture withComment:(NSString*)comment;
+(void) uploadPicture:(UIImage*)picture withTag:(NSString*)tag;

+(void) uploadPictureOK;            // notifcation, used internally, never call this
+(void) uploadPictureKO;            // notifcation, used internally, never call this
+(void) uploadPictureWithCommentOK; // notifcation, used internally, never call this
+(void) uploadPictureWithCommentKO; // notifcation, used internally, never call this
+(void) uploadPictureWithTagOK;     // notifcation, used internally, never call this
+(void) uploadPictureWithTagKO;     // notifcation, used internally, never call this


// Profile related
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
+(void) getUserIdListWithCommentsWhoLikedThePhoto:(NSString*)photoId;
+(void) getListOfUsersWhoLikedThePhoto:(NSString*)photoId;

+(void) getUserIdListWithCommentsWhoLikedThePhotoOK;    // notifcation, used internally, never call this
+(void) getUserIdListWithCommentsWhoLikedThePhotoKO;    // notifcation, used internally, never call this
+(void) getListOfUsersWhoLikedThePhotoOK;   // notifcation, used internally, never call this
+(void) getListOfUsersWhoLikedThePhotoKO;   // notifcation, used internally, never call this

@end
