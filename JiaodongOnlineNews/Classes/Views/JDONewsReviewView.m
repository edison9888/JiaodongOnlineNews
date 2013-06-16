//
//  JDONewsReviewView.m
//  JiaodongOnlineNews
//
//  Created by zhang yi on 13-6-16.
//  Copyright (c) 2013年 胶东在线. All rights reserved.
//

#import "JDONewsReviewView.h"
#import "UIColor+SSToolkitAdditions.h"
#import <ShareSDK/ShareSDK.h>
#import "AGCustomShareItemView.h"

#define Review_Text_Init_Height 40
#define Review_Left_Margin 10
#define Review_Right_Margin 10
#define SubmitBtn_Width 60
#define Review_Content_MaxLength 100
#define Review_SubmitBtn_Tag 200

@interface JDONewsReviewView ()

@property (strong, nonatomic) CMHTableView *tableView;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) NSArray *oneKeyShareListArray;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) JDONewsDetailController *controller;

@end

@implementation JDONewsReviewView

- (id)initWithFrame:(CGRect)frame controller:(JDONewsDetailController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        self.controller = controller;
        self.backgroundColor = [UIColor grayColor];
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        _textView = [[HPGrowingTextView alloc] initWithFrame:CGRectMake(Review_Left_Margin, 4/*背景图片偏移*/, 320-Review_Left_Margin-10-SubmitBtn_Width, Review_Text_Init_Height)];
        _textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
        _textView.minNumberOfLines = 1;
        _textView.maxNumberOfLines = 5;
        _textView.font = [UIFont systemFontOfSize:15];
        _textView.delegate = self;
        _textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
        _textView.animateHeightChange = NO; //turns off animation
        //    _textView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _textView.backgroundColor = [UIColor whiteColor];
        
        UIImage *entryBackground = [[UIImage imageNamed:@"MessageEntryInputField.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *entryImageView = [[UIImageView alloc] initWithImage:entryBackground];
        entryImageView.frame = CGRectMake(Review_Left_Margin, 0, 320-Review_Left_Margin-10-SubmitBtn_Width, Review_Text_Init_Height);
        entryImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        UIImage *background = [[UIImage imageNamed:@"MessageEntryBackground.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:22];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:background];
        imageView.frame = CGRectMake(0, 0, 320, Review_Text_Init_Height);
        imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self addSubview:imageView];
        [self addSubview:_textView];
        [self addSubview:entryImageView];
        
        UIImage *sendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        UIImage *selectedSendBtnBackground = [[UIImage imageNamed:@"MessageEntrySendButton.png"] stretchableImageWithLeftCapWidth:13 topCapHeight:0];
        
        UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom] ;
        submitBtn.tag = Review_SubmitBtn_Tag;
        submitBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
        submitBtn.frame = CGRectMake(320-Review_Right_Margin-SubmitBtn_Width, 8, SubmitBtn_Width, 27);
        [submitBtn addTarget:self action:@selector(submitReview:) forControlEvents:UIControlEventTouchUpInside];
        [submitBtn setTitle:@"发表" forState:UIControlStateNormal];
        [submitBtn setTitleShadowColor:[UIColor colorWithWhite:0 alpha:0.4] forState:UIControlStateNormal];
        submitBtn.titleLabel.shadowOffset = CGSizeMake (0.0, -1.0);
        submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
        [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:sendBtnBackground forState:UIControlStateNormal];
        [submitBtn setBackgroundImage:selectedSendBtnBackground forState:UIControlStateSelected];
        [self addSubview:submitBtn];
        
        
        _remainWordNum = [[UILabel alloc] initWithFrame:CGRectMake(320-Review_Right_Margin-SubmitBtn_Width+2, 10, SubmitBtn_Width, 30)];
        _remainWordNum.hidden = true;
        _remainWordNum.backgroundColor =[UIColor clearColor];
        _remainWordNum.numberOfLines = 2;
        _remainWordNum.font = [UIFont systemFontOfSize:12];
        _remainWordNum.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin;
        [self addSubview:_remainWordNum];
        
        // 分享栏
        _textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = [UIColor colorWithHex:@"d2d2d2"];
        _textLabel.text = @"分享到:";
        _textLabel.font = [UIFont boldSystemFontOfSize:12];
        [_textLabel sizeToFit];
        _textLabel.frame = CGRectMake(3, 40, _textLabel.frame.size.width + 3, 30);
        _textLabel.contentMode = UIViewContentModeCenter;
        [self addSubview:_textLabel];
        float tableViewX = _textLabel.frame.origin.x+_textLabel.frame.size.width;
        
        _tableView = [[CMHTableView alloc] initWithFrame:CGRectMake(tableViewX, 40, 320-tableViewX, 30)];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.itemWidth = 40;
        _tableView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_tableView];
        
        _oneKeyShareListArray = @[
            @{@"type":SHARE_TYPE_NUMBER(ShareTypeSinaWeibo),@"selected":[NSNumber numberWithBool:NO]},
            @{@"type":SHARE_TYPE_NUMBER(ShareTypeTencentWeibo),@"selected":[NSNumber numberWithBool:NO]},
            @{@"type":SHARE_TYPE_NUMBER(ShareTypeQQSpace),@"selected":[NSNumber numberWithBool:NO]},
            @{@"type":SHARE_TYPE_NUMBER(ShareType163Weibo),@"selected":[NSNumber numberWithBool:NO]},
            @{@"type":SHARE_TYPE_NUMBER(ShareTypeSohuWeibo),@"selected":[NSNumber numberWithBool:NO]},                         
            @{@"type":SHARE_TYPE_NUMBER(ShareTypeRenren),@"selected":[NSNumber numberWithBool:NO]},
            @{@"type":SHARE_TYPE_NUMBER(ShareTypeKaixin),@"selected":[NSNumber numberWithBool:NO]},
            @{@"type":SHARE_TYPE_NUMBER(ShareTypeDouBan),@"selected":[NSNumber numberWithBool:NO]}
        ];
    }
    return self;
}

