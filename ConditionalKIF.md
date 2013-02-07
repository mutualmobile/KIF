Conditional KIF Tests
=====================

Conditional KIF makes it easy for you to write UI automation tests that do not rely on having canned static data in your app. This can be helpful in testing apps where creating static test data is excessively hard or cost prohibitive.

Features
--------

#### Sequence
KIF supports sequentially executing test steps out of the box in a unit called a scenario. Conditional KIF makes scenarios able to be used as "subroutines" within other scenarios.

#### Selection
Conditional KIF allows for easily choosing the next step to execute based on a result generated in a prior step.

#### Iteration
Conditional KIF allows for looping by jumping back to a prior step, effectively a goto. When combined with selection you can control when you loop exits similar to a while loop.

#### Results
Conditional KIF adds a generic result property to KIFTestStep that can be used to drive the next step that is executed. You can store booleans (@NO, @YES), strings, numbers, or any other data you would like to branch off of.

#### Scenario Data
Conditional KIF also provides a way for storing data in the scenario using a string key that can be accessed by other steps within the same scenario.


Details
-------

Conditional KIF introduces two types of scenarios. KIFSequenceScenario represents a sequential, one after the other, execution of KIFTestSteps. This is the functionality that is built into KIF already. KIFFlowScenario allows for defining what order steps execute in and also choosing the next step based on the result of the prior step.


Example Scenario
----------------

This example will describe the high level overview of how to write a test that can iterate over all the rows in a table without knowing ahead of time how many rows there are. Following the code is a description of the finer details this example is demonstrating.

*KIFTestScenario+ExampleAdditions.h*

	@interface KIFTestScenario (ExampleAdditions)
	
	+ (id)scenarioToIterateToEndOfTable;
	
	@end

*KIFTestScenario+ExampleAdditions.m*

	#import "KIFFlowScenario.h"
	
	@implementation KIFTestScenario (ExampleAdditions)

	+ (id)scenarioToIterateToEndOfTable {
		KIFFlowScenario *scenario = [KIFFlowScenario scenarioWithDescription:@"Iterate through all the rows in a table"];
		
		[scenario addSteps:@{
			@"numberOfRows": [KIFTestStep stepToStoreNumberOfRowsFromTableViewWithAccessibilityIdentifier:@"tableView" 
																			  inScenario:scenario withKey:@"numberOfRows"],
			@"rowIndex": [KIFTestStep stepToStore:@0 inScenario:scenario  withKey:@"rowIndex"],
			@"hasMoreRows": [KIFTestStep stepToCompareKey:@"rowIndex" inScenario:scenario withKey:@"numberOfRows"],
			@"processRow": [KIFTestStep stepToProcessRowWithIndexKey:@"rowIndex"
			                                              inScenario:scenario 
			                fromTableViewWithAccessibilityIdentifier:@"tableView"],
			@"incrementRowIndex": [KIFTestStep stepToIncrementNumberWithKey:@"rowIndex" inScenario:scenario],
		}];
		
		[scenario startAt:@"numberOfRows"];
		[scenario transitionFrom:@"numberOfRows" to:@"rowIndex"];
		[scenario transitionFrom:@"rowIndex" to:@"hasMoreRows"];
		[scenario transitionFrom:@"hasMoreRows" onResult:@-1 to:@"processRow"]; // NSOrderedAscending = -1
		[scenario transitionFrom:@"processRow" to:@"incrementRowIndex"];
		[scenario transitionFrom:@"incrementRowIndex" to:@"hasMoreRows"];
	}
	
	@end

Here is a rundown of what is happening in `scenarioToIterateToEndOfTable`

First you define all the steps that occur in the scenario using the `addSteps:` method. Each step is given a name which will be used to help determine the order of execution. A step can also be another scenario. When used in this way the scenario becomes a subroutine of the current scenario. In this example there are steps to lookup and store the number of rows in the table, setup a row index, then processing a row, and then incrementing the index and starting over if there are more rows left to process.

Next you must define order of transitions between all of the defined steps.

### `startAt:`
This method is how you define the first step to execute for the scenario.
	
