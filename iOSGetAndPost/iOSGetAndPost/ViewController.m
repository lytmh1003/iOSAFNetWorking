//
//  ViewController.m
//  iOSGetAndPost
//
//  Created by 李育腾 on 2022/11/27.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // POST
    NSURL *url = [NSURL URLWithString:@"www.com"];
    //
    NSMutableURLRequest *mutableRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    //
    [mutableRequest setHTTPMethod:@"POST"];
    
    // [mutableRequest setValue:(nullable NSString *) forHTTPHeaderField:(nonnull NSString *)];
    [mutableRequest setValue:@"" forHTTPHeaderField:@""];
    
    //
    NSString* param = [NSString stringWithFormat:@"username = 123456 & password = 123456"];
    //
    mutableRequest.HTTPBody = [param dataUsingEncoding:NSUTF8StringEncoding];
    //
    NSURLSession *session = [NSURLSession sharedSession];
    //
    NSURLSessionDataTask *dataTask2 = [session dataTaskWithRequest:mutableRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        ;
    }];
    [dataTask2 resume];
}



@end