- (NSArray *)selectedClients
{
    NSMutableArray *clients = [NSMutableArray array];
    
    for (int i = 0; i < [_oneKeyShareListArray count]; i++)
    {
        NSDictionary *item = [_oneKeyShareListArray objectAtIndex:i];
        if ([[item objectForKey:@"selected"] boolValue])
        {
            [clients addObject:[item objectForKey:@"type"]];
        }
    }
    
    return clients;
}

#pragma mark - CMHTableViewDataSource

- (NSInteger)itemNumberOfTableView:(CMHTableView *)tableView
{
    return [_oneKeyShareListArray count];
}

- (UIView<ICMHTableViewItem> *)tableView:(CMHTableView *)tableView itemForIndexPath:(NSIndexPath *)indexPath
{
    static NSString *reuseId = @"item";
    AGCustomShareItemView *itemView = (AGCustomShareItemView *)[tableView dequeueReusableItemWithIdentifier:reuseId];
    if (itemView == nil){
        itemView = [[AGCustomShareItemView alloc] initWithReuseIdentifier:reuseId clickHandler:^(NSIndexPath *indexPath) {
            if (indexPath.row < [_oneKeyShareListArray count]){
                
                [self.controller hideReviewView];
                NSMutableDictionary *item = [_oneKeyShareListArray objectAtIndex:indexPath.row];
                ShareType shareType = [[item objectForKey:@"type"] integerValue];
              
                if ([ShareSDK hasAuthorizedWithType:shareType]){
                    BOOL selected = ! [[item objectForKey:@"selected"] boolValue];
                    [item setObject:[NSNumber numberWithBool:selected] forKey:@"selected"];
                    [_tableView reloadData];
                }else{
                    id<ISSAuthOptions> authOptions = [ShareSDK authOptionsWithAutoAuth:YES
                                                                       allowCallback:YES
                                                                       authViewStyle:SSAuthViewStyleModal
                                                                        viewDelegate:self
                                                             authManagerViewDelegate:self];
                  
                    //在授权页面中添加关注官方微博
                    [authOptions setFollowAccounts:@{
                        SHARE_TYPE_NUMBER(ShareTypeSinaWeibo):[ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"ShareSDK"],
                        SHARE_TYPE_NUMBER(ShareTypeTencentWeibo):[ShareSDK userFieldWithType:SSUserFieldTypeName valeu:@"ShareSDK"]}];
                  
                    [ShareSDK getUserInfoWithType:shareType
                                    authOptions:authOptions
                                         result:^(BOOL result, id<ISSUserInfo> userInfo, id<ICMErrorInfo> error) {
                                             if (result){
                                                 [item setObject:[NSNumber numberWithBool:YES] forKey:@"selected"];
                                                 [_tableView reloadData];
                                             }else{
                                                 if ([error errorCode] != -103){
                                                     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"绑定失败!" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
                                                     [alertView show];
                                                 }
                                             }
                                         }];
                }
            }
        }];
    }
    
    if (indexPath.row < [_oneKeyShareListArray count]){
        NSDictionary *item = [_oneKeyShareListArray objectAtIndex:indexPath.row];
        UIImage *icon = [ShareSDK getClientIconWithType:[[item objectForKey:@"type"] integerValue]];
        itemView.iconImageView.image = icon;
        
        if ([[item objectForKey:@"selected"] boolValue]){
            itemView.iconImageView.alpha = 1;
        }else{
            itemView.iconImageView.alpha = 0.3;
        }
    }
    
    return itemView;
}

