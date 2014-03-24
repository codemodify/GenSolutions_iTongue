
#import <Foundation/Foundation.h>
#import "FBConnect/FBConnect.h"

typedef enum {
    
    eNothing,
    
    eUploadPicture,
    eUploadPictureWithComment,
    eUploadPictureWithTag,
    eGetUserIdListWithCommentsWhoLikedThePhoto,
    eGetListOfUsersWhoLikedThePhoto,

    eNotify

} Step;

typedef struct {
    
    NSString* firstName;
    NSString* lastName;
    UIImage* picture;
} UserProfile;

@interface FacebookApiHelper : NSObject< FBRequestDelegate > {

    Step currentStep;
    Step nextStep;
    NSMutableString* uploadedPhotoId;   // used at eUploadPicture
    NSMutableArray* userIdList;         // used at eGetUserIdListWithCommentsWhoLikedThePhoto
    NSMutableArray* commentList;        // used at eGetUserIdListWithCommentsWhoLikedThePhoto
    NSMutableDictionary* firstName;  // used at eGetListOfUsersWhoLikedThePhoto
    NSMutableDictionary* lastName;  // used at eGetListOfUsersWhoLikedThePhoto
    NSMutableDictionary* picture;   // used at eGetListOfUsersWhoLikedThePhoto
    NSMutableString* lastErrorMessage;
}

@property (nonatomic, assign) Step currentStep;
@property (nonatomic, assign) Step nextStep;
@property (nonatomic, assign) NSMutableString* uploadedPhotoId;
@property (nonatomic, assign) NSMutableArray* userIdList;
@property (nonatomic, assign) NSMutableArray* commentList;
@property (nonatomic, assign) NSMutableDictionary* firstName;
@property (nonatomic, assign) NSMutableDictionary* lastName;
@property (nonatomic, assign) NSMutableDictionary* picture;
@property (nonatomic, assign) NSMutableString* lastErrorMessage;

@end
