//
//  VCLMainView.m
//  Paint
//
//  Created by Victor de Lima on 29/07/14.
//  Copyright (c) 2014 Victor de Lima. All rights reserved.
//

#import "VCLMainView.h"

@implementation VCLMainView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if(!_finishedLines && !_finishedCircles){
            self.finishedLines = [[NSMutableArray alloc] init];
            self.finishedCircles = [[NSMutableArray alloc] init];
            [self loadPoints];
        }
        self.linesInProgress = [[NSMutableDictionary alloc] init];
        self.circlesInProgress = [[NSMutableDictionary alloc] init];
        self.backgroundColor = [UIColor lightGrayColor];
        self.multipleTouchEnabled = YES;
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        
        tap.delaysTouchesBegan=YES;
        [tap requireGestureRecognizerToFail:doubleTap];
        [self addGestureRecognizer:tap];
        
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        
        [self addGestureRecognizer:longPress];
        
        UIPanGestureRecognizer *drag = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(dragGesture:)];
        drag.cancelsTouchesInView = NO;
//        [longPress requireGestureRecognizerToFail:drag];
        [self addGestureRecognizer:drag];
    }
    return self;
}

-(void)longPress:(UIGestureRecognizer*)gestureRecognizer{
    if(UIGestureRecognizerStateBegan == [gestureRecognizer state]){
        NSLog(@"Long press!");
    }else{
        [self dragGesture:gestureRecognizer];
    }
}

-(void)dragGesture:(UIGestureRecognizer*)gestureRecognizer{

    NSLog(@"Dragging");
    
    CGPoint actualPoint = [gestureRecognizer locationInView:self];
    CGFloat deltaX = actualPoint.x - _selectedLine.end.x;
    CGFloat deltaY = actualPoint.y - _selectedLine.end.y;
    
    _selectedLine.end = CGPointMake(deltaX, deltaY);
    


}

