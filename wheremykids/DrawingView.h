//
//  DrawingView.h
//  Pic2Speak
//
//  Created by Gal Blank on 11/3/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ItemModel.h"

@protocol DrawingViewDelegate <NSObject>
@optional
-(void)doneDrawing:(ItemModel*)itemDrawnOn;
@end

@interface DrawingView : UIView
{
    UIBezierPath *path;
    UIImage *incrementalImage;
    CGPoint pts[5]; // we now need to keep track of the four points of a Bezier segment and the first control point of the next segment
    uint ctr;
    NSMutableArray * touchesPoints;
    id<DrawingViewDelegate> __unsafe_unretained drawDelegate;
    
    ItemModel *thisItem;
}
@property (nonatomic,strong)ItemModel *thisItem;
@property (nonatomic, unsafe_unretained) id<DrawingViewDelegate> drawDelegate;
@end
