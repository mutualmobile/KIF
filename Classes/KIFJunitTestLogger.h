//
//  KIFJunitTestLogger.h
//  KIF
//
//  Created by Rodney Gomes on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "KIFTestLoggerProtocol.h"
#import "NSFileManager-KIFAdditions.h"

#import "KIFTestController.h"
#import "KIFBaseScenario.h"
#import "KIFTestStep.h"

@interface KIFJunitTestLogger : NSObject <KIFTestLoggerProtocol> {
}

@property (nonatomic, retain) NSString *logDirectoryPath;

- (id)initWithLogDirectoryPath:(NSString*)path;

@end
