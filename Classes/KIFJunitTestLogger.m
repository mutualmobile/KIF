//
//  KIFJunitTestLogger.m
//  KIF
//
//  Created by Rodney Gomes on 1/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KIFJunitTestLogger.h"

@interface KIFJunitTestLogger ()

@property (nonatomic, retain) NSFileHandle *fileHandle;

@end

@implementation KIFJunitTestLogger

static NSMutableDictionary* durations = nil;
static NSMutableDictionary* errors = nil;
static KIFTestScenario* currentScenario = nil;

-(id)initWithLogDirectoryPath:(NSString*)path{
    self = [self init];
    if(self){
        [self setLogDirectoryPath:path];
    }
    return self;
}

-(id)init{
    self = [self init];
    if(self){
        if (durations == nil) {
            durations = [[NSMutableDictionary alloc] init];
        }
        
        if (errors == nil) {
            errors = [[NSMutableDictionary alloc] init];
        }
    }
    return self;
}

-(NSFileHandle*)fileHandle{
    
    if (!_fileHandle) {
        NSString *logsDirectory;
        if (!self.logDirectoryPath) {
            logsDirectory = [[NSFileManager defaultManager] createUserDirectory:NSLibraryDirectory];
            if (logsDirectory) {
                logsDirectory = [logsDirectory stringByAppendingPathComponent:@"Logs"];
            }
        }
        else{
            logsDirectory = self.logDirectoryPath;
        }
        
        
        if (![[NSFileManager defaultManager] recursivelyCreateDirectory:logsDirectory]) {
            logsDirectory = nil;
        }
        
        NSString *dateString = [NSDateFormatter localizedStringFromDate:[NSDate date] dateStyle:NSDateFormatterMediumStyle
                                                              timeStyle:NSDateFormatterLongStyle];
        dateString = [dateString stringByReplacingOccurrencesOfString:@"/" withString:@"."];
        dateString = [dateString stringByReplacingOccurrencesOfString:@":" withString:@"."];
        NSString *fileName = [NSString stringWithFormat:@"KIF Tests %@.junit.xml", dateString];
        
        NSString *logFilePath = [logsDirectory stringByAppendingPathComponent:fileName];
        
        if (![[NSFileManager defaultManager] fileExistsAtPath:logFilePath]) {
            [[NSFileManager defaultManager] createFileAtPath:logFilePath contents:[NSData data] attributes:nil];
        }
        
        _fileHandle = [[NSFileHandle fileHandleForWritingAtPath:logFilePath] retain];
        
        if (_fileHandle) {
            NSLog(@"JUNIT XML RESULTS AT %@", logFilePath);
        }
    }
    
    return _fileHandle;
}

- (void)appendToLog:(NSString*) data
{
    [self.fileHandle writeData:[data dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void)dealloc;
{
    [_fileHandle closeFile];
    [_fileHandle release];
    self.logDirectoryPath = nil;
    [errors release];
    [durations release];
    [super dealloc];
}

#pragma mark - Log Methods
- (void)testControllerLogTestingDidStart:(KIFTestController*)testController;
{

}

- (void)testControllerLogTestingDidFinish:(KIFTestController*)testController;
{
    NSTimeInterval totalDuration = -[testController.testSuiteStartDate timeIntervalSinceNow];
    NSString* data = [NSString stringWithFormat: @"<testsuite name=\"%@\" tests=\"%d\" failures=\"%d\" time=\"%0.4f\">\n",
                      @"KIF Tests", [testController.scenarios count], testController.failureCount, totalDuration];
    
    [self appendToLog:data];
    
    for (KIFTestScenario* scenario in testController.scenarios) { 
        NSNumber* duration = [durations objectForKey: [scenario description]];
        NSError* error = [errors objectForKey: [scenario description]];
        
        
        NSString* scenarioSteps = [[scenario.steps valueForKeyPath:@"description"] componentsJoinedByString:@"\n"];
        NSString* errorMsg =  (error ? [NSString stringWithFormat:@"<failure message=\"%@\">%@</failure>", 
                                        [error localizedDescription], scenarioSteps] :
                               @"");
        
        NSString* description = [scenario description];
        NSString* classString = NSStringFromClass([scenario class]);
        
        data = [NSString stringWithFormat:@"<testcase name=\"%@\" class=\"%@\" time=\"%0.4f\">%@</testcase>\n",
                                          description, classString, [duration doubleValue], errorMsg];
        [self appendToLog:data];
    }
        
    [self appendToLog:@"</testsuite>\n"];
}

- (void)testController:(KIFTestController*)testController logDidStartScenario:(KIFTestScenario *)scenario;
{
    currentScenario = scenario;
}

- (void)testController:(KIFTestController*)testController logDidSkipScenario:(KIFTestScenario *)scenario;
{

}

- (void)testController:(KIFTestController*)testController logDidSkipAddingScenarioGenerator:(NSString *)selectorString;
{
    
}

- (void)testController:(KIFTestController*)testController logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration;
{
    NSNumber* number = [[NSNumber alloc] initWithDouble: duration];
    [durations setValue: number forKey: [scenario description]];
}

- (void)testController:(KIFTestController*)testController logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;
{
    [errors setValue:error forKey:[currentScenario description]];
}

- (void)testController:(KIFTestController*)testController logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;
{
    
}

@end
