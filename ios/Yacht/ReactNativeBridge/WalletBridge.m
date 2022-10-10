//
//  WalletBridge.m
//  Yacht
//
//  Created by Henry Minden on 10/6/22.
//

#import <Foundation/Foundation.h>
#import "React/RCTBridgeModule.h"
#import "React/RCTEventEmitter.h"

@interface RCT_EXTERN_MODULE(WalletBridge, RCTEventEmitter)

RCT_EXTERN_METHOD(returnLedgerAccount:(NSDictionary*)account)
RCT_EXTERN_METHOD(returnLedgerDevice:(NSDictionary*)device)
RCT_EXTERN_METHOD(returnComponentLoaded)
RCT_EXTERN_METHOD(sendDeviceId)

@end
