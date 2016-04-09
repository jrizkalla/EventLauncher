//
//  EventContext.h
//  EventLauncher
//
//  Created by John Rizkalla on 2016-04-08.
//  Copyright © 2016 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 * The main object used to keep state
 */
@interface EventContext : NSObject

/**
 * A dictionary of scripts to run for keys. Each value is an array of strings
 */
@property (atomic) NSDictionary *scripts;

/**
 * The current power source (Battery Power or AC Power)
 */
@property (atomic, setter=setCurrentPowerSrc:, getter=getCurrentPowerSrc) NSString *currentPowerSrc;


/**
 * Throws an error. Use initWithContentsOfFile instead
 */
-(id) init;

/**
 * Initializes this object from a plist at path
 * @param path the path of the plist configuration file
 */
-(id) initWithContentsOfFile: (NSString *)path;

/**
 * Sets the power source
 * @param currentPowerSrc the new power source (Battery Power or AC Power)
 */
-(void) setCurrentPowerSrc:(NSString *)currentPowerSrc;
/**
 * @returns the current power source
 */
-(NSString *) getCurrentPowerSrc;

@end
