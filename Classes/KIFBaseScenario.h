//
//  KIFBaseScenario.h
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <Foundation/Foundation.h>

#import "KIFTestResult.h"



@class KIFTestStep;



@interface KIFBaseScenario : NSObject <KIFTestResult>

@property (nonatomic, strong) id result;
@property (nonatomic) BOOL returnsResult;

/*!
 @property description
 @abstract A description of what the scenario tests.
 @discussion This should be a thorough description of what the scenario is testing so that if the test fails it is clear which test it was.
 */
@property (nonatomic, retain) NSString *description;

/*!
 @property skippedByFilter
 @abstract Whether this scenario is being skipped
 @discussion Set the KIF_SCENARIO_FILTER environment variable to skip all scenarios not matching the variable's value
 */
@property (nonatomic, readonly) BOOL skippedByFilter;

/*!
 @method scenarioWithDescription
 @abstract Create a new scenario.
 @param description A description of what the scenario is testing.
 @result An initialized scenario.
 @discussion Creates a new instance of the scenario with a given description. As part of creating the instance, @link initializeSteps initializeSteps @/link will be called, so calling this method on a subclass of KIFTestScenario will return a fully initialized scenario.
 */
+ (id)scenarioWithDescription:(NSString *)description;
- (id)initWithDescription:(NSString *)description;

- (KIFTestStep *)currentStep;

- (void)start;
- (void)advanceToNextStep;

/*!
 @method initializeSteps;
 @abstract A place for subclasses to add steps.
 @discussion This is lazily called the first time the steps property is accessed. Subclasses can use model information to customize the set of steps that are returned.
 */
- (void)initializeSteps;

- (NSString *)stepDescription;

- (id)stateForKey:(NSString *)key;
- (void)setState:(id)state forKey:(NSString *)key;

@end
