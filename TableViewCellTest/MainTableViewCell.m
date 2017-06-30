//
//  MainTableViewCell.m
//  TableViewCellTest
//
//  Created by victor on 2017/6/30.
//  Copyright © 2017年 victor. All rights reserved.
//

#import "MainTableViewCell.h"
#import <objc/message.h>

@interface MainTableViewCell ()
@property (nonatomic, strong) UIButton    *testButton;
@property (nonatomic, assign) BOOL             isEditing;

@end

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.testButton];
        self.testButton.frame = CGRectMake(250, 0, 40, 40);
    }
    return self;
}
#pragma mark - touch event
- (void)buttonClick{
    //Xcode 8.0以上的才可以使用此方法 而且不能自己添加支持7.0 的，如果自己添加支持7.0则实效，使用下面哪种方法
    //    objc_msgSend(self, NSSelectorFromString(@"setShowingDeleteConfirmation:"),YES);
    
    
    //Xcode 7.0 使用该方法
    //block回掉执行 [tableView setEditing:YES animated:NO]; 同时设置命中cell
    self.animationBlock?self.animationBlock(NO):nil;
    UIView *view = [self recurseAndReplaceSubViewIfDeleteConfirmationControl:self.subviews];
    if (view) {
        if ([view isKindOfClass:[UIControl class]]) {
            //隐藏view的相关显示 红色减号图标
            UIControl *control = (UIControl *)view;
            for (UIView *view in control.subviews) {
                if (view) {
                    view.hidden = YES;
                }
            }
            //直接调用这个出触发事件的方法
            [control sendActionsForControlEvents:UIControlEventTouchUpInside];
        };
    }
    //当前状态正在编辑
    _isEditing = YES;
    
}
-(void)willTransitionToState:(UITableViewCellStateMask)state{
    //正在编辑状态 状态改变的时候 恢复默认设置
    if (_isEditing) {
        _isEditing = NO;
        self.animationBlock?self.animationBlock(YES):nil;
        //动画时间测试了一下 0.5秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UIView *view = [self recurseAndReplaceSubViewIfDeleteConfirmationControl:self.subviews];
            if (view) {
                if ([view isKindOfClass:[UIControl class]]) {
                    UIControl *control = (UIControl *)view;
                    for (UIView *view in control.subviews) {
                        if (view) {
                            view.hidden = NO;
                        }
                    }
                };
            }
        });
    }
    [super willTransitionToState:state];
}

//找到红色编辑按钮
-(UIView *)recurseAndReplaceSubViewIfDeleteConfirmationControl:(NSArray*)subviews{
    for (UIView *subview in subviews){
        if ([NSStringFromClass([subview class]) isEqualToString:@"UITableViewCellEditControl"]){
            return subview;
        }
    }
    return nil;
}


#pragma mark - set & get
- (UIButton *)testButton{
    if (_testButton == nil) {
        _testButton = [[UIButton alloc] initWithFrame:CGRectZero];
        _testButton.backgroundColor = [UIColor redColor];
        [_testButton addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _testButton;
}

@end
