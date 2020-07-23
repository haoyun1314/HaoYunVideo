//
//  HYBottomShowSelectView.m
//  HaoYunVideo
////{
//    "data": {
//        "primaryList": [
//            {
//                "primaryId": 1007000000,
//                "primaryName": "学前班",
//                "isClickBehind": "1",
//                "secondaryList": [
//                    {
//                        "secondaryId": 1007010000,
//                        "secondaryName": "上学期",
//                        "threeLevelList": [
//                            {
//                                "threeLevelId": 1007010100,
//                                "threeLevelName": "人教版"
//                            }
//                        ]
//                    }
//                ]
//            }
//
//
//        ],
//        "primaryTitle": "年级",
//        "secondaryTitle": "学期",
//        "threeLevelTitle": "教材版本",
//        "isDisplayClose": "1",
//        "default": {
//            "primaryId": 12,
//            "primaryName": "二年级",
//            "secondaryId": 1002020000,
//            "secondaryName": "下学期",
//            "threeLevelId": 1002020100,
//            "threeLevelName": "人教版"
//        }
//    }
//}
//  Created by fanhaoyun on 2020/7/12.
//  Copyright © 2020 范浩云. All rights reserved.
//

#import "HYBottomShowSelectView.h"
#import "MutableCopyCategory.h"
#import "HYGradeSelectModel.h"
#import "YYModel.h"
#import "UIFont+JZBNFont.h"


@interface HYRecipeCollectionHeaderView : UICollectionReusableView
@property(nonatomic,strong) UILabel  * headerLabel;
@end

@implementation HYRecipeCollectionHeaderView



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _headerLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 0, 98, 14)];
        _headerLabel.textAlignment = NSTextAlignmentLeft;
        _headerLabel.text = @"";
        _headerLabel.font = [UIFont JZBNFontWithName:@"PingFangSC-Semibold" size:14];
        _headerLabel.textColor = [UIColor YXColorWithHexCode:@"#141414"];
        [self addSubview:_headerLabel];
    }
    return self;
}



@end

#pragma mark-selectCell---


@interface HYGradeCollectViewCell : UICollectionViewCell


@property(nonatomic,strong) UILabel  * contentLabel;


@end

@implementation HYGradeCollectViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.contentLabel];
        self.contentLabel.center = self.contentView.center;
    }
    return self;
}


-(UILabel *)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.size = CGSizeMake(98, 36);
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.text = @"下学期";
        _contentLabel.font = [UIFont JZBNFontWithName:@"PingFangSC-Regular" size:16];
        _contentLabel.textColor = [UIColor YXColorWithHexCode:@"#141414"];
        _contentLabel.backgroundColor = [UIColor YXColorWithHexCode:@"#F7F9FA"];
        UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:_contentLabel.bounds
                                                       byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadii:CGSizeMake(18, 18)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentLabel.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentLabel.layer.mask = maskLayer;
        _contentLabel.layer.masksToBounds = YES;
        
    }
    return _contentLabel;
}

@end


#pragma mark--bottomView


@interface HYBottomShowSelectView ()<UICollectionViewDelegate,UICollectionViewDataSource>


@property(nonatomic,strong) UIView * contentView;

@property(nonatomic,strong) UILabel  * titleLabel;

@property(nonatomic,strong) UIButton  * closeBtn;

@property(nonatomic,strong) UIButton  * sureBtn;

@property(nonatomic,strong) UICollectionView * gradeSelectCollectionView;

@property(nonatomic,strong) NSMutableDictionary * dataSourceMutableDic;

@property(nonatomic,strong) HYDataItem * hyDataItem;

@property(nonatomic,strong) NSMutableDictionary * defaultDic;


@property(nonatomic,copy) void(^dismissBlock)(NSDictionary * paraDic);

@property(nonatomic,copy) void(^sureBlock)(NSDictionary *paraDic);

@property(nonatomic,strong) UIView * backGroundView;


@end


