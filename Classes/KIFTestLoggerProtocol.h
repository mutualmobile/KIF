//
//  KIFTestLoggerProtocol.h
//  KIF
//
//  Created by Kevin Harwood on 1/21/13.
//
//

#import <Foundation/Foundation.h>

@class KIFTestController;
@class KIFTestScenario;
@class KIFTestStep;

@protocol KIFTestLoggerProtocol <NSObject>

- (void)testControllerLogTestingDidStart:(KIFTestController*)testController;

- (void)testControllerLogTestingDidFinish:(KIFTestController*)testController;

- (void)testController:(KIFTestController*)testController logDidStartScenario:(KIFTestScenario *)scenario;

- (void)testController:(KIFTestController*)testController logDidSkipScenario:(KIFTestScenario *)scenario;

- (void)testController:(KIFTestController*)testController logDidSkipAddingScenarioGenerator:(NSString *)selectorString;

- (void)testController:(KIFTestController*)testController logDidFinishScenario:(KIFTestScenario *)scenario duration:(NSTimeInterval)duration;

- (void)testController:(KIFTestController*)testController logDidFailStep:(KIFTestStep *)step duration:(NSTimeInterval)duration error:(NSError *)error;

- (void)testController:(KIFTestController*)testController logDidPassStep:(KIFTestStep *)step duration:(NSTimeInterval)duration;

@end
