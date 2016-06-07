//
//  AppDelegate.h
//  yolo
//
//  Created by Vikram Mullick on 10/12/15.
//  Copyright © 2015 Vikram Mullick. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *RegType;
    NSString *pointString;
    NSMutableArray *points;
    int power;
    NSMutableArray *coeff;
    NSString *calcRegType;
    NSString *finalEquation;
    NSString *EquationForThirdView;
    NSString *ScrollEquationForThirdView;

    NSMutableArray *newpoints;

    NSString *rsquared;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) NSMutableArray *points;
@property (nonatomic) NSString *RegType;
@property (nonatomic) NSString *pointString;
@property (nonatomic) int power;
@property (nonatomic) NSMutableArray *coeff;
@property (nonatomic) NSMutableArray *newpoints;

@property (nonatomic) NSString *calcRegType;
@property (nonatomic) NSString *finalEquation;
@property (nonatomic) NSString *EquationForThirdView;
@property (nonatomic) NSString *ScrollEquationForThirdView;

@property (nonatomic) NSString *rsquared;

@end

