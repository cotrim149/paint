//
//  VCLCircle.h
//  Paint
//
//  Created by Victor de Lima on 31/07/14.
//  Copyright (c) 2014 Victor de Lima. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VCLCircle : UIView<NSCoding>

@property (nonatomic) CGPoint center;
@property (nonatomic) CGPoint radius;
@property (nonatomic) UIColor *color;
-(void)stroke;
-(BOOL)havePoint:(CGPoint)point;

@end
