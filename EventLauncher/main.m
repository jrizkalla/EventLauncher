//
//  main.m
//  EventLauncher
//
//  Created by John Rizkalla on 2016-04-08.
//  Copyright © 2016 John Rizkalla. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <IOKit/ps/IOPowerSources.h>
#import "EventContext.h"

void power_info_change_callback(void *context);

void print_usage(FILE *file, const char *name){
    fprintf(file, "Usage: %s <configuration file>\n", name);
    fprintf(file, "\nThe configuration files is a plist with the scripts to run for events.\nSee documentation for the list of events\n");
}

int main(int argc, const char * argv[]) {
    
    @autoreleasepool {
        
        if (argc != 2){
            print_usage(stderr, argv[0]);
            return 1;
        }
        
        NSString *fileName = [[NSString alloc] initWithCString: argv[1] encoding: NSUTF8StringEncoding];
        
        EventContext *context;
        @try{
            context = [[EventContext alloc] initWithContentsOfFile:fileName];
        } @catch (NSException *e){
            fprintf(stderr, "Unable to read configuration file\n");
            fprintf(stderr, "Reason: %s\n\n", [e.reason UTF8String]);
            print_usage(stderr, argv[0]);
            return 3;
        }
        
        CFRunLoopSourceRef run_loop_ref = IOPSNotificationCreateRunLoopSource(&power_info_change_callback, (__bridge void *)(context));
        assert(run_loop_ref);
        
        CFRunLoopRef run_loop = CFRunLoopGetMain();
        CFRunLoopAddSource(run_loop, run_loop_ref, kCFRunLoopCommonModes);
        CFRunLoopRun();
    }
    return 0;
}
