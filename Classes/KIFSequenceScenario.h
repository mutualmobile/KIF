//
//  KIFSequenceScenario.h
//  KIF
//
//  Created by Justin Kolb on 2/5/13.
//
//

#import "KIFTestScenario.h"



/*!
 @class KIFTestScenario
 @abstract A single scenario to be tested.
 @discussion A scenario represents a small, but cohesive unit of testing that usually maps to an available user action, such as logging in, or sending a message. Scenarios are comprised of smaller steps (represented by KIFTestSteps) for discrete interactions, such as tapping a button.
 
 A convenient practice is to add a category on KIFTestScenario which includes factory methods to create the scenarios you want to test. This provides a useful identifier for each scenario via the method name (something like +scenarioToLogInSuccessfully), and also provides an organized place for your application-specific scenarios.
 */
@interface KIFSequenceScenario : KIFTestScenario {
    NSMutableArray *steps;
    NSMutableArray *stepsToSetUp;
    NSMutableArray *stepsToTearDown;
}

/*!
 @property steps
 @abstract The steps that comprise the scenario.
 @discussion The steps are instances of KIFTestStep (or a subclass). This method returns all steps, including the steps to set up and the steps to tear down.
 */
@property (nonatomic, readonly, retain) NSArray *steps;

/*!
 @property stepsToSetUp
 @abstract Steps that will be executed at the beginning of the scenario.
 @discussion The steps to set up are an array of KIFTestStep (or subclass) instances that will be executed at the beginning of the scenario, before the steps specified in the -steps property. When initializing the scenario these steps are defaulted to the steps specified by +defaultStepsToSetUp, but may be overridden by setting them directly using this property.
 */
@property (nonatomic, copy) NSArray *stepsToSetUp;

/*!
 @property stepsToTearDown
 @abstract Steps that will be executed at the end of the scenario.
 @discussion The steps to tear down are an array of KIFTestStep (or subclass) instances that will be executed at the end of the scenario, after the steps specified in the -steps property. When initializing the scenario these steps are defaulted to the steps specified by +defaultStepsToTearDown, but may be overridden by setting them directly using this property.
 */
@property (nonatomic, copy) NSArray *stepsToTearDown;

/*!
 @method setDefaultStepsToSetUp:
 @abstract Set the default setup steps that will be added to new scenarios.
 @param The default setup steps.
 @discussion When initializing a new scenario these steps are set as the stepsToSetUp on the scenario.
 */
+ (void)setDefaultStepsToSetUp:(NSArray *)steps;

/*!
 @method defaultStepsToSetUp
 @abstract The default setup steps that will be added to new scenarios.
 @result The default setup steps.
 @discussion When initializing a new scenario these steps are set as the stepsToSetUp on the scenario. These default steps can be set using +setDefaultStepsToSetUp:
 */
+ (NSArray *)defaultStepsToSetUp;

/*!
 @method setDefaultStepsToTearDown:
 @abstract Set the default tear down steps that will be added to new scenarios.
 @param The default tear down steps.
 @discussion When initializing a new scenario these steps are set as the stepsToTearDown on the scenario.
 */
+ (void)setDefaultStepsToTearDown:(NSArray *)steps;

/*!
 @method defaultStepsToTearDown
 @abstract The default tear down steps that will be added to new scenarios.
 @result The default tear down steps.
 @discussion When initializing a new scenario these steps are set as the stepsToTearDown on the scenario. These default steps can be set using +setDefaultStepsToTearDown:
 */
+ (NSArray *)defaultStepsToTearDown;

/*!
 @method addStep:
 @abstract Add a step to the scenario.
 */
- (void)addStep:(KIFTestStep *)step;

/*!
 @method addStepsFromArray:
 @abstract Add multiple steps to the scenario from an array.
 */
- (void)addStepsFromArray:(NSArray *)steps;

/*!
 @method insertStep:afterStep:;
 @abstract Insert a step to a scenerio after a specific step
 */
- (void)insertStep:(KIFTestStep *)step afterStep:(KIFTestStep*)previousStep;

/*!
 @method insertStepsFromArray:afterStep:
 @abstract Add multiple steps to the scenario from an array after a specific step.
 */
- (void)insertStepsFromArray:(NSArray*)inSteps afterStep:(KIFTestStep*)previousStep;

/*!
 @method indexOfStep:
 @abstract Grab the index of a specific step
 */
- (NSUInteger)indexOfStep:(KIFTestStep*)step;

/*!
 @method insertStep:atIndex:;
 @abstract Insert a step to a scenerio at a specific index
 */
- (void)insertStep:(KIFTestStep*)step atIndex:(NSUInteger)index;

@end
