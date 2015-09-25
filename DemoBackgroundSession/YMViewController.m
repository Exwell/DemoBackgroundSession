//
//  YMViewController.m
//  DemoBackgroundSession
//
//  Created by Александр О. Кургин on 21.09.15.
//  Copyright (c) 2015 Yandex.Money. All rights reserved.
//

#import "YMViewController.h"

static NSString *kImageURL = @"http://picsfab.com/download/image/62762/7488x7488_dve-romashki-v-bolshom-pole.jpg";

@interface YMViewController () <NSURLSessionDownloadDelegate>

@property (weak, nonatomic) IBOutlet UIProgressView *ibProgressView;
@property (weak, nonatomic) IBOutlet UIImageView *ibImageView;

@property (strong, nonatomic) NSURLSession *backgroundSession;
@property (strong, nonatomic) NSURLSessionDownloadTask *downloadTask;

@property (strong, nonatomic, readonly) NSURL *destinationURL;

@end

@implementation YMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.ibProgressView.progress = 0.0;

    NSString *backgroundIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration backgroundSessionConfigurationWithIdentifier:backgroundIdentifier];

    configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;

    self.backgroundSession = [NSURLSession sessionWithConfiguration:configuration
                                                           delegate:self
                                                      delegateQueue:nil];
}


#pragma mark - Button actions

- (IBAction)crashButtondDidTapped:(id)sender
{
    exit(0);
}

- (IBAction)loadButtonDidTapped:(id)sender
{
    if (self.downloadTask == nil) {
        self.ibProgressView.progress = 0.0f;
        self.ibImageView.image = nil;
        [[NSFileManager defaultManager] removeItemAtURL:self.destinationURL error:NULL];
        NSURL *imageURL = [NSURL URLWithString:kImageURL];
        self.downloadTask = [self.backgroundSession downloadTaskWithURL:imageURL];
        [self.downloadTask resume];
    }
}


#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    [[NSFileManager defaultManager] copyItemAtURL:location toURL:self.destinationURL error:NULL];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:self.destinationURL];
        self.ibImageView.image = [UIImage imageWithData:imageData];
    });
    self.downloadTask = nil;
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.ibProgressView.progress = (float) totalBytesWritten / (float) totalBytesExpectedToWrite;
    });
}

- (void)URLSessionDidFinishEventsForBackgroundURLSession:(NSURLSession *)session
{
    void (^backgroundSessionCompletionHandler)() = self.backgroundSessionCompletionHandler;
    if (backgroundSessionCompletionHandler != NULL) {
        self.backgroundSessionCompletionHandler = NULL;
        backgroundSessionCompletionHandler();
    }
}


#pragma mark - Getters and setters

- (NSURL *)destinationURL
{
    NSURL *cacheURL = [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory
                                                              inDomains:NSUserDomainMask] firstObject];

    NSURL *resultURL = [cacheURL URLByAppendingPathComponent:@"image.png"];
    return resultURL;
}

@end
