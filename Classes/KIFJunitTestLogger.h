//
//  KIFJunitTestLogger.h
//  KIF
//
//  Created by Rodney Gomes on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KIFTestLogger.h"
#import "NSFileManager-KIFAdditions.h"

@interface KIFJunitTestLogger : KIFTestLogger {
    NSFileHandle* fileHandle;
}

@property (nonatomic, retain) NSFileHandle *fileHandle;
@property (nonatomic, retain) NSString *logDirectoryPath;

@end
