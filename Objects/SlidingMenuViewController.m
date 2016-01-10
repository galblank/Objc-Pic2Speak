//
//  SlidingMenuViewController.m
//  Pic2Speak
//
//  Created by Gal Blank on 10/30/14.
//  Copyright (c) 2014 Gal Blank. All rights reserved.
//

#import "SlidingMenuViewController.h"
#import "ItemModel.h"
#import "AppDelegate.h"
#import "ItemViewController.h"


@interface SlidingMenuViewController ()

@end

static NSString *kCellIdentifier = @"CellIdentifier";


@implementation SlidingMenuViewController

@synthesize mycollectionView,itemsArray,selectedItem;

-(BOOL)shouldAutorotate{
    return NO;
}

- (NSUInteger) supportedInterfaceOrientations
{
    //Because your app is only landscape, your view controller for the view in your
    // popover needs to support only landscape
    return UIInterfaceOrientationMaskLandscape;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentLayout = LAYOUT_BIG;
    visibleItems = [[NSMutableArray alloc] init];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *buttonsmal = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonsmal.tag = 0;
    [buttonsmal addTarget:self action:@selector(changeLayout:) forControlEvents:UIControlEventTouchUpInside];
    buttonsmal.frame = CGRectMake(0, 0, [UIImage imageNamed:@"unlock"].size.width, [UIImage imageNamed:@"unlock"].size.height);
    [buttonsmal setBackgroundImage:[UIImage imageNamed:@"unlock"] forState:UIControlStateNormal];
    UIBarButtonItem *layoutsmall = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"unlock"] landscapeImagePhone:[UIImage imageNamed:@"unlock"] style:UIBarButtonItemStylePlain target:self action:@selector(lockunlock:)];
    layoutsmall.tag = 0;
    self.navigationItem.rightBarButtonItem = layoutsmall;
    
    /*UIButton *buttonsmal = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonsmal.tag = 0;
    [buttonsmal addTarget:self action:@selector(changeLayout:) forControlEvents:UIControlEventTouchUpInside];
    buttonsmal.frame = CGRectMake(0, 0, [UIImage imageNamed:@"layoutsmall"].size.width, [UIImage imageNamed:@"layoutsmall"].size.height);
    [buttonsmal setBackgroundImage:[UIImage imageNamed:@"layoutsmall"] forState:UIControlStateNormal];
    UIBarButtonItem *layoutsmall = [[UIBarButtonItem alloc] initWithCustomView:buttonsmal];
    layoutsmall.tag = 0;
    
    
    UIButton *buttonbig = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonbig.tag = 1;
    buttonbig.frame = CGRectMake(0, 0, [UIImage imageNamed:@"layoutbig"].size.width, [UIImage imageNamed:@"layoutbig"].size.height);
    [buttonbig addTarget:self action:@selector(changeLayout:) forControlEvents:UIControlEventTouchUpInside];
    [buttonbig setBackgroundImage:[UIImage imageNamed:@"layoutbig"] forState:UIControlStateNormal];
    UIBarButtonItem *layoutbig = [[UIBarButtonItem alloc] initWithCustomView:buttonbig];
    layoutbig.tag = 1;
    self.navigationItem.rightBarButtonItems = @[layoutbig,layoutsmall];
    */
    
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    
    
    flowLayout.itemSize = CGSizeMake([UIImage imageNamed:@"itembg"].size.width / 2,[UIImage imageNamed:@"itembg"].size.height / 2);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    flowLayout.sectionInset = UIEdgeInsetsMake(0.0, 0.0,5,0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.headerReferenceSize = CGSizeMake(0, 5);
    
    
    self.mycollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.5,-1, [UIImage imageNamed:@"itembg"].size.width / 2 + 5, self.view.frame.size.height) collectionViewLayout:flowLayout];
    self.mycollectionView.delegate  = self;
    //self.mycollectionView.backgroundView = nil;
    self.mycollectionView.backgroundColor = [UIColor clearColor];
    self.mycollectionView.alwaysBounceVertical = YES;
    self.mycollectionView.delegate = self;
    self.mycollectionView.dataSource = self;
    self.mycollectionView.layer.borderWidth = 2;
    self.mycollectionView.layer.borderColor = themeColor.CGColor;
    [self.mycollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    //[collectionView registerClass:[SMLPhotosCollectionViewHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    //[_filesCollectionView registerClass:[SMLPhotosCollectionViewFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];
    //self.mycollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    //[self.view addSubview:self.mycollectionView];
    
    
    
    CGFloat positionX = self.mycollectionView.frame.origin.x + self.mycollectionView.frame.size.width + 5;
    //profilesScrollView = [[PhotosScrollView alloc] initWithFrame:CGRectMake(positionX,0,self.view.frame.size.width - positionX, self.view.frame.size.height)];
    
    profilesScrollView = [[PhotosScrollView alloc] initWithFrame:CGRectMake(10,0,self.view.frame.size.width-20, self.view.frame.size.height)];
    [profilesScrollView setShowsHorizontalScrollIndicator:YES];
    
    [profilesScrollView setIndicatorStyle:UIScrollViewIndicatorStyleBlack];
    profilesScrollView.backgroundColor = [UIColor clearColor];
    profilesScrollView.delegate = self;
    //photoView.maximumZoomScale = 4.0;
    //photoView.minimumZoomScale = 0.75;
    profilesScrollView.clipsToBounds = YES;        // default is NO, we want to restrict drawing within our scrollview
    profilesScrollView.scrollEnabled = YES;
    
    // pagingEnabled property default is NO, if set the scroller will stop or snap at each photo
    // if you want free-flowing scroll, don't set this property.
    profilesScrollView.pagingEnabled = NO;
    [self.view addSubview:profilesScrollView];
    
    NSString* plistPath = [[NSBundle mainBundle] pathForResource:@"lists" ofType:@"plist"];
    NSMutableDictionary * contentDic = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSMutableArray *templ = [contentDic objectForKey:selectedItem.itemdescription];
    currentItems = [[NSMutableArray alloc] init];
    for(NSMutableDictionary *stritem in templ){
        ItemModel *item = [[ItemModel alloc] init];
        [item dicToItem:stritem];
        [currentItems addObject:item];
    }
    
    if([AppDelegate shared].isAdmin == YES){
        ItemModel *newitem = [[ItemModel alloc] init];
        newitem.itemID = [NSNumber numberWithInt:NEW_USER_ID];
        newitem.itemname = NSLocalizedString(@"Add new item",nil);
        newitem.itemdescription = @"newitem";
        newitem.itemimage = @"itembgsection";
        [currentItems addObject:newitem];
    }
    [self setImages];
    
    drawingOverlay = [[DrawingView alloc] initWithFrame:profilesScrollView.frame];
    drawingOverlay.drawDelegate = self;
    //[drawingOverlay setBackgroundColor:[UIColor clearColor]];
}

