//
//  ViewController.m
//  LLYSwipeView
//
//  Created by lly on 2017/5/9.
//  Copyright © 2017年 lly. All rights reserved.
//

#import "ViewController.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kBtnWidth kScreenWidth/5;

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,assign) CGFloat lastOffsetX;
@property (nonatomic,assign) CGFloat currentOffsetX;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self.view addSubview:self.scrollView];
    [self addViews];
    [self.view addSubview:self.headerView];
    [self addBtns];
}


- (UIScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.view.frame];
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = YES;
        _scrollView.contentSize = CGSizeMake(kScreenWidth * 5, 0);
    }
    
    return _scrollView;
}

- (void)addViews{

    for (int i = 0; i < 5; i++) {
        
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        
        CGFloat color1 = (arc4random() % 256) / 256.00;
        CGFloat color2 = (arc4random() % 256) / 256.00;
        CGFloat color3 = (arc4random() % 256) / 256.00;
        
        view.backgroundColor = [UIColor colorWithRed:color1 green:color2 blue:color3 alpha:1];
        [self.scrollView addSubview:view];
    }
}

- (UIView *)headerView{

    if (!_headerView) {
        _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _headerView.backgroundColor = [UIColor whiteColor];
    }
    return _headerView;
}

- (void)addBtns{
    
    CGFloat btnWidth = kScreenWidth/5;

    for (int i = 0; i < 5; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*btnWidth, 20, btnWidth, 44)];
        btn.tag = 1000+i;
        [btn setTitle:[NSString stringWithFormat:@"标题%d",i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.headerView addSubview:btn];
        
        if (i == 0) {
            [self.headerView addSubview:self.lineView];
            CGPoint lineCenter = CGPointMake(btn.center.x, 62);
            self.lineView.center = lineCenter;
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            btn.layer.affineTransform = CGAffineTransformMakeScale(1.2, 1.2);
        }
    }
}


- (UIView *)lineView{

    CGFloat lineWidth = kScreenWidth/5/2;

    if (!_lineView) {
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, lineWidth, 4)];
        _lineView.backgroundColor = [UIColor redColor];
    }
    
    return _lineView;
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    self.currentOffsetX = scrollView.contentOffset.x;
    int index = scrollView.contentOffset.x / kScreenWidth;
    CGFloat dOffsetX = self.currentOffsetX - self.lastOffsetX;
    
//    NSLog(@"index = %d",index);
    UIButton *currentBtn,*nextBtn,*lastBtn;
    for (UIButton *btn in self.headerView.subviews) {
        if (dOffsetX > 0){
            //左滑 index++
            if (btn.tag == 1000+index) {
                currentBtn = btn;
            }
            else if (btn.tag == 1000+index+1) {
                nextBtn = btn;
            }
        }
        else if (dOffsetX < 0){
            //右滑 index--
            if (btn.tag == 1000+index + 1) {
                lastBtn = btn;
            }
            else if (btn.tag == 1000+index) {
                currentBtn = btn;
            }
        }
    }
    CGFloat offsetX = ABS(scrollView.contentOffset.x - index * kScreenWidth);
    CGFloat scale = offsetX / kScreenWidth;
    CGFloat lineXOffset = scale * kBtnWidth;
    
    if (dOffsetX > 0) {
        [nextBtn setTitleColor:[UIColor colorWithRed:scale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        nextBtn.layer.affineTransform = CGAffineTransformMakeScale(1+scale * 0.2, 1+scale * 0.2);
    }
    else if (dOffsetX < 0){
        [lastBtn setTitleColor:[UIColor colorWithRed:scale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
        lastBtn.layer.affineTransform = CGAffineTransformMakeScale(1+scale * 0.2, 1+scale * 0.2);
    }
    
    [currentBtn setTitleColor:[UIColor colorWithRed:1-scale green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    currentBtn.layer.affineTransform = CGAffineTransformMakeScale(1 + 0.2 *(1-scale) , 1 + 0.2 *(1-scale));

    self.lineView.center = CGPointMake(currentBtn.center.x + lineXOffset, 62);
    self.lineView.layer.affineTransform = CGAffineTransformMakeScale(1 + scale, 1);
    
    NSLog(@"scalee = %f",scale);
    
    self.lastOffsetX = scrollView.contentOffset.x;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{

    int index = scrollView.contentOffset.x / kScreenWidth;
    NSLog(@"EndDecelerating index = %d",index);
    
    UIButton *currentBt;
    for (UIButton *btn in self.headerView.subviews) {
        if (btn.tag == 1000+index) {
            currentBt = btn;
        }
    }
    
    [currentBt setTitleColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:1] forState:UIControlStateNormal];
    currentBt.layer.affineTransform = CGAffineTransformMakeScale(1.2, 1.2);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
