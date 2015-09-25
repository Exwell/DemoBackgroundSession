//
//  YMViewController.h
//  DemoBackgroundSession
//
//  Created by Александр О. Кургин on 21.09.15.
//  Copyright (c) 2015 Yandex.Money. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMViewController : UIViewController

@property (nonatomic, copy) void (^backgroundSessionCompletionHandler)();

@end