-(void)lockunlock:(UIBarButtonItem*)button
{
     profilesScrollView.scrollEnabled = !profilesScrollView.scrollEnabled;
    if(profilesScrollView.scrollEnabled == YES){
        //[drawingOverlay removeFromSuperview];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"unlock"] landscapeImagePhone:[UIImage imageNamed:@"unlock"] style:UIBarButtonItemStylePlain target:self action:@selector(lockunlock:)];
    }
    else{
        for(UIButton *button in visibleItems){
            DrawingView *_drawingOverlay = [[DrawingView alloc] initWithFrame:CGRectMake(0, 0, button.frame.size.width, button.frame.size.height)];
            for(ItemModel *item in currentItems){
                if([item.itemname isEqualToString:button.titleLabel.text] == YES){
                    _drawingOverlay.thisItem = item;
                    break;
                }
            }
            
            _drawingOverlay.drawDelegate = self;
            [_drawingOverlay setBackgroundColor:[UIColor clearColor]];
            [button addSubview:_drawingOverlay];
        }
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"lock"] landscapeImagePhone:[UIImage imageNamed:@"lock"] style:UIBarButtonItemStylePlain target:self action:@selector(lockunlock:)];
        //[self.view addSubview:drawingOverlay];
    }
}

////////////////////////////////AVAUDIO-DELEGATE////////////////////////////////////////////////
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag
{
    NSLog(@"audioPlayerDidFinishPlaying");
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player
                                 error:(NSError *)error

{
    NSLog(@"audioPlayerDecodeErrorDidOccur");
}


/////////////////////////////////SCROLLVIEW/////////////////////////////////////////////////////
-(void)resetAllItemsInVisibleArray
{
    for(UIButton *_button in visibleItems){
        [UIView animateWithDuration:0.5
                              delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState
                         animations:(void (^)(void)) ^{
                             _button.alpha = 1.0;
                             _button.transform=CGAffineTransformIdentity;
                             _button.tag = 0;
                         }
                         completion:^(BOOL finished){
                             
                         }];
    }
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [visibleItems removeAllObjects];
    CGPoint offset = [scrollView contentOffset];
    int nIndex = offset.x / [UIImage imageNamed:@"itembg"].size.width;
    ItemModel *model = [currentItems objectAtIndex:nIndex];
    //NSLog(@"Scrolled to: %.0f, %0f,first index is %d, value = %@",offset.x,offset.y,nIndex,model.itemname);
    
    for(UIView *view in scrollView.subviews){
        if ([view isKindOfClass:[UIButton class]] &&  CGRectIntersectsRect(scrollView.bounds, view.frame)){
            UIButton *button = (UIButton*)view;
            button.alpha = 1.0;
            button.transform=CGAffineTransformIdentity;
            button.tag = 10;
            NSLog(@"Visible %@",button.titleLabel.text);
            [visibleItems addObject:button];
        }
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [visibleItems removeAllObjects];
    CGPoint offset = [scrollView contentOffset];
    int nIndex = offset.x / [UIImage imageNamed:@"itembg"].size.width;
    ItemModel *model = [currentItems objectAtIndex:nIndex];
    //NSLog(@"Scrolled to: %.0f, %0f,first index is %d, value = %@",offset.x,offset.y,nIndex,model.itemname);
    [scrollView scrollRectToVisible:CGRectMake(nIndex * [UIImage imageNamed:@"itembg"].size.width + 10, scrollView.frame.origin.y, scrollView.frame.size.width, scrollView.frame.size.height) animated:YES];
    
    for(UIView *view in scrollView.subviews){
        if ([view isKindOfClass:[UIButton class]] && CGRectIntersectsRect(scrollView.bounds, view.frame)){
            UIButton *button = (UIButton*)view;
            button.alpha = 1.0;
            button.transform=CGAffineTransformIdentity;
            button.tag = 0;
            NSLog(@"Visible %@",button.titleLabel.text);
            [visibleItems addObject:button];
        }
    }

}


-(void)changeLayout:(UIButton*)button
{
    if((button.tag == 0 && currentLayout == LAYOUT_SMALL) || (button.tag == 1 && currentLayout == LAYOUT_BIG) ){
        return;
    }
    
    if(button.tag == 0){
        
    }
}


-(void)doneDrawing:(ItemModel*)itemDrawnOn
{
    NSLog(@"Item which drawn on is : %@",itemDrawnOn.itemname);
    
    for(UIButton *button in visibleItems){
        if([button.titleLabel.text isEqualToString:itemDrawnOn.itemname] == YES){
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:(void (^)(void)) ^{
                                 button.alpha = 1.0;
                                 button.transform=CGAffineTransformMakeScale(1.2, 1.2);
                             }
                             completion:^(BOOL finished){
                                 //button.transform=CGAffineTransformIdentity;
                             }];
        }
        else{
            [UIView animateWithDuration:0.5
                                  delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState
                             animations:(void (^)(void)) ^{
                                 button.alpha = 0.1;
                                 button.transform=CGAffineTransformIdentity;
                             }
                             completion:^(BOOL finished){
                                 
                             }];
        }
    }
    
    
}

-(void)playSound:(NSString*)filePath
{
    NSURL *url = [NSURL fileURLWithPath:filePath];
    NSError *err = nil;
    NSData *audioData = [NSData dataWithContentsOfFile:[url path] options: 0 error:&err];
    if(!audioData){
        NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"siren" ofType:@"caf"];
        url = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    }
    
    AVAudioPlayer *newPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&err];
    [newPlayer prepareToPlay];
    [newPlayer setDelegate:self];
    [newPlayer play];
}

