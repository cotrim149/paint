//
//  VCLCircle.m
//  Paint
//
//  Created by Victor de Lima on 31/07/14.
//  Copyright (c) 2014 Victor de Lima. All rights reserved.
//

#import "VCLCircle.h"

@implementation VCLCircle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.center = [decoder decodeCGPointForKey:@"center"];
        self.radius = [decoder decodeCGPointForKey:@"radius"];
        self.color = [decoder decodeObjectForKey:@"color"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeCGPoint:self.center forKey:@"center"];
    [encoder encodeCGPoint:self.radius forKey:@"radius"];
    [encoder encodeObject:self.color forKey:@"color"];
}


- (float) distanceBetween : (CGPoint) p1 and: (CGPoint)p2
{
    return sqrt(pow(p2.x-p1.x,2)+pow(p2.y-p1.y,2));
}

-(void)stroke{
    
    UIBezierPath *bp = [UIBezierPath bezierPathWithArcCenter:self.center
                                                      radius:[self distanceBetween:self.center and:self.radius]
                                                  startAngle:0
                                                    endAngle:2*M_PI
                                                   clockwise:YES];
    
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp stroke];

}

-(BOOL)havePoint:(CGPoint)point{
    
    for(float t=0;t<1.0;t += 0.05){
        
    }
    
    return NO;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
