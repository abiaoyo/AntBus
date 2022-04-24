//
//  ViewController.m
//  OCAntBusDemo
//
//  Created by abiaoyo on 2022/4/20.
//

#import "ViewController.h"
#import "Page1ViewController.h"
#import "Login/LoginService.h"
#import "OCAntBusDemo-Swift.h"

@import AntBus;


@protocol UIPage <NSObject>

- (NSString *)title;

@end

@interface ViewController ()<UIPage>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"OCAntBusChannel";
    
    LoginService * loginService = [[LoginService alloc] init];
    
    [OCAntBusService.single registerWithInterface:@protocol(ILogin) responder:loginService];
    [OCAntBusService.single registerWithInterface:@protocol(ILogin) responder:loginService];
    
    [OCAntBusService.single registerWithClazz:LoginService.class responder:loginService];
    
    [OCAntBusChannel.single registerWithClazz:UIViewController.class responder:self];
    [OCAntBusChannel.single registerWithInterface:@protocol(UIPage) responder:self];
    [OCAntBusChannel.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
    [OCAntBusChannel.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
    
    
    
    
    [OCAntBusService.single registerWithClazz:NSNumber.class responder:@(100)];
    id n = [OCAntBusService.single responderWithClazz:NSNumber.class];
    NSLog(@"n: %@",n);
    
    
    
    [OCAntBusService.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
    [OCAntBusService.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
}

- (IBAction)clickButton1:(id)sender {
    Page1ViewController * vctl = [[Page1ViewController alloc] init];
    [self.navigationController pushViewController:vctl animated:YES];
}
- (IBAction)clickButton2:(id)sender {
    Page2ViewController * vctl = [[Page2ViewController alloc] init];
    [self.navigationController pushViewController:vctl animated:YES];
}
- (IBAction)clickButton3:(id)sender {
    id<SFViewPage> viewPage = [OCAntBusService.single responderWithInterface:@protocol(SFViewPage)];
    NSLog(@"viewPage=%@",viewPage);
    
    ViewController2 * vctl = [OCAntBusService.single responderWithClazz:ViewController2.class];
    NSLog(@"vctl=%@",vctl);
    
    [[OCAntBusService.single responderWithInterface:@protocol(ILogin)] pushToLoginPageWithNavCtl:self.navigationController];
}

@end