-(void)select:(UIButton*)button
{
    for(ItemModel *mode in currentItems){
        if([button.titleLabel.text isEqualToString:mode.itemname] == YES){
            if(mode.itemID.intValue == NEW_USER_ID){
                ItemViewController *newitemVC = [[ItemViewController alloc] init];
                [newitemVC setSelectedItem:mode];
                [self.navigationController pushViewController:newitemVC animated:YES];
            }
            else{
                
                if(button.tag == 1){
                    [self resetAllItemsInVisibleArray];
                    return;
                }

                for(UIButton *_button in visibleItems){
                    if(_button == button){
                        [UIView animateWithDuration:0.5
                                              delay:0
                                            options:UIViewAnimationOptionBeginFromCurrentState
                                         animations:(void (^)(void)) ^{
                                             _button.alpha = 1.0;
                                             _button.transform=CGAffineTransformMakeScale(1.2, 1.2);
                                             _button.tag = 1;
                                         }
                                         completion:^(BOOL finished){
                                             //button.transform=CGAffineTransformIdentity;
                                         }];
                    }
                    else{
                        [UIView animateWithDuration:0.5
                                              delay:0
                                            options:UIViewAnimationOptionBeginFromCurrentState
                                         animations:(void (^)(void)) ^{
                                             _button.alpha = 0.1;
                                             _button.transform=CGAffineTransformIdentity;
                                             _button.tag = 0;
                                         }
                                         completion:^(BOOL finished){
                                             
                                         }];
                    }
                }
            }
            break;
        }
    }
}

