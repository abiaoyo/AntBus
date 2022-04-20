//
//  LoginService.m
//  OCAntBusDemo
//
//  Created by abiaoyo on 2022/4/20.
//

#import "LoginService.h"

@implementation LoginService

- (void)loginWithAccount:(NSString *)account{
    _account = account;
    
    NSLog(@"LoginService.loginWithAccount: %@",account);
}

- (void)pushToLoginPageWithNavCtl:(UINavigationController *)navCtl{
    LoginViewController * vctl = [[LoginViewController alloc] init];
    vctl.title = @"Login";
    [navCtl pushViewController:vctl animated:YES];
}

@end