- (void)viewOnWillDisplay:(UIViewController *)viewController shareType:(ShareType)shareType{

    [viewController.navigationController setNavigationBarHidden:true];
    UIView *authView = (UIView *)[[viewController.view subviews] objectAtIndex:1];
//    NSAssert([authView isKindOfClass:NSClassFromString(@"SSSinaWeiboAuthView")], @"authView不是SSSinaWeiboAuthView");
    authView.frame = CGRectMake(0, 44, 320, App_Height-44-40);
    _backBtn = (UIButton *)[[[[viewController.navigationController.navigationBar items] objectAtIndex:0] leftBarButtonItem] customView];
    JDONavigationView *navigationView = [[JDONavigationView alloc] init];
    [navigationView addBackButtonWithTarget:self action:@selector(backToParent)];
    [navigationView setTitle:@"分享"];
    [viewController.view addSubview:navigationView];
}

- (void) backToParent{
    [_backBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    [self.controller writeReview];
}

#pragma mark - GrowingTextView delegate

//- (BOOL)growingTextViewShouldBeginEditing:(HPGrowingTextView *)growingTextView;
//- (BOOL)growingTextViewShouldEndEditing:(HPGrowingTextView *)growingTextView;

//- (void)growingTextViewDidBeginEditing:(HPGrowingTextView *)growingTextView;
//- (void)growingTextViewDidEndEditing:(HPGrowingTextView *)growingTextView;

- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (range.location>=Review_Content_MaxLength)  return  NO;
    return YES;
}
- (void)growingTextViewDidChange:(HPGrowingTextView *)growingTextView{
    // 计算剩余可输入字数
    int remain = Review_Content_MaxLength-_textView.text.length;
    [_remainWordNum setText:[NSString stringWithFormat:@"还有%d字可以输入",remain<0 ? 0:remain]];
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView willChangeHeight:(float)height{
    float diff = (growingTextView.frame.size.height - height);
    
	CGRect r = self.frame;
    r.size.height -= diff;
    r.origin.y += diff;
	self.frame = r;
    
    if(r.size.height > 60){
        [_remainWordNum setHidden:false];
    }else{
        [_remainWordNum setHidden:true];
    }
}
//- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height;

//- (void)growingTextViewDidChangeSelection:(HPGrowingTextView *)growingTextView;
//- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView;

#pragma mark - TextView delegate

//- (void)textViewDidBeginEditing:(UITextView *)textView{
//
//}
//- (void)textViewDidEndEditing:(UITextView *)textView{
//
//}
//
//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
//    if (range.location>=Review_Max_Length){
//        return  NO;
//    }else{
//        return YES;
//    }
//}
//
//- (void)textViewDidChange:(UITextView *)textView{
//    int remain = Review_Max_Length-textView.text.length;
//    [(UILabel *)[self.reviewPanel viewWithTag:Remain_Word_Label] setText:[NSString stringWithFormat:@"还有%d字可输入",remain<0 ? 0:remain]];
//}
//
//- (void)textViewDidChangeSelection:(UITextView *)textView{
//
//}


@end