- (void)layoutScrollImages
{
    UIButton *view = nil;
    NSArray *subviews = [profilesScrollView subviews];
    // reposition all image subviews in a horizontal serial fashion
    CGFloat curXLoc = 0;
    for (view in subviews)
    {
        if ([view isKindOfClass:[UIButton class]])
        {
            CGRect frame = view.frame;
            frame.origin = CGPointMake(curXLoc, view.frame.origin.y);
            view.frame = frame;
            curXLoc += ([UIImage imageNamed:@"itembg"].size.width) + 10;
        }
    }
    
    // set the content size so it can be scrollable
    CGFloat positionX = self.mycollectionView.frame.origin.x + self.mycollectionView.frame.size.width + 5;
    [profilesScrollView setContentSize:CGSizeMake(([currentItems count] * [UIImage imageNamed:@"itembg"].size.width) + ([currentItems count] * 10), [profilesScrollView bounds].size.height)];
}

-(void)setImages
{
    for (int i = 0; i < [currentItems count]; i++)
    {
        ItemModel *item = [currentItems objectAtIndex:i];
        CGFloat positionY = (profilesScrollView.frame.size.height - [UIImage imageNamed:item.itemimage].size.height - 45)/2;
        UIButton *signinbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        signinbutton.frame = CGRectMake(0,positionY,[UIImage imageNamed:item.itemimage].size.width,[UIImage imageNamed:item.itemimage].size.height);
        [signinbutton addTarget:self action:@selector(select:) forControlEvents:UIControlEventTouchUpInside];
        signinbutton.layer.borderColor = themeColor.CGColor;
        signinbutton.layer.borderWidth = 2.0;
        signinbutton.layer.cornerRadius = 10.0;
        if([item.itemimage rangeOfString:@"itembg"].location == NSNotFound){
            UIImage *userimage = [UIImage imageWithContentsOfFile:item.itemimage];
            [signinbutton setBackgroundImage:userimage forState:UIControlStateNormal];
            [signinbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        else{
            [signinbutton setTitleColor:themeColor forState:UIControlStateNormal];
            //[signinbutton setBackgroundImage:[UIImage imageNamed:profile.userimage] forState:UIControlStateNormal];
        }
        
        [signinbutton setTitle:item.itemname forState:UIControlStateNormal];
        signinbutton.titleLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:22.0];
        
        if([AppDelegate shared].isAdmin == YES){
            UIButton *userProfileButton = [UIButton buttonWithType:UIButtonTypeCustom];
            userProfileButton.frame = CGRectMake(signinbutton.frame.size.width - [UIImage imageNamed:@"selectpicture"].size.width - 5,signinbutton.frame.size.height - [UIImage imageNamed:@"selectpicture"].size.height - 5,[UIImage imageNamed:@"selectpicture"].size.width, [UIImage imageNamed:@"selectpicture"].size.height);
            [userProfileButton addTarget:self action:@selector(chooseImageSource:) forControlEvents:UIControlEventTouchUpInside];
            [userProfileButton setBackgroundImage:[UIImage imageNamed:@"selectpicture"] forState:UIControlStateNormal];
            userProfileButton.tag = item.itemID.intValue;
            
            [signinbutton addSubview:userProfileButton];
        }
        
        
        [profilesScrollView addSubview:signinbutton];
    }
    [self layoutScrollImages];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return itemsArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;//itemsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath]; //Discussed in Chapter 2 - pay no attention
    cell.backgroundColor = SECTIONS_BG_COLOR;
    ItemModel *item = [itemsArray objectAtIndex:indexPath.section];
    for(UIView *view in cell.contentView.subviews){
        if([view isKindOfClass:[UILabel class]]){
            [view removeFromSuperview];
        }
    }
    UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, cell.frame.size.width - 20, cell.frame.size.height - 20)];
    cellLabel.backgroundColor = SECTIONS_BG_COLOR;
    cellLabel.font = [UIFont fontWithName:@"AvenirNext-DemiBold" size:14.0];
    cellLabel.textColor = LEVELS_BG_COLOR;
    cellLabel.numberOfLines = 0;
    cellLabel.textAlignment = NSTextAlignmentCenter;
    cellLabel.text = item.itemname;
    [cell.contentView addSubview:cellLabel];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.mycollectionView.userInteractionEnabled = YES;
    ItemModel *item = [itemsArray objectAtIndex:indexPath.section];
    [self setTitle:item.itemname];
}
@end
