//
//  ViewController.m
//  OCAntBusDemo
//
//  Created by abiaoyo on 2022/4/20.
//

#import "ViewController.h"
#import "Page1ViewController.h"
#import "Login/LoginService.h"

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
    [OCAntBusService.single registerWithClazz:LoginService.class responder:loginService];
    
    [OCAntBusChannel.single registerWithClazz:UIViewController.class responder:self];
    [OCAntBusChannel.single registerWithInterface:@protocol(UIPage) responder:self];
    [OCAntBusChannel.multi registerWithClazz:UIViewController.class key:@"ViewController" responder:self];
}

- (IBAction)clickButton1:(id)sender {
    Page1ViewController * vctl = [[Page1ViewController alloc] init];
    [self.navigationController pushViewController:vctl animated:YES];
}

@end
