
#import <Foundation/Foundation.h>

@interface MREntitiesConverter : NSObject {
    NSMutableString* resultString;
}

@property (nonatomic, retain) NSMutableString* resultString;

- (NSString*)convertEntiesInString:(NSString*)s;

@end