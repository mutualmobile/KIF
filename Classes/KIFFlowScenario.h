//
//  KIFFlowScenario.h
//  KIF
//
//  Created by Justin Kolb on 2/5/13.
//
//

#import "KIFTestScenario.h"



@class KIFTestStep;



@interface KIFFlowScenario : KIFTestScenario

- (void)addSteps:(NSDictionary *)steps;
- (void)addScenarios:(NSDictionary *)scenarios;

- (void)addStep:(KIFTestStep *)step forName:(NSString *)name;
- (void)addScenario:(KIFTestScenario *)scenario forName:(NSString *)name;

- (void)startAt:(NSString *)start;
- (void)transitionFrom:(NSString *)from to:(NSString *)to;
- (void)transitionFrom:(NSString *)from onResult:(id)result to:(NSString *)to;

@end
