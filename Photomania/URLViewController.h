//
//  URLViewController.h
//  Photomania
//
//  Created by 이종민 on 2014. 5. 31..
//  Copyright (c) 2014년 house. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface URLViewController : UIViewController
@property (nonatomic, strong) NSURL *url;
@property (weak, nonatomic) IBOutlet UITextView *urlTextView;
@end
