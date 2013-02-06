//
//  KIFTestScenario.m
//  KIF
//
//  Created by Michael Thole on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import "KIFTestScenario.h"
#import "KIFTestStep.h"



@interface KIFTestScenario ()

@property (nonatomic, strong) NSMutableDictionary *state;

@end



@implementation KIFTestScenario

#pragma mark Static Methods

+ (id)scenarioWithDescription:(NSString *)description {
    return [[[self alloc] initWithDescription:description] autorelease];
}

- (id)init {
    return [self initWithDescription:@"Default description"];
}

- (id)initWithDescription:(NSString *)description {
    self = [super init];
    
    if (self == nil) {
        return nil;
    }
    
    _description = [description copy];
    
    if ([_description length] == 0) {
        [self release];
        
        return nil;
    }
    
    _state = [[NSMutableDictionary alloc] init];
    
    if (_state == nil) {
        [self release];
        
        return nil;
    }
    
    return self;
}

- (void)dealloc {
    [_description release]; _description = nil;
    [_state release]; _state = nil;
    
    [super dealloc];
}

- (void)initializeSteps;
{
    // For subclasses
}

#pragma mark Public Methods

- (KIFTestStep *)currentStep {
    return nil;
}

- (void)start {
    
}

- (void)advanceToNextStep {
}

- (id)stateForKey:(NSString *)key {
    return [self.state objectForKey:key];
}

- (void)setState:(id)state forKey:(NSString *)key {
    [self.state setObject:state forKey:key];
}

- (NSString *)stepDescription {
    return @"No steps";
}

@end