@implementation HYBottomShowSelectView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self getDataSourceFromDictionary:nil];
        [self addSubview:self.backGroundView];
        [self addSubview:self.contentView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.closeBtn];
        [self.contentView addSubview:self.gradeSelectCollectionView];
        [self.contentView addSubview:self.sureBtn];
        
        self.closeBtn.top = self.contentView.left+15;
        self.closeBtn.right = self.contentView.right-15;
        
        self.titleLabel.yCenter = self.closeBtn.yCenter;
        self.titleLabel.xCenter = self.contentView.xCenter;
        
        self.gradeSelectCollectionView.top = 52;
        self.gradeSelectCollectionView.left = self.contentView.left;
        
        self.sureBtn.top = self.gradeSelectCollectionView.bottom+8;
        self.sureBtn.xCenter = self.contentView.xCenter;
        
        
    }
    return self;
}


-(UIView *)backGroundView
{
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,MPT_ScreenW, MPT_ScreenH)];
        _backGroundView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapParentView:)];
        [_backGroundView addGestureRecognizer:tapGesture];
    }
    return _backGroundView;
}


-(void)tapParentView:(UITapGestureRecognizer *)tapGesture
{
    [self removeFromSuperview];
    
    
    if (self.dismissBlock)
    {
        self.dismissBlock(nil);
    }
}

-(void)getDataSourceFromDictionary:(NSDictionary *)dicParam
{
    NSError *error = nil;
    NSString *dataStr = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"grade" ofType:@"txt"] encoding:NSUTF8StringEncoding error:&error];
    NSData *jsonData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    if (jsonData ==nil) { return; }
    NSError *jerror;
    NSDictionary*dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&jerror];
    self.dataSourceMutableDic = [dic mutableDicDeepCopy];
    NSDictionary * dataDic = [dic objectForKey:@"data"];
    self.hyDataItem = [HYDataItem yy_modelWithDictionary:dataDic];
    [self initDefalut];
}

-(void)initDefalut
{
    for (NSInteger i = 0; i<self.hyDataItem.primaryList.count ;i++)
    {
        HYPrimaryListItem * listItem = [self.hyDataItem.primaryList objectAtIndex:i];
        if ([self.hyDataItem.defaultModel.primaryName  isEqualToString:listItem.primaryName])
        {
            listItem.isSelected = YES;
        }
    }
    
    
    for (NSInteger i = 0; i<[self getHYPrimaryListItem].secondaryList.count ;i++)
    {
        HYSecondaryListItem * listItem = [[self getHYPrimaryListItem].secondaryList objectAtIndex:i];
        if ([self.hyDataItem.defaultModel.secondaryName  isEqualToString:listItem.secondaryName])
        {
            listItem.isSelected = YES;
        }
    }
    
    for (NSInteger i = 0; i< [self getHYSecondaryListItem].threeLevelList.count ;i++)
    {
        HYThreeLevelListItem * listItem = [[self getHYSecondaryListItem].threeLevelList objectAtIndex:i];
        if ([self.hyDataItem.defaultModel.threeLevelName  isEqualToString:listItem.threeLevelName])
        {
            listItem.isSelected = YES;
        }
    }
    
}







-(HYPrimaryListItem*)getHYPrimaryListItem
{
    HYPrimaryListItem * currentLisgItem = nil;
    for (HYPrimaryListItem * listItem in self.hyDataItem.primaryList)
    {
        if ([self.hyDataItem.defaultModel.primaryName  isEqualToString:listItem.primaryName])
        {
            currentLisgItem = listItem;
        }
    }
    
    if (currentLisgItem == nil && self.hyDataItem.primaryList.count>0)
    {
        currentLisgItem = [self.hyDataItem.primaryList objectAtIndex:0];
    }
    
    if (currentLisgItem ==nil)
    {
        currentLisgItem = [[HYPrimaryListItem alloc]init];
    }
    
    return currentLisgItem;
}


-(HYSecondaryListItem*)getHYSecondaryListItem
{
    HYSecondaryListItem * currentLisgItem = nil;
    for ( HYSecondaryListItem * listItem in [self getHYPrimaryListItem].secondaryList)
    {
        if ([self.hyDataItem.defaultModel.secondaryName isEqualToString:listItem.secondaryName])
        {
            currentLisgItem = listItem;
        }
    }
    
    
    if (currentLisgItem == nil && [self getHYPrimaryListItem].secondaryList.count>0)
    {
        currentLisgItem = [[self getHYPrimaryListItem].secondaryList objectAtIndex:0];
    }
    
    if (currentLisgItem ==nil) {
        currentLisgItem = [[HYSecondaryListItem alloc]init];
    }
    
    return currentLisgItem;
}


