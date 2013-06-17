//
//  aszViewController.m
//  ios2jsbridge
//
//  Created by alex zaikman on 6/11/13.
//  Copyright (c) 2013 alex zaikman. All rights reserved.
//

#import "aszViewController.h"
#import "aszios2js2iosBridge.h"

@interface aszViewController ()


@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,strong)  aszios2js2iosBridge *bridge;


@property (weak, nonatomic) IBOutlet UITextField *echoText;

@end

@implementation aszViewController

@synthesize webView=_webView;
@synthesize bridge=_bridge;


- (IBAction)echo:(id)sender {
    
    
}














- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.bridge = [[aszios2js2iosBridge alloc]initWithWebView:self.webView];
    
    self.webView.delegate=self.bridge;
    
    // Load the html as a string from the file system
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
    
    NSError *e;
    NSString *html = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&e];
    
    // Tell the web view to load it
    [self.webView loadHTMLString:html baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle] bundlePath]]];
    
   
}







@end









