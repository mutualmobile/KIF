//
//  KIFSequenceScenario.m
//  KIF
//
//  Created by Justin Kolb on 2/5/13.
//
//

#import "KIFSequenceScenario.h"
#import "KIFTestStep.h"


static NSArray *defaultStepsToSetUp = nil;
static NSArray *defaultStepsToTearDown = nil;


@interface KIFSequenceScenario ()

@property (nonatomic) NSUInteger currentStepIndex;
@property (nonatomic, readwrite, retain) NSArray *steps;

- (void)_initializeStepsIfNeeded;

@end


@implementation KIFSequenceScenario

@synthesize steps;
@synthesize stepsToSetUp;
@synthesize stepsToTearDown;

#pragma mark Static Methods

+ (void)setDefaultStepsToSetUp:(NSArray *)steps;
{
    if (defaultStepsToSetUp == steps) {
        return;
    }
    
    [defaultStepsToSetUp release];
    defaultStepsToSetUp = [steps copy];
}

+ (NSArray *)defaultStepsToSetUp;
{
    return defaultStepsToSetUp;
}

+ (void)setDefaultStepsToTearDown:(NSArray *)steps;
{
    if (defaultStepsToTearDown == steps) {
        return;
    }
    
    [defaultStepsToTearDown release];
    defaultStepsToTearDown = [steps copy];
}

+ (NSArray *)defaultStepsToTearDown;
{
    return defaultStepsToTearDown;
}

#pragma mark Initialization

- (id)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    stepsToSetUp = [defaultStepsToSetUp copy];
    stepsToTearDown = [defaultStepsToTearDown copy];
    
    return self;
}

- (void)dealloc
{
    [steps release]; steps = nil;
    [stepsToSetUp release]; stepsToSetUp = nil;
    [stepsToTearDown release]; stepsToTearDown = nil;
    
    [super dealloc];
}

#pragma mark Public Methods

- (KIFTestStep *)currentStep {
    if (self.currentStepIndex >= [self.steps count]) {
        return nil;
    }
    
    id step = [self.steps objectAtIndex:self.currentStepIndex];
    
    if ([step isKindOfClass:[KIFTestScenario class]]) {
        KIFTestScenario *scenario = step;
        
        return [scenario currentStep];
    } else {
        return step;
    }
}

- (void)start {
    self.currentStepIndex = 0;
    id step = [self.steps objectAtIndex:self.currentStepIndex];
    
    if ([step isKindOfClass:[KIFTestScenario class]]) {
        KIFTestScenario *scenario = step;
        [scenario start];
    }
}

- (void)advanceToNextStep {
    id <KIFTestResult> stepObject = [self.steps objectAtIndex:self.currentStepIndex];
    
    if ([stepObject isKindOfClass:[KIFTestScenario class]]) {
        KIFTestScenario *scenario = stepObject;
        
        if (scenario.returnsResult) {
            id <KIFTestResult> resultObject = [scenario currentStep];
            scenario.result = [resultObject result];
        }
        
        [scenario advanceToNextStep];
        id nextStepObject = [scenario currentStep];
        
        if (nextStepObject == nil) {
            // This sub-scenario is finished
            ++self.currentStepIndex;
        }
    } else {
        ++self.currentStepIndex;
    }
}

- (void)initializeSteps;
{
    // For subclasses
}

- (NSArray *)steps;
{
    [self _initializeStepsIfNeeded];
    return steps;
}

- (void)addStep:(id)step;
{
    NSAssert(![steps containsObject:step], @"The step %@ is already added", step);
    
    [self _initializeStepsIfNeeded];
    [steps insertObject:step atIndex:(steps.count - self.stepsToTearDown.count)];
}

- (void)addStepsFromArray:(NSArray *)inSteps;
{
    for (id step in inSteps) {
        NSAssert(![steps containsObject:step], @"The step %@ is already added", step);
    }
    
    [self _initializeStepsIfNeeded];
    [steps insertObjects:inSteps atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(steps.count - self.stepsToTearDown.count, inSteps.count)]];
}

- (void)insertStep:(id)step afterStep:(id)previousStep{
    NSAssert(![steps containsObject:step], @"The step %@ is already added", step);
    NSAssert([steps containsObject:previousStep], @"The step %@ has not been added", previousStep);
    
    [self _initializeStepsIfNeeded];
    NSUInteger index = [steps indexOfObject:previousStep];
    
    [steps insertObject:step atIndex:index+1];
}

- (void)insertStepsFromArray:(NSArray*)inSteps afterStep:(id)previousStep{
    NSAssert([steps containsObject:previousStep], @"The step %@ has not been added", previousStep);
    for (id step in inSteps) {
        NSAssert(![steps containsObject:step], @"The step %@ is already added", step);
    }
    
    NSUInteger index = [steps indexOfObject:previousStep];
    [steps insertObjects:inSteps atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index+1, inSteps.count)]];
}

- (NSUInteger)indexOfStep:(id)step{
    NSAssert([steps containsObject:step], @"The step %@ is not added", step);
    return [steps indexOfObject:step];
}

- (void)insertStep:(id)step atIndex:(NSUInteger)index{
    NSAssert(![steps containsObject:step], @"The step %@ is already added", step);
    [steps insertObject:step atIndex:index];
}

- (void)setStepsToSetUp:(NSArray *)inStepsToSetUp;
{
    if ([stepsToSetUp isEqual:inStepsToSetUp]) {
        return;
    }
    
    // Remove the old set up steps and add the new ones
    // If steps hasn't been set up yet, that's fine
    [steps removeObjectsInRange:NSMakeRange(0, stepsToSetUp.count)];
    [steps insertObjects:inStepsToSetUp atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, inStepsToSetUp.count)]];
    
    [stepsToSetUp release];
    stepsToSetUp = [inStepsToSetUp copy];
}

- (void)setStepsToTearDown:(NSArray *)inStepsToTearDown;
{
    if ([stepsToTearDown isEqual:inStepsToTearDown]) {
        return;
    }
    
    // Remove the old tear down steps and add the new ones
    // If steps hasn't been set up yet, that's fine
    [steps removeObjectsInRange:NSMakeRange(steps.count - stepsToTearDown.count, stepsToTearDown.count)];
    [steps insertObjects:inStepsToTearDown atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(steps.count, inStepsToTearDown.count)]];
    
    [stepsToTearDown release];
    stepsToTearDown = [inStepsToTearDown copy];
}

- (NSString *)stepDescription {
    return [[self.steps valueForKeyPath:@"description"] componentsJoinedByString:@"\n"];
}

#pragma mark Private Methods

- (void)_initializeStepsIfNeeded;
{
    if (!steps && !self.skippedByFilter) {
        NSMutableArray *initialSteps = [NSMutableArray arrayWithArray:self.stepsToSetUp];
        [initialSteps addObjectsFromArray:self.stepsToTearDown];
        self.steps = initialSteps;
        [self initializeSteps];
    }
}

@end
