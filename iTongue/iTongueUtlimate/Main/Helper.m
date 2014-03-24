//
//  Helper.m
//  iTongue
//
//  Created by nicu on 11/8/1.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Helper.h"

@implementation Helper

+(NSString*) getSettingsVariableNameForThisVersion:(NSString*)variableName{

    NSString* appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    return [NSString stringWithFormat:@"%@_%@", variableName, appVersion];
}

@end
