//
//  point.h
//  yolo
//
//  Created by Vikram Mullick on 10/13/15.
//  Copyright © 2015 Vikram Mullick. All rights reserved.
//

#ifndef point_h
#define point_h
@import QuartzCore;

@interface  point : NSObject

@property (nonatomic) double x;
@property (nonatomic) double y;
@property CAShapeLayer *shapeLayer;
@property CAShapeLayer *detectionShapeLayer;

@property (nonatomic) double xscreen;
@property (nonatomic) double yscreen;


@end

#endif /* point_h */
