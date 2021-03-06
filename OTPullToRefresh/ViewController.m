//
//  ViewController.m
//  OTPullToRefresh
//
//  Created by king.wu on 1/29/15.
//  Copyright (c) 2015 king.wu. All rights reserved.
//

#import "ViewController.h"
#import "UIScrollView+OTPullToRefresh.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor grayColor];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setupDataSource];
   
    UIEdgeInsets inset =  self.tableView.contentInset;
    inset.top = 64;
    self.tableView.contentInset = inset;
    [self.tableView addPullDownRefreshWithAction:^{
        
        [self insertRowAtTop];
    } type:OTPullDownRefreshTypeDefault];
    
    
    [self.tableView addPullUpRefreshWithAction:^{
        [self insertRowAtBottom];
    } type:OTPullUpRefreshTypeDefault];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setupDataSource {
    self.dataSource = [NSMutableArray array];
    for(int i=0; i<20; i++)
        [self.dataSource addObject:[NSDate dateWithTimeIntervalSinceNow:-(i*90)]];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSLog(@"will appear");
}
- (void)viewWillLayoutSubviews
{
    NSLog(@"will layoutSub");
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:animated];
    [self.tableView autoTriggerPullDownRefresh];
    
    
}

- (void)insertRowAtTop {
    __weak ViewController *weakSelf = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        BOOL isSuccess = YES;
        if (isSuccess) {
            
            [weakSelf.tableView beginUpdates];
           
            
            for (int i = 0 ; i<3; i++) {
                [weakSelf.dataSource insertObject:[NSDate date] atIndex:0];
            }
            
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0],[NSIndexPath indexPathForRow:1 inSection:0],[NSIndexPath indexPathForRow:2 inSection:0] ] withRowAnimation:UITableViewRowAnimationFade];
            
            
            [weakSelf.tableView endUpdates];
            }
        
        [weakSelf.tableView pullDownRefreshDataSuccess:isSuccess];
    });
}


- (void)insertRowAtBottom {
    __weak ViewController *weakSelf = self;
    
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC);
    
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        BOOL isSuccess = YES;
        if (isSuccess) {
            [weakSelf.tableView beginUpdates];
            
            for (int i = 0 ; i<2; i++) {
                [weakSelf.dataSource addObject:[NSDate date]];
            }
            
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.dataSource.count-2 inSection:0], [NSIndexPath indexPathForRow:weakSelf.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
            
            [weakSelf.tableView endUpdates];

        }
        
        [weakSelf.tableView pullUpRefreshDataSuccess:isSuccess];
    });
}


#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
    NSDate *date = [self.dataSource objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSDateFormatter localizedStringFromDate:date dateStyle:NSDateFormatterNoStyle timeStyle:NSDateFormatterMediumStyle];
    return cell;
}


@end