-(HYThreeLevelListItem*)getHYThreeLevelListItem
{
    HYThreeLevelListItem * currentLisgItem = nil;
    for ( HYThreeLevelListItem * listItem in [self getHYSecondaryListItem].threeLevelList)
    {
        if ([self.hyDataItem.defaultModel.threeLevelName isEqualToString:listItem.threeLevelName])
        {
            currentLisgItem = listItem;
        }
    }
    return currentLisgItem;
}



-(UIButton *)sureBtn
{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.size = CGSizeMake(MPT_ScreenW -32, 44);
        [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureClick:) forControlEvents:UIControlEventTouchUpInside];
        _sureBtn.backgroundColor = [UIColor YXColorWithHexCode:@"#44A6FF"];
        UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:_sureBtn.bounds
                                                       byRoundingCorners:UIRectCornerAllCorners
                                                             cornerRadii:CGSizeMake(25, 25)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _sureBtn.bounds;
        maskLayer.path = maskPath.CGPath;
        _sureBtn.layer.mask = maskLayer;
        _sureBtn.layer.masksToBounds = YES;
        
    }
    return _sureBtn;
}




-(UIButton *)closeBtn
{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        _closeBtn.size = CGSizeMake(24, 24);
        [_closeBtn setImage:[UIImage imageNamed:@"nav_icon_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}



-(UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc]init];
        _titleLabel.size = CGSizeMake(100, 18);
        _titleLabel.text = @"年级切换";
        _titleLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
        _titleLabel.textColor = [UIColor blackColor];
    }
    return _titleLabel;
}

-(UIView*)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0,MPT_ScreenH-512,MPT_ScreenW,512)];
        _contentView.backgroundColor = [UIColor whiteColor];
        UIBezierPath *maskPath=  [UIBezierPath bezierPathWithRoundedRect:_contentView.bounds
                                                       byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                             cornerRadii:CGSizeMake(25, 25)];
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        maskLayer.frame = _contentView.bounds;
        maskLayer.path = maskPath.CGPath;
        _contentView.layer.mask = maskLayer;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

#pragma mark-clickEvent-


-(void)closeClick:(UIButton *)clolseBtn
{
    [self removeFromSuperview];
    NSMutableDictionary  * dicM = [self.hyDataItem.defaultModel yy_modelToJSONObject];

    if (self.dismissBlock)
    {
        self.dismissBlock(nil);
    }
}

-(void)sureClick:(UIButton *)clolseBtn
{
    
    
    [self removeFromSuperview];
    
//    { "primaryId": "", "primaryName": "", "secondaryId": "", "secondaryName": "", "threeLevelId": "", "threeLevelName": "",,"buttonType":""//0 蒙层 1叉号 2确定按钮}
    
    NSDictionary  * defatuDic = [self.hyDataItem.defaultModel yy_modelToJSONObject];
    NSMutableDictionary * paraDicM  = [defatuDic mutableDicDeepCopy];
    [paraDicM setObject:@(2) forKey:@"buttonType"];
    if (self.sureBlock) {
        self.sureBlock(paraDicM);
    }
}

-(void)gradeViewShowWindowToParent:(UIView *)aParentView showBlock:(void(^)(void))showBlock disMissBlock:(void (^)(NSDictionary * paraDic))dismissBlock  sureBlock:(void (^)(NSDictionary * paraDic))sureBlock
{
    dismissBlock = self.dismissBlock;
    sureBlock = self.sureBlock;
    [aParentView addSubview:self];
    if (showBlock) {
        showBlock();
    }
    
}


#pragma mark-collectionViewDelegate


-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath


