# CZBluetooth_iOS
对蓝牙的常用操作做了封装，将原生蓝牙的 delegate 回调方式改为 block。

## 1. 介绍

iOS 提供的蓝牙框架是 CoreBluetooth，消息的回调使用的是 delegate 的方式。

但 delegate 需要声明，在类中另起位置实现，也不能使用共同的局部变量，操作上没有 block 的方式那么方便。

因此本库是对 CoreBluetooth 常用方法的封装，将 delegate 的消息回调改为 block 实现。

