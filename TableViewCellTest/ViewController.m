//
//  ViewController.m
//  TableViewCellTest
//
//  Created by victor on 2017/6/30.
//  Copyright © 2017年 victor. All rights reserved.
//

#import "ViewController.h"
#import "MainTableViewCell.h"


static NSString * const MainTableViewCellIndentifier = @"MainTableViewCellIndentifier";
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView    *mainTableView;
@property (nonatomic, strong) NSIndexPath     *canEditindexPath;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.mainTableView];
    self.mainTableView.frame = self.view.bounds;
    [self.mainTableView registerClass:[MainTableViewCell class] forCellReuseIdentifier:MainTableViewCellIndentifier];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//demo中在恢复的时候最后会出现跳动一下，是因为我是用的是系统的textLabel系统做了优化，在编辑的吧时候改变尺寸了，自己定义的不会出现这种情况

#pragma mark -  UITableViewDataSource & UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MainTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:MainTableViewCellIndentifier forIndexPath:indexPath];
    cell.textLabel.text = @"嘎嘎嘎嘎";
    __weak typeof(self) weakSlef = self;
    cell.animationBlock = ^(BOOL endEdit){
        if (endEdit) {
            weakSlef.canEditindexPath = nil;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //编辑完成之后要恢复编辑状态
                [tableView setEditing:NO animated:NO];
            });
        }else{
            //找到命中cell 设置为可编辑状态，出现编辑红色按钮
            weakSlef.canEditindexPath = indexPath;
            [tableView setEditing:YES animated:YES];
        }
    };
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置只有命中cell 才可以编辑
    if (self.canEditindexPath) {
        if (self.canEditindexPath.row == indexPath.row) {
            return YES;
        }else{
            return NO;
        }
    }else{
        //没有命中cell的时候，是都可以编辑的，这样才可以实现
        return YES;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView setEditing:NO animated:NO];
    
}


#pragma mark - set & get
- (UITableView *)mainTableView{
    if (_mainTableView == nil) {
        _mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _mainTableView.delegate = self;
        _mainTableView.dataSource = self;
    }
    return _mainTableView;
}

@end
