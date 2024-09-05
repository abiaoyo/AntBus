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
    
    self.title = @"AntBus";
    
    [OCAntBus.plus.container.single registerWithClazz:UIViewController.class object:self];
    [OCAntBus.plus.container.single registerWithInterface:@protocol(UIPage) object:self];
    
    [OCAntBus.plus.container.multiple registerWithClazz:UIViewController.class object:self forKey:@"UIViewController"];
    
    [OCAntBus.plus.container.single registerWithClazz:NSNumber.class object:@(100)];
    
    id n = [OCAntBus.plus.container.single objectWithClazz:NSNumber.class];
    NSLog(@"n: %@",n);
    
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
    
    
    id<SFViewPage> viewPage = [OCAntBus.plus.container.single objectWithInterface:@protocol(SFViewPage)];
    NSLog(@"viewPage=%@",viewPage);
    
    ViewController2 * vctl = [OCAntBus.plus.container.single objectWithClazz:ViewController2.class];
    NSLog(@"vctl=%@",vctl);
    
    [[OCAntBus.service.single responder:@protocol(ILogin)] pushToLoginPageWithNavCtl:self.navigationController];
}

@end