{
    if (indexPath.section ==0)
    {
        
        //        1.点击当前section的替换数据和当前item选中状态年级
        
        for (HYPrimaryListItem * primaryItem in self.hyDataItem.primaryList)  {
            if (primaryItem.isSelected == YES) {
                primaryItem.isSelected = NO;
            }
        }
        HYPrimaryListItem * currentPrimaryItem =  [self.hyDataItem.primaryList objectAtIndex:indexPath.row];
        currentPrimaryItem.isSelected = YES;
        self.hyDataItem.defaultModel.primaryName = currentPrimaryItem.primaryName;
        self.hyDataItem.defaultModel.primaryId = currentPrimaryItem.primaryId;
        
        
        if ([[self getHYPrimaryListItem].primaryName isEqualToString:@"学前班"] )
        {
            for (HYSecondaryListItem * secondItem in [self getHYPrimaryListItem].secondaryList)  {
                if (secondItem.isSelected == YES) {
                    secondItem.isSelected = NO;
                }
            }
            
            for (HYThreeLevelListItem * threeItem in [self getHYSecondaryListItem].threeLevelList)  {
                if (threeItem.isSelected == YES) {
                    threeItem.isSelected = NO;
                }
            }
            
            [UIView performWithoutAnimation:^{
                 [self.gradeSelectCollectionView reloadData];
             }];
            return;
        }
        
        
        
        
        //        2.学期逻辑：
        //            A:取消当前学期的选中状态
        //            B:根据default 获取当前的学期 ： YES：更新本地数据 NO:默认选中第一个
        
        
        for (HYSecondaryListItem * secondItem in [self getHYPrimaryListItem].secondaryList)  {
            if (secondItem.isSelected == YES) {
                secondItem.isSelected = NO;
            }
        }
        if ([self getHYSecondaryListItem].secondaryName ==nil) {
            
            HYSecondaryListItem * currentSeconItem =  [[self getHYPrimaryListItem].secondaryList objectAtIndex:0];
            self.hyDataItem.defaultModel.secondaryName = currentSeconItem.secondaryName;
            self.hyDataItem.defaultModel.secondaryId = currentSeconItem.secondaryId;
            currentSeconItem.isSelected = YES;
        }
        else
        {
            self.hyDataItem.defaultModel.secondaryName = [self getHYSecondaryListItem].secondaryName;
            self.hyDataItem.defaultModel.secondaryId = [self getHYSecondaryListItem].secondaryId;
            [self getHYSecondaryListItem].isSelected = YES;
        }
        
        
        
        //        3.教材逻辑：
        //            A:取消当前教材的选中状态
        //            B:根据default 获取当前的学期 ： YES：更新本地数据 NO:默认选中第一个
        for (HYThreeLevelListItem * threeItem in [self getHYSecondaryListItem].threeLevelList)  {
            if (threeItem.isSelected == YES) {
                threeItem.isSelected = NO;
            }
        }
        
        
        
        if ([self getHYThreeLevelListItem] ==nil)
        {
            for (HYThreeLevelListItem * threeItem in [self getHYSecondaryListItem].threeLevelList)  {
                if (threeItem.isSelected == YES) {
                    threeItem.isSelected = NO;
                }
            }
            HYThreeLevelListItem * currentThreeItem =  [[self getHYSecondaryListItem].threeLevelList objectAtIndex:0];
            self.hyDataItem.defaultModel.threeLevelName = currentThreeItem.threeLevelName;
            self.hyDataItem.defaultModel.threeLevelId = currentThreeItem.threeLevelId;
            currentThreeItem.isSelected = YES;
            
        }
        else
        {
            self.hyDataItem.defaultModel.threeLevelName = [self getHYThreeLevelListItem].threeLevelName;
            self.hyDataItem.defaultModel.threeLevelId = [self getHYThreeLevelListItem].threeLevelId;
            [self getHYThreeLevelListItem].isSelected = YES;
            
        }
        
    }
    
    
    
    if (indexPath.section ==1)
    {
        
        //        1.点击当前section的替换数据和当前item选中状态学期
        if ([self getHYPrimaryListItem].isClickBehind == 0 )
        {
            return;
        }
        
        for (HYSecondaryListItem * secondItem in [self getHYPrimaryListItem].secondaryList)  {
            if (secondItem.isSelected == YES) {
                secondItem.isSelected = NO;
            }
        }
        HYSecondaryListItem * currentSeconItem=  [[self getHYPrimaryListItem].secondaryList objectAtIndex:indexPath.row];
        currentSeconItem.isSelected = YES;
        self.hyDataItem.defaultModel.secondaryName = currentSeconItem.secondaryName;
        self.hyDataItem.defaultModel.secondaryId = currentSeconItem.secondaryId;
        
        
        
        for (HYThreeLevelListItem * threeItem in [self getHYSecondaryListItem].threeLevelList)  {
            if (threeItem.isSelected == YES) {
                threeItem.isSelected = NO;
            }
        }
        if ([self getHYThreeLevelListItem] ==nil)
        {
            HYThreeLevelListItem * currentThree =  [[self getHYSecondaryListItem].threeLevelList objectAtIndex:0];
            self.hyDataItem.defaultModel.threeLevelName = currentThree.threeLevelName;
            self.hyDataItem.defaultModel.threeLevelId = currentThree.threeLevelId;
            currentThree.isSelected = YES;
            
        }
        else
        {
            self.hyDataItem.defaultModel.threeLevelName = [self getHYThreeLevelListItem].threeLevelName;
            self.hyDataItem.defaultModel.threeLevelId = [self getHYThreeLevelListItem].threeLevelId;
            [self getHYThreeLevelListItem].isSelected = YES;
        }
        
    }
    
    
    
    
    if (indexPath.section ==2) {
        if ([self getHYPrimaryListItem].isClickBehind == 0)
        {
            return;
        }
        
        
        
        HYThreeLevelListItem * currentThreeItem =  [[self getHYSecondaryListItem].threeLevelList objectAtIndex:indexPath.row];
        
        for (HYThreeLevelListItem * threeItem in [self getHYSecondaryListItem].threeLevelList)  {
            if (threeItem.isSelected == YES) {
                threeItem.isSelected = NO;
            }
        }
        currentThreeItem.isSelected = YES;
        self.hyDataItem.defaultModel.threeLevelName = currentThreeItem.threeLevelName;
        self.hyDataItem.defaultModel.threeLevelId = currentThreeItem.threeLevelId;
    }
    
    
    [UIView performWithoutAnimation:^{
        [self.gradeSelectCollectionView reloadData];
    }];
}


