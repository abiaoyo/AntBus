//
//  ILogin.h
//  OCAntBusDemo
//
//  Created by abiaoyo on 2022/4/20.
//

#ifndef ILogin_h
#define ILogin_h

@protocol ILogin <NSObject>
@property (nonatomic,copy,readonly) NSString * account;
- (void)loginWithAccount:(NSString *)account;
- (void)pushToLoginPageWithNavCtl:(UINavigationController *)navCtl;

@end


#endif /* ILogin_h */
