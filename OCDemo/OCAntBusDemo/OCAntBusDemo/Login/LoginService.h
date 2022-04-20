//
//  LoginService.h
//  OCAntBusDemo
//
//  Created by abiaoyo on 2022/4/20.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"
#import "ILogin.h"

NS_ASSUME_NONNULL_BEGIN

@interface LoginService : NSObject<ILogin>

@property (nonatomic,copy,readonly) NSString * account;

- (void)loginWithAccount:(NSString *)account;

- (void)pushToLoginPageWithNavCtl:(UINavigationController *)navCtl;

@end

NS_ASSUME_NONNULL_END