#pragma mark-collectionViewDataSource

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    HYGradeCollectViewCell * gradeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HYGradeCollectViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0)
    {
        gradeCell.contentLabel.text = [self.hyDataItem.primaryList objectAtIndex:indexPath.row].primaryName;
        [self.hyDataItem.primaryList objectAtIndex:indexPath.row].indexPath = indexPath;
        
        
//        if ([self.hyDataItem.primaryList objectAtIndex:indexPath.row].isClickBehind == 1)
//        {
            if ([self.hyDataItem.primaryList objectAtIndex:indexPath.row].isSelected) {
                    gradeCell.contentLabel.textColor = [UIColor YXColorWithHexCode:@"#44A6FF"];
                    gradeCell.contentLabel.backgroundColor = [[UIColor YXColorWithHexCode:@"#44A6FF"] colorWithAlphaComponent:0.1];
                }
                else
                {
                    gradeCell.contentLabel.textColor = [UIColor YXColorWithHexCode:@"#141414"];
                    gradeCell.contentLabel.backgroundColor = [UIColor YXColorWithHexCode:@"#F7F9FA"];
                }
                
//        }
//        else
//        {
//            gradeCell.contentLabel.textColor = [[UIColor YXColorWithHexCode:@"#141414"] colorWithAlphaComponent:0.3];
//            gradeCell.contentLabel.backgroundColor = [UIColor YXColorWithHexCode:@"#F7F9FA"];
//        }
        
    
        
        
    }
    else if(indexPath.section == 1)
    {
        gradeCell.contentLabel.text = [[self getHYPrimaryListItem].secondaryList objectAtIndex:indexPath.row].secondaryName;
        [[self getHYPrimaryListItem].secondaryList objectAtIndex:indexPath.row].indexPath = indexPath;
        
      
        if ([[self getHYPrimaryListItem].secondaryList objectAtIndex:indexPath.row].isSelected) {
            gradeCell.contentLabel.textColor = [UIColor YXColorWithHexCode:@"#44A6FF"];
            gradeCell.contentLabel.backgroundColor = [[UIColor YXColorWithHexCode:@"#44A6FF"] colorWithAlphaComponent:0.1];
        }
        else
        {
            gradeCell.contentLabel.textColor = [UIColor YXColorWithHexCode:@"#141414"];
            gradeCell.contentLabel.backgroundColor = [UIColor YXColorWithHexCode:@"#F7F9FA"];
            
        }
        
        if ([self getHYPrimaryListItem].isClickBehind ==0 )
        {
            gradeCell.contentLabel.textColor = [[UIColor YXColorWithHexCode:@"#141414"] colorWithAlphaComponent:0.1];
            gradeCell.contentLabel.backgroundColor = [UIColor YXColorWithHexCode:@"#F7F9FA"];
        }
        
    }
    else if(indexPath.section == 2)
    {
        gradeCell.contentLabel.text = [[self getHYSecondaryListItem].threeLevelList objectAtIndex:indexPath.row].threeLevelName;
        [[self getHYSecondaryListItem].threeLevelList objectAtIndex:indexPath.row].indexPath= indexPath;
        
        if ( [[self getHYSecondaryListItem].threeLevelList objectAtIndex:indexPath.row].isSelected) {
            gradeCell.contentLabel.textColor = [UIColor YXColorWithHexCode:@"#44A6FF"];
            gradeCell.contentLabel.backgroundColor = [[UIColor YXColorWithHexCode:@"#44A6FF"] colorWithAlphaComponent:0.1];
        }
        else
        {
            gradeCell.contentLabel.textColor = [UIColor YXColorWithHexCode:@"#141414"];
            gradeCell.contentLabel.backgroundColor = [UIColor YXColorWithHexCode:@"#F7F9FA"];
        }
        
        if ([self getHYPrimaryListItem].isClickBehind == 0)
        {
            gradeCell.contentLabel.textColor = [[UIColor YXColorWithHexCode:@"#141414"] colorWithAlphaComponent:0.3];
            gradeCell.contentLabel.backgroundColor = [UIColor YXColorWithHexCode:@"#F7F9FA"];
        }
        
    }
    
    

    return gradeCell;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section ==0) {
        return self.hyDataItem.primaryList.count;
    }
    else if(section == 1)
    {
        return [self getHYPrimaryListItem].secondaryList.count;
    }
    else
    {
        return [self getHYSecondaryListItem].threeLevelList.count;
    }
}

