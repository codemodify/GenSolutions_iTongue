
#import "Logger.h"


@implementation Logger

+(void) logMessage:(NSString*) message withPrefix:(NSString*)prefix {
    NSLog( @"%@ : %@", prefix, message );
}

+(void) logTrace:(NSString*) message {
    [self logMessage:message withPrefix:@"Trace"];
}

+(void) logDebug:(NSString*) message {
#ifdef DEBUG
    [self logMessage:message withPrefix:@"Debug"];
#endif
}

+(void) logInfo:(NSString*) message {
    [self logMessage:message withPrefix:@"Info"];
}

+(void) logWarning:(NSString*) message {
    [self logMessage:message withPrefix:@"Warning"];
}

+(void) logError:(NSString*) message {
    [self logMessage:message withPrefix:@"Error"];
}

+(void) logTechnicalInfo:(NSString*) message {
    [self logMessage:message withPrefix:@"TechnicalInfo"];
}

+(void) logTechnicalWarning:(NSString*) message {
    [self logMessage:message withPrefix:@"TechnicalWarning"];
}

+(void) logTechnicalError:(NSString*) message {
    [self logMessage:message withPrefix:@"TechnicalError"];
}

@end
