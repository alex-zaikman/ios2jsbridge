//
//  aszios2js2iosBridge.h
//  ios2jsbridge
//
//  Created by alex zaikman on 6/12/13.
//  Copyright (c) 2013 alex zaikman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface aszios2js2iosBridge : NSObject <UIWebViewDelegate>


-(id)initWithWebView:(UIWebView*) webVuew;

-(void)exec:(NSString*)jsFunction withParams:(NSArray*)params onSuccessCall:(void (^)(NSString *)) success onFailureCall:(void (^)(NSString*)) faliure;

-(void)registerFunctionWithName:(NSString*)functionName;

-(void)registerIosFunctions;

@end
