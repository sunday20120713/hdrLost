//
//  ZLViewController.m
//  ZL3DWebKit
//
//  Created by luokan on 01/18/2022.
//  Copyright (c) 2022 luokan. All rights reserved.
//

#import "ZLViewController.h"
#import <JKSandBoxManager/JKSandBoxManager.h>
#import <ZL3DWebKit/ZL3DWebView.h>

static NSInteger apperanceIndex = 0;

static float modelScale = 0.0f;

@interface ZLViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UIImageView *showImageView;

@property (nonatomic,strong) ZL3DWebView *modelView;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,copy) NSArray *colorArray;

@property (nonatomic,copy) NSArray *innersArray;

@property (nonatomic,copy) NSArray *wheelsArray;

@property (nonatomic,strong) NSArray *chromeArray;

@end

@implementation ZLViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_modelView){
        [_modelView onTabChange:@"true"];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if(_modelView){
        [_modelView onTabChange:@"false"];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.modelView = [[ZL3DWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height * 0.75)];
    
    self.modelView.messageCallBack = ^(NSString *message,NSNumber *progress,NSString *car){
        if(progress && [progress isKindOfClass:[NSNumber class]]){
            NSLog(@"[网页回调Message] ====  %@ progress:%ld\n",message,progress.longValue);
        }
    };
    
    [self.modelView startLoad009ResourceWithParams:@{@"loadcolor":@"ffffff",@"loading":@"0"}];
    [self.modelView changeLoadingBgColor:@"ff0000"];
    [self.view addSubview:self.modelView];
    
    self.colorArray =  @[@"black",@"white",@"silver",@"blue"];
    self.innersArray = @[@"grayWhite",@"blueWhite",@"black"];
    self.wheelsArray = @[@"0",@"1",@"2",@"3"];
    self.chromeArray = @[@"0",@"1"];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - CGRectGetHeight(self.modelView.frame))];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    switch (indexPath.row) {
        case 0:
            titleLabel.text = [NSString stringWithFormat:@"当前外饰颜色:%@",self.colorArray[apperanceIndex]];
            break;
        case 1:
            titleLabel.text = [NSString stringWithFormat:@"当前缩放比:%.1f",modelScale];
            break;
            
        case 2:
            titleLabel.text = @"重置视觉";
            break;
            
        case 3:
            titleLabel.text = @"切换金属饰条";
            break;
        case 4:
            titleLabel.text = @"切换内饰";
            break;
        case 5:
            titleLabel.text = @"切换轮毂";
            break;
            
        default:
            break;
    }
    [cell.contentView addSubview:titleLabel];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0: // 改颜色
        {
            apperanceIndex = (apperanceIndex+1)%self.colorArray.count;
//            [self.modelView change009Color:self.colorArray[apperanceIndex]];
            [self.modelView changeColor:self.colorArray[apperanceIndex] isSame:YES isTrim:YES];
            [tableView reloadData];
        }
            break;
        case 1: // 缩放
        {
            modelScale += 0.1;
            if(modelScale > 1.0){
                modelScale = .0f;
            }
            [self.modelView setModelScale:modelScale];
            [tableView reloadData];
        }
            break;
        case 2: // 重置视觉
        {
            [self.modelView resetPerspective];
        }
            break;
        case 3: // 切换金属饰条
        {
            static int index = 0;
            if(index == 0){
                [self.modelView changeChrome:self.chromeArray[0]];
                index = 1;
            }else{
                [self.modelView changeChrome:self.chromeArray[1]];
                index = 0;
            }
        }
            break;
        case 4:// 切换内饰
        {
            apperanceIndex = (apperanceIndex+1)%self.innersArray.count;
            [self.modelView changeInner:self.innersArray[apperanceIndex]];
        }
            break;
        case 5:// 切换轮毂
        {
            apperanceIndex = (apperanceIndex+1)%self.wheelsArray.count;
            [self.modelView changeWheel:self.wheelsArray[apperanceIndex]];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

-(void) test{
    NSBundle *curBundle = [JKSandBoxManager bundleWithBundleName:@"ZL3DWebKit"];
    NSString *jsBundlePath = [curBundle pathForResource:@"ZL3DWeb" ofType:@"bundle"];
    NSString *indexPath = [jsBundlePath stringByAppendingPathComponent:@"index.html"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExist = [fileManager fileExistsAtPath:indexPath];
    NSLog(@"文件存在吗？  %@\n",fileExist?@"YES":@"NO");
    
    NSString *loadingPath = [jsBundlePath stringByAppendingPathComponent:@"assets/loading/loading.png"];
    BOOL loadingExist = [fileManager fileExistsAtPath:loadingPath];
    
    NSLog(@"loadingExist = %@\n",loadingExist?@"YES":@"NO");
}

@end
