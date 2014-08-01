//
//  VCLLine.h
//  Paint
//
//  Created by Victor de Lima on 29/07/14.
//  Copyright (c) 2014 Victor de Lima. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VCLLine : NSObject<NSCoding>

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;
@property (nonatomic) UIColor *color;
-(void)stroke;
-(BOOL)havePoint:(CGPoint)point;
@end
