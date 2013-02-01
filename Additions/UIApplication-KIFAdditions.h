//
//  UIApplication-KIFAdditions.h
//  KIF
//
//  Created by Eric Firestone on 5/20/11.
//  Licensed to Square, Inc. under one or more contributor license agreements.
//  See the LICENSE file distributed with this work for the terms under
//  which Square, Inc. licenses this file to you.

#import <UIKit/UIKit.h>


@interface UIApplication (KIFAdditions)

- (id)viewWithAccessibilityIdentifier:(NSString *)identifier;
- (id)viewWithAccessibilityIdentifierPath:(NSString *)identifierPath;
- (id)viewWithAccessibilityIdentifiers:(NSArray *)identifiers;

- (UIAccessibilityElement *)accessibilityElementWithIdentifier:(NSString *)identifier;

- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label traits:(UIAccessibilityTraits)traits;
- (UIAccessibilityElement *)accessibilityElementWithLabel:(NSString *)label accessibilityValue:(NSString *)value traits:(UIAccessibilityTraits)traits;
- (UIAccessibilityElement *)accessibilityElementMatchingBlock:(BOOL(^)(UIAccessibilityElement *))matchBlock;

- (UIWindow *)keyboardWindow;
- (UIWindow *)pickerViewWindow;

@end