-(VCLLine *)lineAtPoint:(CGPoint)point{
    for(VCLLine *line in _finishedLines){
        if([line havePoint:point]){
            return line;
        }
    }
    
    return nil;
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(CGPoint)recognizePoint:(UIGestureRecognizer*)gestureRecognizer{
    CGPoint point = [gestureRecognizer locationInView:self];
    self.selectedLine = [self lineAtPoint:point];
    return point;
}

-(void)deleteLineWithPoint:(CGPoint)point{
    
    if(self.selectedLine){
        [self becomeFirstResponder];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        UIMenuItem *deleteItem = [[UIMenuItem alloc] initWithTitle:@"delete" action:@selector(deleteLine:)];
        menu.menuItems=@[deleteItem];
        [menu setTargetRect:CGRectMake(point.x, point.y, 2, 2) inView:self];
        [menu setMenuVisible:YES animated:YES];
                
    }else{
        [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];
    }
    
}

-(void)deleteLine:(id)sender{
    [self.finishedLines removeObject:self.selectedLine];
    self.selectedLine = nil;
    
    [self setNeedsDisplay];
}

-(void)tap:(UITapGestureRecognizer*)gestureRecognizer{
    NSLog(@"Tap recognized");
    
    CGPoint point = [self recognizePoint:gestureRecognizer];
    
    [self deleteLineWithPoint:point];
    
    [self setNeedsDisplay];
}

-(void)doubleTap:(UIGestureRecognizer*)gestureRecognizer{
    NSLog(@"Recognizer Double tap");
    [self.linesInProgress removeAllObjects];
    [self.finishedLines removeAllObjects];
    
    [self.circlesInProgress removeAllObjects];
    [self.finishedCircles removeAllObjects];
    
    [self setNeedsDisplay];
    
}


-(void)setColor:(UIColor*)color{
    [color set];
    
}

-(float)calculateDegreesLine:(VCLLine*)line{
    
    float deltaX = line.end.x - line.begin.x;
    float deltaY = line.end.y - line.begin.y;
    
    float m = (atan2(deltaX, deltaY)+3.2)/6.4;

    return m;
}

-(void)drawRect:(CGRect)rect{

    for(VCLLine *line in _finishedLines){
        [line.color set];
        [line stroke];

    }
    
    for(VCLCircle *circle in _finishedCircles){
        [circle.color set];
        [circle stroke];
    }

    for(NSValue *key in _linesInProgress){
        VCLLine *line = _linesInProgress[key];
        line.color = [UIColor colorWithHue:[self calculateDegreesLine:line] saturation:1 brightness:1 alpha:1];
        [line.color set];
        [line stroke];
    }
    
    for(NSValue *key in _circlesInProgress){
        VCLCircle *circle = _circlesInProgress[key];
        VCLLine *line = [[VCLLine alloc] init];
        line.begin = circle.center;
        line.end = circle.radius;
        circle.color =[UIColor colorWithHue:[self calculateDegreesLine:line] saturation:1 brightness:1 alpha:1];
        [circle.color set];
        [circle stroke];
    }
    
    if(self.selectedLine){
        [[UIColor greenColor] set];
        [[self selectedLine] stroke];
    }
    
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
   

    for(UITouch *t in touches){
        CGPoint location = [t locationInView:self];
        NSValue *key = [NSValue valueWithNonretainedObject:t];

        if([_linesInProgress count] == 0){
            VCLLine *line = [[VCLLine alloc] init];
            line.begin = location;
            line.end = location;
            _tempKey= key;
            [self.linesInProgress setObject:line forKey:key];
            
        }else{
            VCLCircle *circle = [[VCLCircle alloc] init];
            VCLLine *line = _linesInProgress[_tempKey];
                             
            circle.center= [line end];
            [self.circlesInProgress setObject:circle forKey:_tempKey];
            
            CGPoint location = [t locationInView:self];
            circle.radius=location;
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            [self.circlesInProgress setObject:circle forKey:key];
            [_linesInProgress removeAllObjects];
            
        }
    }
    
    
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{

    for(UITouch *t in touches){
        if([_linesInProgress count] != 0){
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            CGPoint location = [t locationInView:self];
            VCLLine *line = _linesInProgress[key];
            line.end = location;
        }else{
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            CGPoint location = [t locationInView:self];
            VCLCircle *circle = _circlesInProgress[key];
            circle.radius=location;
        }
    }

    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for(UITouch *t in touches){
        if([_linesInProgress count]!= 0){
            NSValue *key = [NSValue valueWithNonretainedObject:t];
            VCLLine *line = _linesInProgress[key];
            
            [_finishedLines addObject:line];
            [self.linesInProgress removeObjectForKey:key];
        }else{
            VCLCircle *circle = _circlesInProgress[_tempKey];
            
            if (circle) {
                [_finishedCircles addObject:circle];
                [self.circlesInProgress removeObjectForKey:_tempKey];
                _tempKey = nil;
            }
        }
    }
    
    [self setNeedsDisplay];
    [self savePoints];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event{
    for(UITouch *t in touches){
        NSValue *key = [NSValue valueWithNonretainedObject:t];
        [self.linesInProgress removeObjectForKey:key];
        
    }
    
    [self setNeedsDisplay];
}

-(void)savePoints{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistPathPoints = [documentsDirectory stringByAppendingString:@"/points.plist"];
    NSString *plistPathCircles = [documentsDirectory stringByAppendingString:@"/circles.plist"];
    
    NSData *points = [NSKeyedArchiver archivedDataWithRootObject:_finishedLines];
    [points writeToFile:plistPathPoints atomically:YES];
    
    NSData *circles = [NSKeyedArchiver archivedDataWithRootObject:_finishedCircles];
    [circles writeToFile:plistPathCircles atomically:YES];
    

}

-(void)loadPoints{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory = [path objectAtIndex:0];
    NSString *plistPathPoints = [documentsDirectory stringByAppendingString:@"/points.plist"];
    NSString *plistPathCircles = [documentsDirectory stringByAppendingString:@"/circles.plist"];

    NSData *points = [NSData dataWithContentsOfFile:plistPathPoints];
    NSData *circles = [NSData dataWithContentsOfFile:plistPathCircles];
    
    if(points){
        self.finishedLines = [NSKeyedUnarchiver unarchiveObjectWithData:points];
    }
    
    if(circles){
        self.finishedCircles = [NSKeyedUnarchiver unarchiveObjectWithData:circles];
    }
    
}

@end
