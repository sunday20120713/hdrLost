//
//  JJURLSchemeHandler.m
//  3DWebView
//
//  Created by luokan on 2022/1/17.
//

#import "JJURLSchemeHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>

@implementation JJURLSchemeHandler

- (void)webView:(WKWebView *)webView startURLSchemeTask:(id <WKURLSchemeTask>)urlSchemeTask{
    NSURLRequest *request = urlSchemeTask.request;
    NSString *urlStr = request.URL.absoluteString;
    
    NSLog(@"资源文件 = %@\n",urlStr);
    if ([urlStr hasPrefix:@"file://"]) {
    
    ///playcanvas
    if([urlStr containsString:@"assets"] || [urlStr containsString:@"playcanvas"]){ // 模型
        NSString *filePath = [urlStr stringByReplacingOccurrencesOfString:@"file:///" withString:@""];
        BOOL fileExist =  [[NSFileManager defaultManager] fileExistsAtPath:filePath];
        NSLog(@"3D文件是否存在：%@\n path = %@\n",fileExist?@"YES":@"NO",filePath);
        if(fileExist){
            NSData *data = [NSData dataWithContentsOfFile:filePath];
            NSString *mineType = [[self class] mimeTypeForFileAtPath:filePath];
            
            NSDictionary *headerFields = @{
                                @"Content-Type":mineType,
                                @"Content-Length":[NSString stringWithFormat:@"%ld", data.length]
                            };
            
            NSURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
            
               [urlSchemeTask didReceiveResponse:response];
               [urlSchemeTask didReceiveData:data];
               [urlSchemeTask didFinish];
        }else{
            NSError *error = [NSError new];
            [urlSchemeTask didFailWithError:error];
        }
        return;
    }
    
    NSLog(@"拦截模型: %@",urlStr);
        // scheme切换回本地文件协议file://
        NSURLRequest *fileUrlRequest = [[NSURLRequest alloc] initWithURL:request.URL cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:0];
        // 异步加载本地资源
        NSURLSession *session = [NSURLSession sharedSession];
        // 请求加载任务
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:fileUrlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
    NSLog(@"拦截：%@\n response:%@\ndata = %@\n",urlStr,response,data);
            if (error) {
                [urlSchemeTask didFailWithError:error];
            }
else {
    // 优化过的
                NSDictionary *headerFields = @{
                    @"Content-Type":[NSString stringWithString:response.MIMEType],
                    @"Content-Length":[NSString stringWithFormat:@"%ld", data.length],
@"Transfer-Encoding":@"chunked"
                };
    
//                    NSDictionary *headerFields = @{
//                        @"Content-Type":[NSString stringWithString:response.MIMEType],
//                        @"Content-Length":[NSString stringWithFormat:@"%ld", data.length]
//                    };
                response = [[NSHTTPURLResponse alloc] initWithURL:request.URL statusCode:200 HTTPVersion:@"HTTP/1.1" headerFields:headerFields];
    
                // 将数据回传给webView
                [urlSchemeTask didReceiveResponse:response];
                [urlSchemeTask didReceiveData:data];
                [urlSchemeTask didFinish];
            }
        }];
        [dataTask resume];
    }
}

- (void)webView:(WKWebView *)webView stopURLSchemeTask:(id<WKURLSchemeTask>)urlSchemeTask {
    NSLog(@"stop = %@",urlSchemeTask);
    [urlSchemeTask didFinish];
}

+ (NSString *)mimeTypeForFileAtPath:(NSString *)path
{
    if (![[[NSFileManager alloc] init] fileExistsAtPath:path]) {
    return nil;
    }
    CFStringRef UTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)[path pathExtension], NULL);
    CFStringRef MIMEType = UTTypeCopyPreferredTagWithClass (UTI, kUTTagClassMIMEType);
    CFRelease(UTI);
    if (!MIMEType) {
    return @"application/octet-stream";
    }
    return (__bridge NSString *)(MIMEType);
}

@end
