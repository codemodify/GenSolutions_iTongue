
#import <Foundation/Foundation.h>

// Delegates
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@protocol GoogleTranslateDelegate;

@class MREntitiesConverter;

// Class
// ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ---- ----
@interface GoogleTranslate : NSObject {

    NSMutableData* mutableData;
    MREntitiesConverter* decoder;
    
    id<GoogleTranslateDelegate> delegate;
}

@property (nonatomic, assign) id<GoogleTranslateDelegate> delegate;

-(void) translate:(NSString*)text source:(NSString*)source destination:(NSString*)destination;

@end




@protocol GoogleTranslateDelegate

-(void) textTranslated:(NSString*)text translator:(GoogleTranslate*)translator;
-(void) textFailedToTranslate:(NSString*)error translator:(GoogleTranslate*)translator;

@end