### `transitionFrom:to:`
This method defines a straight sequential transition from one step to another
	
### `transitionFrom:onResult:to:`
This method allows for branching. Normally this method is called multiple times for the same "from" step. For each different result the step generates, you can transition to another different step.
	
If there is any time that no transition exists from one step to the next, the scenario will exit. In the example above, the scenario will exit when the "hasMoreRows" step generates a result other than -1.

Example Steps
-------------

These examples will detail what is going on in the steps above to store data into the session and to generate results in a step.

*KIFTestStep+ExampleAdditions.h*

	@interface KIFTestScenario (ExampleAdditions)

	+ (id)stepToStoreNumberOfRowsFromTableViewWithAccessibilityIdentifier:(NSString *)identifier 
	                                                           inScenario:(KIFTestScenario *)scenario 
	                                                              withKey:(NSString *)key;
	+ (id)stepToStore:(id)value inScenario:(KIFTestScenario *)scenario withKey:(NSString *)key;
	+ (id)stepToCompareKey:(NSString *)key inScenario:(KIFTestScenario *)scenario withKey:(NSString *)otherKey;
	+ (id)stepToProcessRowWithIndexKey:(NSString *)key inScenario:(KIFTestScenario *)scenario
	                      fromTableViewWithAccessibilityIdentifier:(NSString *)identifier;
	+ (id)stepToIncrementNumberWithKey:(NSString *)key inScenario:(KIFTestScenario *)scenario;

	@end

*KIFTestStep+ExampleAdditions.m*

	@implementation KIFTestScenario (ExampleAdditions)

	+ (id)stepToStoreNumberOfRowsFromTableViewWithAccessibilityIdentifier:(NSString *)identifier inScenario:(KIFTestScenario *)scenario withKey:(NSString *)key {
		typeof(scenario) __block blockScenario = scenario;
		
		return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
			UITableView *tableView = [[UIApplication sharedApplication] viewWithAccessibilityIdentifier:identifier];
			NSInteger numberOfRows = [tableView numberOfRows];
			[blockScenario setState:[NSNumber numberWithInteger:numberOfRows] forKey:key];
			return KIFTestStepResultSuccess;
		}];
	}
	
	+ (id)stepToStore:(id)value inScenario:(KIFTestScenario *)scenario withKey:(NSString *)key {
		typeof(scenario) __block blockScenario = scenario;
		
		return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
			[blockScenario setState:value forKey:key];
			return KIFTestStepResultSuccess;
		}];
	}
	
	+ (id)stepToCompareKey:(NSString *)key inScenario:(KIFTestScenario *)scenario withKey:(NSString *)otherKey {
		typeof(scenario) __block blockScenario = scenario;
		
		return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
			id value = [blockScenario stateForKey:key];
			id otherValue = [blockScenario stateForKey:otherKey];
			NSComparison result = [value compare:otherValue];
			step.result = [NSNumber numberWithInteger:result];
			return KIFTestStepResultSuccess;
		}];
	}
	
	+ (id)stepToProcessRowWithIndexKey:(NSString *)key inScenario:(KIFTestScenario *)scenario fromTableViewWithAccessibilityIdentifier:(NSString *)identifier {
		typeof(scenario) __block blockScenario = scenario;
		
		return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
			UITableView *tableView = [[UIApplication sharedApplication] viewWithAccessibilityIdentifier:identifier];
			NSInteger rowIndex = [[blockScenario stateForKey:key] integerValue];
			
			// Use rowIndex to find row in tableView and operate upon it
			
			return KIFTestStepResultSuccess;
		}];
	}
	
	+ (id)stepToIncrementNumberWithKey:(NSString *)key inScenario:(KIFTestScenario *)scenario {
		typeof(scenario) __block blockScenario = scenario;
		
		return [KIFTestStep stepWithDescription:@"Reset the application state." executionBlock:^(KIFTestStep *step, NSError **error) {
			NSNumber *number = [blockScenario stateForKey:key];
			NSInteger value = [number integerValue];
			++value;
			[blockScenario setState:[NSNumber numberWithInteger:value] forKey:key];
			return KIFTestStepResultSuccess;
		}];
	}

	@end
