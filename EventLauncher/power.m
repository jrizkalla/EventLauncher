//
//  power.m
//  EventLauncher
//
//  Created by John Rizkalla on 2016-04-08.
//  Copyright © 2016 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/ps/IOPowerSources.h>
#import "EventContext.h"


/**
 * Callback when the power source changes. Runs 
 * switch-to-battery-power or swtich-to-ac-power scripts
 * @param context an instance of EventContext
 */
void power_info_change_callback(void *context){
    EventContext *c = (__bridge EventContext *)context;
    
    CFTypeRef power_src_ref = IOPSCopyPowerSourcesInfo();
    NSString *power_src = (NSString *)CFBridgingRelease(IOPSGetProvidingPowerSourceType(power_src_ref));
    
    if (![c.currentPowerSrc isEqualToString: power_src]){
        c.currentPowerSrc = power_src;
        
        if ([c.currentPowerSrc isEqualToString:@"Battery Power"]){
            NSArray *scripts = [c.scripts objectForKey:@"switch-to-battery-power"];
            for (id scrpt in scripts){
                system([(NSString *)scrpt cStringUsingEncoding: NSASCIIStringEncoding]);
            }
            
        } else { // AC Power
            NSArray *scripts = [c.scripts objectForKey:@"switch-to-ac-power"];
            for (id scrpt in scripts){
                system([(NSString *)scrpt cStringUsingEncoding: NSASCIIStringEncoding]);
            }
        }
    }
    
    CFRelease(power_src_ref);
}