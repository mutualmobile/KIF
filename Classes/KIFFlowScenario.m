//
//  KIFFlowScenario.m
//  KIF
//
//  Created by Justin Kolb on 2/5/13.
//
//

#import "KIFFlowScenario.h"
#import "KIFTestStep.h"
#import "KIFTestResult.h"



@interface KIFFlowScenario ()

@property (nonatomic, strong) NSString *startStepName;
@property (nonatomic, strong) NSMutableDictionary *steps;
@property (nonatomic, strong) NSString *currentStepName;
@property (nonatomic, strong) NSMutableDictionary *transitions;

@end



@implementation KIFFlowScenario

- (id)initWithDescription:(NSString *)description {
    self = [super initWithDescription:description];
    
    if (self == nil) {
        return nil;
    }
    
    _steps = [[NSMutableDictionary alloc] init];
    
    if (_steps == nil) {
        [self release];
        
        return nil;
    }

    _transitions = [[NSMutableDictionary alloc] init];
    
    if (_transitions == nil) {
        [self release];
        
        return nil;
    }
    
    return self;
}

- (void)dealloc {
    [_steps release]; _steps = nil;
    [_transitions release]; _transitions = nil;
    
    [super dealloc];
}

- (void)addSteps:(NSDictionary *)steps {
    for (id key in steps) {
        id object = [steps objectForKey:key];
        [self addStep:object forName:key];
    }
}

- (void)addStep:(id)step forName:(NSString *)name {
    [self.steps setObject:step forKey:name];
}

- (void)startAt:(NSString *)start {
    self.startStepName = start;
}

- (void)transitionFrom:(NSString *)from to:(NSString *)to {
    [self transitionFrom:from onResult:nil to:to];
}

- (void)transitionFrom:(NSString *)from onResult:(id)result to:(NSString *)to {
    NSMutableDictionary *stepTransitions = [self.transitions objectForKey:from];
    
    if (stepTransitions == nil) {
        stepTransitions = [NSMutableDictionary dictionaryWithCapacity:1];
        [self.transitions setObject:stepTransitions forKey:from];
    }
    
    if (result == nil) {
        [stepTransitions setObject:to forKey:[NSNull null]];
    } else {
        [stepTransitions setObject:to forKey:result];
    }
}

- (KIFTestStep *)currentStep {
    id step = [self.steps objectForKey:self.currentStepName];
    
    if ([step isKindOfClass:[KIFTestScenario class]]) {
        KIFTestScenario *scenario = step;
        
        return [scenario currentStep];
    } else {
        return step;
    }
}

- (void)start {
    self.currentStepName = self.startStepName;
    id step = [self.steps objectForKey:self.currentStepName];
    
    if ([step isKindOfClass:[KIFTestScenario class]]) {
        KIFTestScenario *scenario = step;
        [scenario start];
    }
}

- (void)advanceToNextStep {
    id <KIFTestResult> stepObject = [self.steps objectForKey:self.currentStepName];
    
    if ([stepObject isKindOfClass:[KIFTestScenario class]]) {
        KIFTestScenario *scenario = stepObject;
        id <KIFTestResult> resultObject = [scenario currentStep];
        scenario.result = [resultObject result];
        [scenario advanceToNextStep];
        id nextStepObject = [scenario currentStep];
        
        if (nextStepObject == nil) {
            // This sub-scenario is finished
            [self transitionFrom:self.currentStepName withResult:scenario.result];
        }
    } else {
        [self transitionFrom:self.currentStepName withResult:[stepObject result]];
    }
}

- (void)transitionFrom:(NSString *)from withResult:(id)result {
    self.currentStepName = [self nextStepNameAfter:from withResult:result];
    id nextStepObject = [self.steps objectForKey:self.currentStepName];
    
    if ([nextStepObject isKindOfClass:[KIFTestScenario class]]) {
        KIFTestScenario *nextScenario = nextStepObject;
        [nextScenario start];
    }
}

- (NSString *)nextStepNameAfter:(NSString *)step withResult:(id)result {
    NSDictionary *stepTransitions = [self.transitions objectForKey:step];

    if (stepTransitions == nil) {
        return nil;
    }
    
    if (result == nil) {
        return [stepTransitions objectForKey:[NSNull null]];
    } else {
        return [stepTransitions objectForKey:result];
    }
}

- (NSString *)stepDescription {
    return [super stepDescription];
}

@end
