//
//  ViewController.m
//  QGScrollLabel
//
//  Created by silicn on 2019/5/8.
//  Copyright © 2019 Silicn. All rights reserved.
//

#import "ViewController.h"
#import "MyViewCell.h"

#import "UITableView+RefreshControl.h"

#import "QGRotationCircleView.h"

#import "UIButton+QGLoading.h"



@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.whiteColor;

    
    [self.tableView registerNib:[UINib nibWithNibName:@"MyViewCell" bundle:nil] forCellReuseIdentifier:@"MyViewCell"];
    __weak typeof(self) weakSelf = self;
    
    self.tableView.pageCount = 10;
    [self.tableView initRefreshWithHandle:^(BOOL isRefresh) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.tableView endRefreshWithRefreshBlock:^{
                    NSLog(@"refreshData");
                } loadDataBlock:^int{
                    NSLog(@"EndLoadData");
                    return 10;
                }];
            [self.tableView reloadData];
      });  
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 150, 40);
    btn.center = self.view.center;
    [self.view addSubview:btn];
    btn.backgroundColor = [UIColor colorWithRed:252/255.0 green:107/255.0 blue:80/255.0 alpha:1.0];
    btn.layer.cornerRadius = 20;
    btn.clipsToBounds = YES;
//    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    
    [btn setTitle:@"注册" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    
   
    
//    self.tableView.tableFooterView = [[UIView alloc]init];
    
    // Do any additional setup after loading the view.
}

- (void)btnAction:(UIButton *)btn
{
    [btn beginLoadingWithLoadStateName:@"提交中..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [btn endLoading];
    });
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyViewCell"];
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ViewController *vc  = [[ViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (UIImage *)circleImageWithColor:(UIColor *)color
{
    CGFloat scale = [UIScreen mainScreen].scale;
    CGSize size = CGSizeMake(36*scale, 36*scale);
    // 开始图形上下文，NO代表透明
    UIGraphicsBeginImageContextWithOptions(size, NO, scale);
    // 获得图形上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [color setFill];
    // 设置一个范围
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextFillEllipseInRect(ctx,rect);
    CGContextClip(ctx);
    // 从上下文上获取剪裁后的照片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}


@end