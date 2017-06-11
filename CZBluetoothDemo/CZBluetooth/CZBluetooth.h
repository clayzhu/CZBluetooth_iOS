//
//  CZBluetooth.h
//  CZBluetoothDemo
//
//  Created by ug19 on 2017/1/16.
//  Copyright © 2017年 Ugood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface CZBluetooth : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

+ (instancetype)sharedInstance;
@property (strong, nonatomic) CBCentralManager *manager;

/** 扫描外设 */
- (void)scanForPeripherals;

#pragma mark - CBCentralManagerDelegate block
/**
 监控中心设备蓝牙状态的变化，蓝牙开启后，可以开始扫描外设

 @param block central:中心设备对象
 */
- (void)centralManagerDidUpdateStateBlock:(void (^)(CBCentralManager *central))block;
/**
 扫描到了外设，可以开始连接设备

 @param block central:中心设备对象
              peripheral:扫描到的蓝牙外设
              advertisementData:外设信息
              RSSI:信号强度，负数
 */
- (void)centralManagerDidDiscoverPeripheralBlock:(void (^)(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI))block;
/**
 连接外设成功，可以开始发现服务

 @param block central:中心设备对象
              peripheral:连接的蓝牙外设
 */
- (void)centralManagerDidConnectPeripheralBlock:(void (^)(CBCentralManager *central, CBPeripheral *peripheral))block;
/**
 连接外设失败

 @param block central:中心设备对象
              peripheral:连接失败的蓝牙外设
              error:错误信息
 */
- (void)centralManagerDidFailToConnectPeripheralBlock:(void (^)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error))block;
/**
 外设断开连接

 @param block central:中心设备对象
              peripheral:连接失败的蓝牙外设
			  error:错误信息
 */
- (void)centralManagerDidDisconnectPeripheralBlock:(void (^)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error))block;

#pragma mark - CBPeripheralDelegate block
/**
 已发现服务，可以开始发现特征

 @param block peripheral:连接的发现服务的蓝牙外设
              error:错误信息
 */
- (void)peripheralDidDiscoverServicesBlock:(void (^)(CBPeripheral *peripheral, NSError *error))block;
/**
 已发现特征

 @param block peripheral:连接的发现服务的蓝牙外设
              service:已发现的特征所在的服务
              error:错误信息
 */
- (void)peripheralDidDiscoverCharacteristicsForServiceBlock:(void (^)(CBPeripheral *peripheral, CBService *service, NSError *error))block;
/**
 获取外设发来的数据，不论是 read 和 notify，获取数据都是从这个方法中读取

 @param block peripheral:连接的发现服务的蓝牙外设
              characteristic:获取到的数据所在的特征
              error:错误信息
 */
- (void)peripheralDidUpdateValueForCharacteristicBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block;
/**
 外设通知状态的改变

 @param block peripheral:连接的发现服务的蓝牙外设
              characteristic:通知状态改变所在的特征
              error:错误信息
 */
- (void)peripheralDidUpdateNotificationStateForCharacteristicBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block;
/**
 用于检测中心向外设写数据是否成功

 @param block peripheral:连接的发现服务的蓝牙外设
              characteristic:被写数据的特征
              error:错误信息
 */
- (void)peripheralDidWriteValueForCharacteristicBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block;

@end
