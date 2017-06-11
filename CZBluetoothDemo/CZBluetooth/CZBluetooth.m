//
//  CZBluetooth.m
//  CZBluetoothDemo
//
//  Created by ug19 on 2017/1/16.
//  Copyright © 2017年 Ugood. All rights reserved.
//

#import "CZBluetooth.h"

@interface CZBluetooth ()
// CBCentralManagerDelegate block
@property (copy, nonatomic) void (^centralManagerDidUpdateStateBlock)(CBCentralManager *central);
@property (copy, nonatomic) void (^centralManagerDidDiscoverPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI);
@property (copy, nonatomic) void (^centralManagerDidConnectPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral);
@property (copy, nonatomic) void (^centralManagerDidFailToConnectPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error);
@property (copy, nonatomic) void (^centralManagerDidDisconnectPeripheralBlock)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error);

// CBPeripheralDelegate block
@property (copy, nonatomic) void (^peripheralDidDiscoverServicesBlock)(CBPeripheral *peripheral, NSError *error);
@property (copy, nonatomic) void (^peripheralDidDiscoverCharacteristicsForServiceBlock)(CBPeripheral *peripheral, CBService *service, NSError *error);
@property (copy, nonatomic) void (^peripheralDidUpdateValueForCharacteristicBlock)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error);
@property (copy, nonatomic) void (^peripheralDidUpdateNotificationStateForCharacteristicBlock)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error);
@property (copy, nonatomic) void (^peripheralDidWriteValueForCharacteristicBlock)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error);

@end

@implementation CZBluetooth

+ (instancetype)sharedInstance {
	static CZBluetooth *sharedInstance;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sharedInstance = [[CZBluetooth alloc] init];
	});
	return sharedInstance;
}

- (instancetype)init {
	self = [super init];
	if (self) {
		_manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
	}
	return self;
}

- (void)scanForPeripherals {
	NSLog(@"正在扫描外设...");
	NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
	[_manager scanForPeripheralsWithServices:nil options:options];
}

#pragma mark - CBCentralManagerDelegate block
- (void)centralManagerDidUpdateStateBlock:(void (^)(CBCentralManager *))block {
	if (block) {
		_centralManagerDidUpdateStateBlock = block;
	}
}

- (void)centralManagerDidDiscoverPeripheralBlock:(void (^)(CBCentralManager *, CBPeripheral *, NSDictionary *, NSNumber *))block {
	if (block) {
		_centralManagerDidDiscoverPeripheralBlock = block;
	}
}

- (void)centralManagerDidConnectPeripheralBlock:(void (^)(CBCentralManager *, CBPeripheral *))block {
	if (block) {
		_centralManagerDidConnectPeripheralBlock = block;
	}
}

- (void)centralManagerDidFailToConnectPeripheralBlock:(void (^)(CBCentralManager *central, CBPeripheral *peripheral, NSError *error))block {
	if (block) {
		_centralManagerDidFailToConnectPeripheralBlock = block;
	}
}

- (void)centralManagerDidDisconnectPeripheralBlock:(void (^)(CBCentralManager *, CBPeripheral *, NSError *))block {
	if (block) {
		_centralManagerDidDisconnectPeripheralBlock = block;
	}
}

#pragma mark - CBPeripheralDelegate block
- (void)peripheralDidDiscoverServicesBlock:(void (^)(CBPeripheral *peripheral, NSError *error))block {
	if (block) {
		_peripheralDidDiscoverServicesBlock = block;
	}
}

- (void)peripheralDidDiscoverCharacteristicsForServiceBlock:(void (^)(CBPeripheral *peripheral, CBService *service, NSError *error))block {
	if (block) {
		_peripheralDidDiscoverCharacteristicsForServiceBlock = block;
	}
}

- (void)peripheralDidUpdateValueForCharacteristicBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block {
	if (block) {
		_peripheralDidUpdateValueForCharacteristicBlock = block;
	}
}

- (void)peripheralDidUpdateNotificationStateForCharacteristicBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block {
	if (block) {
		_peripheralDidUpdateNotificationStateForCharacteristicBlock = block;
	}
}

- (void)peripheralDidWriteValueForCharacteristicBlock:(void (^)(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error))block {
	if (block) {
		_peripheralDidWriteValueForCharacteristicBlock = block;
	}
}

#pragma mark - CBCentralManagerDelegate
// 监控中心设备蓝牙状态的变化，蓝牙开启后，可以开始扫描外设
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
	if (_centralManagerDidUpdateStateBlock) {
		_centralManagerDidUpdateStateBlock(central);
	}
}

// 扫描到了外设，可以开始连接设备
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
	NSLog(@"%@", [NSString stringWithFormat:@"已发现 peripheral name:%@ rssi:%@, advertisementData:%@", peripheral.name, RSSI, advertisementData]);
	if (_centralManagerDidDiscoverPeripheralBlock) {
		_centralManagerDidDiscoverPeripheralBlock(central, peripheral, advertisementData, RSSI);
	}
}

// 连接外设成功，可以开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
	NSLog(@"%@", [NSString stringWithFormat:@"成功连接 peripheral name:%@", peripheral.name]);
	if (_centralManagerDidConnectPeripheralBlock) {
		_centralManagerDidConnectPeripheralBlock(central, peripheral);
	}
}

// 连接外设失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	NSLog(@"连接外设失败 error:%@", error);
	if (_centralManagerDidFailToConnectPeripheralBlock) {
		_centralManagerDidFailToConnectPeripheralBlock(central, peripheral, error);
	}
}

// 外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
	NSLog(@"外设断开连接 error:%@", error);
	if (_centralManagerDidDisconnectPeripheralBlock) {
		_centralManagerDidDisconnectPeripheralBlock(central, peripheral, error);
	}
}

#pragma mark - CBPeripheralDelegate
// 已发现服务，可以开始发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
	NSLog(@"发现服务的外设:%@", peripheral.name);
	if (_peripheralDidDiscoverServicesBlock) {
		_peripheralDidDiscoverServicesBlock(peripheral, error);
	}
}

// 已发现特征
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
	NSLog(@"%@", [NSString stringWithFormat:@"发现特征的服务:%@ (%@)", service.UUID.data, service.UUID]);
	if (_peripheralDidDiscoverCharacteristicsForServiceBlock) {
		_peripheralDidDiscoverCharacteristicsForServiceBlock(peripheral, service, error);
	}
}

// 获取外设发来的数据，不论是 read 和 notify，获取数据都是从这个方法中读取
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	if (_peripheralDidUpdateValueForCharacteristicBlock) {
		_peripheralDidUpdateValueForCharacteristicBlock(peripheral, characteristic, error);
	}
}

// 外设通知状态的改变
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
	if (_peripheralDidUpdateNotificationStateForCharacteristicBlock) {
		_peripheralDidUpdateNotificationStateForCharacteristicBlock(peripheral, characteristic, error);
	}
}

// 用于检测中心向外设写数据是否成功
- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
	if (_peripheralDidWriteValueForCharacteristicBlock) {
		_peripheralDidWriteValueForCharacteristicBlock(peripheral, characteristic, error);
	}
}

@end
