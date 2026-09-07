# 宽两秒

黄庭禅练习计数。纯 SwiftUI iOS，不是 Expo / React Native。不要恢复已删的 Expo 工程。

## 怎么跑

打开 `Wait2Second/Wait2Second.xcodeproj`，真机或模拟器跑 scheme `Wait2Second`。最低 iOS 17。控制中心控件要 iOS 18。

## 技术栈与目录

- 主 App：`Wait2Second/Wait2Second/`（Bundle `com.wait2second.native`）
- 锁屏小组件 + 控制中心：`Wait2Second/Wait2SecondWidgets/`
- 共用：`Wait2Second/Shared/`（次数、提醒、`IncrementPracticeIntent`）
- App Group：`group.com.wait2second.native`，键 `practice-log-v1`
- 界面中文。只存本机。

## 约定（做错就会偏）

- App 里记一次、撤销都是长按约 0.4 秒。今日页长按大数字 = 撤销今天最近一次。不能改历史日。
- 小组件 / 控制中心只有点按，不能做成长按。锁屏小组件点 +1 必须先解锁（系统规则）。控制中心依赖 `authenticationPolicy = .alwaysAllowed`，锁屏下拉可直接 +1（2026-09-07 真机确认）。不要改回要解锁。
- 提醒从上次练习起算，一次最多预约为 10 条。15 分钟间隔且不打开、不加一，会连着弹多条。打开 App、+1、撤销、改设置才会清掉重排。人在前台不盖横幅；过期不补弹。
- 不要擅自做 Apple Watch、NFC、蓝牙键、上架。用户没要求就不要加功能。

## 现状

锁屏小组件、控制中心、Siri「记一次宽两秒」、白天时段 + 间隔提醒都已有。未做 Watch / TestFlight。
