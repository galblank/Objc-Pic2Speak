//
//  SlidingMenuViewController.h
//  Pic2Speak
//
//  Created by Gal Blank on 10/30/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosScrollView.h"
#import "ItemModel.h"
#import <AVFoundation/AVFoundation.h>
#import "DrawingView.h"

typedef enum{
    LAYOUT_BIG = 0,
    LAYOUT_SMALL
}layoutType;


@interface SlidingMenuViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,AVAudioPlayerDelegate,DrawingViewDelegate>
{
    NSMutableArray *itemsArray;
    UICollectionView *mycollectionView;
    PhotosScrollView *profilesScrollView;
    ItemModel *selectedItem;
    
    NSMutableArray *currentItems;
    
    layoutType currentLayout;
    
    DrawingView *drawingOverlay;
    
    NSMutableArray *visibleItems;
}

@property(nonatomic,strong)ItemModel *selectedItem;
@property(nonatomic,strong)NSMutableArray *itemsArray;
@property(nonatomic,strong)UICollectionView *mycollectionView;



-(void)doneDrawing:(ItemModel*)itemDrawnOn;
-(void)initSelf;
@end
