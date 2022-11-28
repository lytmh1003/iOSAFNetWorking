//
//  ViewController.m
//  iOSAFNetWorking
//
//  Created by 李育腾 on 2022/11/28.
//

#import "ViewController.h"
#import "AFNetworking.h"//主要用于网络请求方法
#import "UIKit+AFNetworking.h"//里面有异步加载图片的方法
@interface ViewController ()
@property (nonatomic, strong)NSDictionary *AFNetWorkTestGETDictionary;
@property (nonatomic, strong)NSMutableDictionary *AFNetWorkTestPOSTDictionary;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self GETNet];
    [self POSTNet];
}
#pragma mark GET请求
/**
 发送get请求
 第一个参数：NSString类型的请求路径，AFN内部会自动将该路径包装为一个url并创建请求对象
 第二个参数：请求参数，此处为nil
 第三个参数：进度回调，此处为nil
 第四个参数：请求成功之后回调Block
 第五个参数：请求失败回调Block
 */
- (void)GETNet {
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 发送GET请求
    [manager GET:@"https://news-at.zhihu.com/api/4/news/before/20221023" parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"GET 请求成功, %@", responseObject[@"date"]);
        self.AFNetWorkTestGETDictionary = responseObject;
        //responseObject是请求成功返回的相应结果，在AFN内部已经把相应结果转换为OC对象，通常是字典或者数组
        NSLog(@"%@", self.AFNetWorkTestGETDictionary);
        // 转化为字典
        NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"GET 失败");
    }];
    
}


#pragma mark GET和POST的区别联系
/**POST 和 GET 区别
 据了解GET和POST都是HTTP协议中的两种发送请求的方法。由于并未学习到很深入，在这里简单了解了下主要的区别。
- GET是从服务器上获取数据，POST是向服务器传送数据。
- **GET产生一个TCP数据包；POST产生两个TCP数据包**
- 对于GET方式的请求，浏览器会把http header和Data一并发送出去，服务器响应200（返回数据）；
- 而对于POST，浏览器先发送header，服务器响应100 continue，浏览器再发送data，服务器响应200 才会（返回数据）。
- **我的理解就是：对于GET只需要跑一趟就可以把数据传输到位，而POST则需要先去进行一个请求的过程，然后在把数据安排到位！**
- 重要的点：GET 安全性非常低，POST安全性较高。但是执行效率却比POST方法好。
 
 
 */
#pragma mark POST请求
/***
 第一个参数：NSString类型的请求路径，AFN内部会自动将该路径包装为一个url并创建请求对象
 第二个参数：请求参数，以字典的方式传递，AFN内部会判断当前是POST请求还是GET请求，以选择直接拼接还是转换为NSData放到请求体中传递
 第三个参数：进度回调 此处为nil
 第四个参数：请求成功之后回调Block
 第五个参数：请求失败回调Block
 */
- (void)POSTNet {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //创建参数
    //
    [self.AFNetWorkTestPOSTDictionary setObject:@"Viper" forKey:@"userName"];
    [self.AFNetWorkTestPOSTDictionary setObject:@"Viper333" forKey:@"passWord"];
    //发送POST请求
    [manager POST:@"https://news-at.zhihu.com/api/4/news/before/20221023" parameters:self.AFNetWorkTestPOSTDictionary headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //responseObject是请求成功返回的相应结果，在AFN内部已经把相应结果转换为OC对象，通常是字典或者数组
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"POST Failed");
    }];
}

#pragma mark POST请求的数据的拼接
// -------——————————————————文件上传，参考了头像和字典的混合上传
//一 涉及到了数据的拼接，这里是ADF的提供的方法
/*
 1
  第一个参数：要上传的文件二进制数据
  第二个参数：文件参数对应的参数名称，此处为file是该台服务器规定的
  第三个参数：该文件上传到服务后以什么名称保存
  第四个参数：该文件的MIMeType类型
*/
//[formData appendPartWithFileData:data name:@"file" fileName:@"Image.png" mimeType:@"application/octet-stream"];

/*
 2
  第一个参数：要上传的文件的URL路径
  第二个参数：文件参数对应的参数名称，此处为file是该台服务器规定的
  第三个参数：该文件上传到服务后以什么名称保存
  第四个参数：该文件的MIMeType类型
  第五个参数：错误信息，传地址
 */
//[formData appendPartWithFileURL:fileUrl name:@"file" fileName:@"Image2.png" mimeType:@"application/octet-stream" error:nil];

/*
 3
  第一个参数：要上传的文件的URL路径
  第二个参数：文件参数对应的参数名称，此处为file
  第三个参数：错误信息
*/
//[formData appendPartWithFileURL:fileUrl name:@"file" error:nil];

#pragma mark POST请求方法参数理解
/***
 对参数的理解
 第一个参数：请求路径（NSString类型）
 第二个参数：非文件参数，以字典的方式传递
 第三个参数：constructingBodyWithBlock 在该回调中拼接文件参数
 第四个参数：progress 进度回调
 uploadProgress.completedUnitCount:已经上传的数据大小
 uploadProgress.totalUnitCount：数据的总大小
 第五个参数：success 请求成功的回调
 task：上传Task
 responseObject:服务器返回的响应体信息
 第六个参数：failure 请求失败的回调
 task：上传Task
 error：错误信息
 
 
 */
#pragma mark POST请求代码
- (void)upLoad {
    //创建会话管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //处理非文件的参数，模拟上传账号密码
    self.AFNetWorkTestPOSTDictionary = [[NSMutableDictionary alloc] init];
    [self.AFNetWorkTestPOSTDictionary setObject:@"Viper" forKey:@"userName"];
    [self.AFNetWorkTestPOSTDictionary setObject:@"Viper333" forKey:@"passWord"];
    //发送POST请求上传文件
    [manager POST:@"目标的URL" parameters:self.AFNetWorkTestPOSTDictionary headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 混合的数据为头像
        // 获取头像
        // 把头像转化为Data
        UIImage *image = [UIImage imageNamed:@"IMG_2400.png"];
        NSData *imageData = UIImagePNGRepresentation(image);
        //在BLOCK进行参数拼接
        //ImageUp.png是上传到服务器知乎以什么方式保存
        // 什么是MIME Type : 参考博客：https://www.cnblogs.com/jsean/articles/1610265.html
        [formData appendPartWithFileData:imageData name:@"file" fileName:@"ImageUp.png" mimeType:@"image/png"];
        //[formData appendPartWithFileURL:fileUrl name:@"file"fileName:@"Image7.png" mimeType:@"image/png" error:nil];
        //[formData appendPartWithFileURL:fileUrl name:@"file" error:nil];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //        progress 进度回调;
        //uploadProgress.completedUnitCount:已经上传的数据大小
        //uploadProgress.totalUnitCount：数据的总大小
        NSLog(@"%f", 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount);

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"POST UP Succeed!");
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"POST UP Failed");
    }];
}
@end
