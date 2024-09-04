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
    
    [OCAntBus.plus.kvo addWithKeyPath:@"title" forObject:self handler:^(id _Nullable oldVal, id _Nullable newVal) {
        NSLog(@"title变动: oldVal=%@     newVal=%@",oldVal,newVal);
    }];
    self.title = @"Page1";
    
    [OCAntBus.plus.deallocHook installFor:self propertyKey:@"KKK" handlerKey:@"KKKHandler" handler:^(NSSet<NSString *> * _Nonnull hks) {
            
    }];
    [OCAntBus.plus.notification registerWithKey:@"login.success" owner:self handler:^(id _Nullable data) {
        NSLog(@"OCAntBus.notification:  .login.success");
    }];
    
    [OCAntBus.plus.data registerWithKey:@"user.age" owner:self handler:^id _Nullable{
        return @(1);
    }];
    [OCAntBus.plus.notification postWithKey:@"login.success"];
    id data = [OCAntBus.plus.data callWithKey:@"user.age"];
    NSLog(@"OCAntBus.data: %@",data);
//    [OCAntBusDeallocHook.shared uninstallDeallocHookFor:self propertyKey:@"TTT" handlerKey:@"TTTHandler"];
//    [OCAntBusDeallocHook.shared uninstallDeallocHookFor:self propertyKey:@"TTT"];
    
    id<ILogin> loginService = [OCAntBus.service.single responder:@protocol(ILogin)];
    
    [loginService loginWithAccount:@"zhangsan"];
    
    [OCAntBus.plus.container.multiple registerWithClazz:UIViewController.class object:self forKey:@"Page1"];
    [OCAntBus.plus.container.multiple registerWithClazz:UIResponder.class object:self forKey:@"Page1"];
    [OCAntBus.plus.container.multiple registerWithClazz:NSObject.class object:self forKey:@"Page1"];
    
    NSArray * resps1 = [OCAntBus.plus.container.multiple objectsWithClazz:UIViewController.class forKey:@"Page1"];
    NSArray * resps2 = [OCAntBus.plus.container.multiple objectsWithClazz:UIViewController.class];
    
    NSLog(@"resp1: %@",resps1);
    NSLog(@"resp2: %@",resps2);
    
    NSArray * resps3 = [OCAntBus.plus.container.multiple objectsWithClazz:UIResponder.class];
    NSArray * resps4 = [OCAntBus.plus.container.multiple objectsWithClazz:NSObject.class];
    
    NSLog(@"resp3: %@",resps3);
    NSLog(@"resp4: %@",resps4);
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
