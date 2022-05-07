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
    
    
    [OCAntBus.service.single registerWithInterface:@protocol(ILogin) responder:loginService];
    [OCAntBus.service.single registerWithInterface:@protocol(ILogin) responder:loginService];
    
    [OCAntBus.service.single registerWithClazz:LoginService.class responder:loginService];
    
    [OCAntBus.channel.single registerWithClazz:UIViewController.class responder:self];
    [OCAntBus.channel.single registerWithInterface:@protocol(UIPage) responder:self];
    [OCAntBus.channel.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
    [OCAntBus.channel.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
    
    [OCAntBus.channel.single registerWithClazz:UIViewController.class responder:self];
    
    
    [OCAntBus.service.single registerWithClazz:NSNumber.class responder:@(100)];
    id n = [OCAntBus.service.single responderWithClazz:NSNumber.class];
    NSLog(@"n: %@",n);
    
    
    
    [OCAntBus.service.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
    [OCAntBus.service.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
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
    id<SFViewPage> viewPage = [OCAntBus.service.single responderWithInterface:@protocol(SFViewPage)];
    NSLog(@"viewPage=%@",viewPage);
    
    ViewController2 * vctl = [OCAntBus.service.single responderWithClazz:ViewController2.class];
    NSLog(@"vctl=%@",vctl);
    
    [[OCAntBus.service.single responderWithInterface:@protocol(ILogin)] pushToLoginPageWithNavCtl:self.navigationController];
}

@end
