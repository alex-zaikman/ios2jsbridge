//
//  aszios2js2iosBridge.m
//  ios2jsbridge
//
//  Created by alex zaikman on 6/12/13.
//  Copyright (c) 2013 alex zaikman. All rights reserved.
//

#import "aszios2js2iosBridge.h"

@interface aszios2js2iosBridge ()

@property (nonatomic,weak) UIWebView *webView;

-(void)registerIosFunctions;


@end


@implementation aszios2js2iosBridge

@synthesize webView=_webView;



/*injects js function with the name <functionName> into the current context loadded in the webView */
-(void)registerFunctionWithName:(NSString*)functionName{
    
    NSMutableString *command = [[NSMutableString alloc]init];
    
    [command appendString:@"var " ];
    
    [command appendString:functionName];
    
    [command appendString:@" = function(){  var iframe = document.createElement('IFRAME');     iframe.setAttribute('src', 'js-call:"];
    
    [command appendString:functionName];
    
    [command appendString:@"');     document.documentElement.appendChild(iframe);     iframe.parentNode.removeChild(iframe);     iframe = null; }"];
    
    [self.webView stringByEvaluatingJavaScriptFromString:command];
    
}

/*call js function from curently loadded context of the webView with optional(can be nil) params and call backs  !mined the order*/
-(void)exec:(NSString*)jsFunction withParams:(NSArray*)params onSuccessCall:(void (^)(NSString *)) success onFailureCall:(void (^)(NSString*)) faliure{
    
    NSMutableString *command=[[NSMutableString alloc]init];
    
    
    [command appendString:@"var result; "];
    
    [command appendString:@"var success = function(ret){result= 'successWith-'.concat(ret);}; "];
    
    [command appendString:@"var failed = function(ret){result= 'failedWith-'.concat(ret);}; "];
    
    [command appendString:jsFunction];
    [command appendString:@"( "];
    
    for(NSString* param in params){
        [command appendString:@"'"];
        [command appendString:param];
        [command appendString:@"' , "];
    }
    
    [command appendString:@" success , failed);  "];
    
    [command appendString:@"var returnHook=function(){return result }; "];
    
    [command appendString:@"returnHook();  "];
    
    NSString *ret=  [self.webView stringByEvaluatingJavaScriptFromString:command];
    
    if([ret hasPrefix:@"successWith-"]){
        
        if(success==nil)return;
        
        NSRange range = [ret rangeOfString:@"successWith-"];
        success([ret substringFromIndex:range.length]);
    }else{
        
        if(faliure==nil)return;
        
        NSRange range = [ret rangeOfString:@"failedWith-"];
        faliure([ret substringFromIndex:range.length]);
    }
    
    
    
    
}


-(void)functionInjectionTest{
    
    NSLog(@"%@",@"AOK");
    
}




//registering default function here....
//overide and call
-(void)registerIosFunctions{
    
    [self registerFunctionWithName:@"functionInjectionTest"];
    
}

-(id)initWithWebView:(UIWebView*) webVuew{
    if(self = [super init]){
        _webView = webVuew;
    }
    return self;
}



/*may be overidded but must be called at the end*/
- (BOOL)webView:(UIWebView *)webView2
shouldStartLoadWithRequest:(NSURLRequest *)request
 navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString  *requestString=[[request URL] absoluteString];
    // Intercept custom location change, URL begins with "js-call:"
    if ([requestString hasPrefix:@"js-call:"]) {
        
        // Extract the selector name from the URL
        NSArray *components = [requestString componentsSeparatedByString:@":"];
        NSString *function = [components objectAtIndex:1];
        
        // Call the given selector
        id result = [self performSelector:NSSelectorFromString(function)];
        
        // Cancel the location change
        return NO;
    }
    
    // Accept this location change
    return YES;
    
}



@end
