
#import <UIKit/UIKit.h>


@interface MessageListController : UITableViewController {

    UIView* view;
    
    NSArray* userPictureList;
    NSArray* userNameList;
    NSArray* userCommentList;
}

-(id) initWithShapeImage:(UIImage*)shapeImage 
        parentLeftOffset:(CGFloat)parentLeftOffset 
         parentTopOffset:(CGFloat)parentTopOffset
       contentLeftOffset:(CGFloat)contentLeftOffset
        contentTopOffset:(CGFloat)contentTopOffset
      contentRightOffset:(CGFloat)contentRightOffset
     contentBottomOffset:(CGFloat)contentBottomOffset;

-(void) setUserPictureList:(NSArray*)listOfUsersPictures
              userNameList:(NSArray*)listOfUsersNames
           userCommentList:(NSArray*)listOfUsersComments;

-(void) syncViewWithModel;

-(UIView*) getView;

@end
