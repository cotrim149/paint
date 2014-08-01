//
//  VCLLine.m
//  Paint
//
//  Created by Victor de Lima on 29/07/14.
//  Copyright (c) 2014 Victor de Lima. All rights reserved.
//

#import "VCLLine.h"

@implementation VCLLine
- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.begin = [decoder decodeCGPointForKey:@"beginPoint"];
        self.end = [decoder decodeCGPointForKey:@"endPoint"];
        self.color = [decoder decodeObjectForKey:@"color"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeCGPoint:self.begin forKey:@"beginPoint"];
    [encoder encodeCGPoint:self.end forKey:@"endPoint"];
    [encoder encodeObject:self.color forKey:@"color"];
}

-(BOOL)havePoint:(CGPoint)point{
    
    for (float t=0.0; t <1.0; t+=0.05) {
        
        float x = self.begin.x + t * (self.end.x - self.begin.x);
        float y = self.begin.y + t * (self.end.y - self.begin.y);
        float hipotenusa = hypot(x - point.x, y - point.y);

        if( hipotenusa < 20.0){
            return YES;
        }
    }
    return NO;
}

-(void)stroke{
    UIBezierPath *bp = [UIBezierPath bezierPath];

    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:self.begin];
    [bp addLineToPoint:self.end];
    [bp stroke];
}

@end