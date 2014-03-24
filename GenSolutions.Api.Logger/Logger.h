
#import <Foundation/Foundation.h>


@interface Logger : NSObject {

}

+(void) logTrace            :(NSString*) message;
+(void) logDebug            :(NSString*) message;

+(void) logInfo             :(NSString*) message;
+(void) logWarning          :(NSString*) message;
+(void) logError            :(NSString*) message;

+(void) logTechnicalInfo    :(NSString*) message;
+(void) logTechnicalWarning :(NSString*) message;
+(void) logTechnicalError   :(NSString*) message;

@end
