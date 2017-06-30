//
//  MainTableViewCell.h
//  TableViewCellTest
//
//  Created by victor on 2017/6/30.
//  Copyright © 2017年 victor. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FCVTCallAnimationBlock)(BOOL endEdit);

@interface MainTableViewCell : UITableViewCell

@property (nonatomic, copy) FCVTCallAnimationBlock  animationBlock;
@end
