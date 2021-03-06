//
//  EventContext.m
//  EventLauncher
//
//  Created by John Rizkalla on 2016-04-08.
//  Copyright © 2016 John Rizkalla. All rights reserved.
//

#import "EventContext.h"
#import <IOKit/ps/IOPowerSources.h>

@implementation EventContext

@synthesize currentPowerSrc = _currentPowerSrc;

-(id) init {
    [NSException raise:@"Unsuported constructor" format:@"init is not supported. Please use initWithContentsOfFile"];
    return NULL;
}

-(id) initWithContentsOfFile:(NSString *)path {
    if (self = [super init]){
        
        // Validate plistDict (all values are either strings or arrays of strings)
        NSMutableDictionary *plistDict = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
        for (id key in [plistDict allKeys]){
            id obj = [plistDict objectForKey: key];
            if ([obj isKindOfClass: [NSArray class]]){
                // make sure all the items are strings
                for (id item in (NSArray *)obj){
                    if (![item isKindOfClass: [NSString class]]){
                        [NSException raise: @"Invalid configuration file format" format: @"Values in arrays must all be strings"];
                    }
                }
            } else {
                // make sure it's a string
                if (![obj isKindOfClass: [NSString class]]){
                    [NSException raise: @"Invalid configuration file format" format:@"Values must be arrays or strings"];
                }
                // Replace it with an array
                NSArray *arr = @[obj];
                [plistDict setObject:arr forKey:key];
            }
        }
        
        self.scripts = [NSDictionary dictionaryWithDictionary: plistDict]; // make it non-mutable
        
        for (id key in self.scripts){
            printf("%s:\n", [(NSString *)key UTF8String]);
            for (id str in [self.scripts objectForKey:key]){
                printf("\t%s\n", [(NSString *)str UTF8String]);
            }
        }
        
        // What is the current state of the machine?
        CFTypeRef power_src_ref = IOPSCopyPowerSourcesInfo();
        NSString *power_src = (NSString *)CFBridgingRelease(IOPSGetProvidingPowerSourceType(power_src_ref));
        assert([power_src isEqualToString:@"Battery Power"] || [power_src isEqualToString:@"AC Power"]);
        
        _currentPowerSrc = power_src;
        
        CFRelease(power_src_ref);
    }
    return self;
}

-(NSString *) getCurrentPowerSrc {
    return _currentPowerSrc;
}

-(void) setCurrentPowerSrc:(NSString *)currentPowerSrc{
    if ([currentPowerSrc isEqualToString: @"Battery Power"] || [currentPowerSrc isEqualToString: @"AC Power"]){
        _currentPowerSrc = currentPowerSrc;
    } else {
        [NSException raise: NSInvalidArgumentException format:@"currentPowerSrc must be \"Battery Power\" or \"AC Power\""];
    }
}

@end
