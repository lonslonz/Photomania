//
//  URLViewController.m
//  Photomania
//
//  Created by 이종민 on 2014. 5. 31..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import "URLViewController.h"

@interface URLViewController ()

@end

@implementation URLViewController
-(void)setUrl:(NSURL *)url
{
    _url = url;
    [self updateUI];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self updateUI];
    // Do any additional setup after loading the view.
}
- (void)updateUI
{
    self.urlTextView.text = [self.url absoluteString];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
