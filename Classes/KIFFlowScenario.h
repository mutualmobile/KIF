//
//  KIFFlowScenario.h
//  KIF
//
//  Created by Justin Kolb on 2/5/13.
//
//

#import "KIFBaseScenario.h"



@class KIFTestStep;



@interface KIFFlowScenario : KIFBaseScenario

- (void)addSteps:(NSDictionary *)steps;
- (void)addStep:(id)step forName:(NSString *)name;

- (void)startAt:(NSString *)start;
- (void)transitionFrom:(NSString *)from to:(NSString *)to;
- (void)transitionFrom:(NSString *)from onResult:(id)result to:(NSString *)to;

@end
