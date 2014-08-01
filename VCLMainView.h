//
//  VCLMainView.h
//  Paint
//
//  Created by Victor de Lima on 29/07/14.
//  Copyright (c) 2014 Victor de Lima. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VCLLine.h"
#import "VCLCircle.h"
@interface VCLMainView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic) NSMutableDictionary *linesInProgress;
@property (nonatomic) NSMutableDictionary *circlesInProgress;
@property (nonatomic) NSMutableArray *finishedLines;
@property (nonatomic) NSMutableArray *finishedCircles;
@property (nonatomic) NSValue *tempKey;

@property (nonatomic) VCLLine *selectedLine;
@property (nonatomic) VCLCircle *selectedCircle;

-(void)savePoints;
-(void)loadPoints;
@end
