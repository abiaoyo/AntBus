//
//  Page1ViewController.m
//  OCAntBusDemo
//
//  Created by abiaoyo on 2022/4/20.
//

#import "Page1ViewController.h"
#import "LoginService.h"

@import AntBus;
@interface Page1ViewController ()

@end

@implementation Page1ViewController

- (void)dealloc{
    NSLog(@"--- dealloc %@ ---",self.class);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [OCAntBus.listener listeningWithKeyPath:@"title" forObject:self handler:^(id _Nullable oldVal, id _Nullable newVal) {
        NSLog(@"title变动: oldVal=%@     newVal=%@",oldVal,newVal);
    }];
    self.title = @"Page1";
    [OCAntBus.deallocHook installDeallocHookFor:self propertyKey:@"KKK" handlerKey:@"KKKHandler" handler:^(NSSet<NSString *> * _Nonnull hks) {
            
    }];
    [OCAntBusDeallocHook.shared installDeallocHookFor:self propertyKey:@"TTT" handlerKey:@"TTTHandler" handler:^(NSSet<NSString *> * _Nonnull handleKeys) {
        
    }];
    [OCAntBus.notification registerWithKey:@"login.success" owner:self handler:^(id _Nullable data) {
        NSLog(@"OCAntBus.notification:  .login.success");
    }];
    [OCAntBus.data registerWithKey:@"user.age" owner:self handler:^id _Nullable{
        return @(1);
    }];
    [OCAntBus.notification postWithKey:@"login.success"];
    id data = [OCAntBus.data callWithKey:@"user.age"];
    NSLog(@"OCAntBus.data: %@",data);
//    [OCAntBusDeallocHook.shared uninstallDeallocHookFor:self propertyKey:@"TTT" handlerKey:@"TTTHandler"];
//    [OCAntBusDeallocHook.shared uninstallDeallocHookFor:self propertyKey:@"TTT"];
    
    LoginService * loginService = [OCAntBus.service.single responderWithClazz:LoginService.class];
    [loginService loginWithAccount:@"zhangsan"];
    
    LoginService * loginService2 = [OCAntBus.service.single responderWithInterface:@protocol(ILogin)];
    [loginService2 loginWithAccount:@"zhangsan"];
    
    [OCAntBus.channel.multi registerWithClazz:UIViewController.class key:@"Page1" responder:self];
    [OCAntBus.channel.multi registerWithClazz:UIResponder.class key:@"Page1" responder:self];
    [OCAntBus.channel.multi registerWithClazz:NSObject.class key:@"Page1" responder:self];
    
    NSArray * resps1 = [OCAntBus.channel.multi responderWithClazz:UIViewController.class key:@"Page1"];
    NSArray * resps2 =[OCAntBus.channel.multi responderWithClazz:UIViewController.class];
    
    NSLog(@"resp1: %@",resps1);
    NSLog(@"resp2: %@",resps2);
    
    NSArray * resps3 =[OCAntBus.channel.multi responderWithClazz:UIResponder.class];
    NSArray * resps4 =[OCAntBus.channel.multi responderWithClazz:NSObject.class];
    
    NSLog(@"resp3: %@",resps3);
    NSLog(@"resp4: %@",resps4);
    
    
    NSArray * resps5 = [OCAntBus.service.multi responderWithClazz:UIViewController.class];
    NSLog(@"resps5: %@",resps5);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