//这个方法必写，给headerView高度，让它显示出来
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    CGSize size = {MPT_ScreenW,14};
    return size;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview =nil;
    if (kind == UICollectionElementKindSectionHeader){
        HYRecipeCollectionHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HYRecipeCollectionHeaderView" forIndexPath:indexPath];
        switch (indexPath.section) {
            case 0:
            {
                headerView.headerLabel.text = self.hyDataItem.primaryTitle;
            }
                break;
            case 1:
            {
                headerView.headerLabel.text = self.hyDataItem.secondaryTitle;
            }
                break;
            case 2:
            {
                headerView.headerLabel.text = self.hyDataItem.threeLevelTitle;
            }
                break;
                
            default:
                break;
        }
        reusableview = headerView;
        
    }
    return reusableview;
}


-(UICollectionView *)gradeSelectCollectionView
{
    if (!_gradeSelectCollectionView) {
        UICollectionViewFlowLayout * collectLayOut = [[UICollectionViewFlowLayout alloc]init];
        collectLayOut.itemSize = CGSizeMake(99, 36);
        collectLayOut.scrollDirection = UICollectionViewScrollDirectionVertical;
        collectLayOut.minimumInteritemSpacing = 0;
        collectLayOut.minimumLineSpacing = 16;
        collectLayOut.sectionInset = UIEdgeInsetsMake(20, 16, 24, 16);
        _gradeSelectCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectLayOut];
        _gradeSelectCollectionView.size = CGSizeMake(MPT_ScreenW, 400);
        _gradeSelectCollectionView.delegate = self;
        _gradeSelectCollectionView.dataSource = self;
        _gradeSelectCollectionView.allowsMultipleSelection = YES;
        _gradeSelectCollectionView.backgroundColor = [UIColor YXColorWithHexCode:@"#FFFFFF"];
        [_gradeSelectCollectionView registerClass:[HYGradeCollectViewCell class] forCellWithReuseIdentifier:@"HYGradeCollectViewCell"];
        [_gradeSelectCollectionView registerClass:[HYRecipeCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HYRecipeCollectionHeaderView"];
    }
    return _gradeSelectCollectionView;
}


-(void)dealloc
{
    NSLog(@"销毁");
}


@end
