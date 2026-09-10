# 宽两秒

黄庭禅练习计数。纯 SwiftUI iOS。不要恢复已删的 Expo，也不要再加「观察」页或正负向心情（用户试过并删了）。

## 怎么跑

打开 `Wait2Second/Wait2Second.xcodeproj`，scheme `Wait2Second`。最低 iOS 17，控制中心要 iOS 18。远端：`git@github.com:zhiyi199501-creator/wait2second.git`（private，`master`）。

## 技术栈与目录

- 主 App：`Wait2Second/Wait2Second/`。Bundle 现为 `com.wait2second.app`（工作区已改，可能未提交）；小组件 `com.wait2second.app.widgets`
- 小组件：`Wait2Second/Wait2SecondWidgets/`
- 共用：`Wait2Second/Shared/`
- App Group：`group.com.wait2second.app`（旧组 `group.com.wait2second.native` 只为搬家保留）。键 `practice-log-v1`。
- 界面中文。只存本机。`CLAUDE.md` 只引用本文件。

## 约定（做错就会偏）

- 今日页：长按按钮约 0.4 秒 +1；长按大数字撤销今天最近一次。不能改历史日。
- 小组件 / 控制中心只有点按。锁屏小组件 +1 必须先解锁。控制中心依赖 `authenticationPolicy = .alwaysAllowed`，锁屏下拉可直接 +1（2026-09-07 真机确认）。
- 提醒锚点是上次练习。`reschedule` 会清掉后面已约的通知再排，不等于从现在重数。记一次：从这次再数一个间隔。打开 App / 改提醒：没过点则下次时间不变；已过点才从现在数。撤销：跟还剩的最后一次走，若已过点约 20 秒后再响。设置里有「下一次」。
- 设置：按钮文字、练习说明、使用帮助（`HelpView` 用户手改过，不要擅自加回删掉的问答）。
- 本月时间每行 5 个。不要擅自做 Watch、NFC、蓝牙键、上架。

## 现状

今日 / 本月、锁屏小组件、控制中心、Siri、提醒都已有。未做 Watch / TestFlight。
