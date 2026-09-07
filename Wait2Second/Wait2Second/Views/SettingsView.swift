import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(PracticeStore.self) private var store
    @State private var settings = ReminderSettingsStore.load()
    @State private var buttonTitle = DisplaySettings.loadButtonTitle()

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Text("按钮文字")
                            .foregroundStyle(Theme.ink)
                        TextField(DisplaySettings.defaultButtonTitle, text: $buttonTitle)
                            .multilineTextAlignment(.trailing)
                            .foregroundStyle(Theme.ink)
                            .onChange(of: buttonTitle) { _, newValue in
                                if newValue.count > DisplaySettings.maxButtonTitleCount {
                                    buttonTitle = String(newValue.prefix(DisplaySettings.maxButtonTitleCount))
                                }
                                store.setButtonTitle(buttonTitle)
                            }
                    }

                    NavigationLink {
                        AboutView()
                    } label: {
                        Text("练习说明")
                            .foregroundStyle(Theme.ink)
                    }

                    NavigationLink {
                        HelpView()
                    } label: {
                        Text("使用帮助")
                            .foregroundStyle(Theme.ink)
                    }
                } header: {
                    Text("练习")
                } footer: {
                    Text("按钮中间的字，最多 \(DisplaySettings.maxButtonTitleCount) 个。空着就是「\(DisplaySettings.defaultButtonTitle)」。")
                }

                Section {
                    DatePicker("开始", selection: startBinding, displayedComponents: .hourAndMinute)
                    DatePicker("结束", selection: endBinding, displayedComponents: .hourAndMinute)
                    Stepper(value: $settings.intervalMinutes, in: 15...180, step: 15) {
                        HStack {
                            Text("间隔")
                            Spacer()
                            Text(settings.intervalLabel)
                                .foregroundStyle(Theme.inkMuted)
                        }
                    }
                    HStack {
                        Text("下一次")
                            .foregroundStyle(Theme.ink)
                        Spacer()
                        Text(nextReminderText)
                            .foregroundStyle(Theme.inkMuted)
                    }
                } header: {
                    Text("提醒")
                } footer: {
                    Text("只在白天这个时段里提醒。间隔从上次练习算起。")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Theme.cloud.ignoresSafeArea())
            .tint(Theme.skyDeep)
            .navigationTitle("设置")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("完成") { dismiss() }
                        .foregroundStyle(Theme.ink)
                }
            }
            .onChange(of: settings) { _, newValue in
                ReminderSettingsStore.save(newValue)
            }
        }
    }

    private var nextReminderText: String {
        guard let date = ReminderScheduler.nextFireDate(
            last: SharedStore.lastPracticeDate(),
            settings: settings,
            appIsActive: true
        ) else {
            return "暂无"
        }
        return CalendarMath.formatNextReminder(date)
    }

    private var startBinding: Binding<Date> {
        Binding(
            get: { ClockTime.date(fromMinutes: settings.dayStartMinutes) },
            set: { settings.dayStartMinutes = ClockTime.minutes(from: $0) }
        )
    }

    private var endBinding: Binding<Date> {
        Binding(
            get: { ClockTime.date(fromMinutes: settings.dayEndMinutes) },
            set: { settings.dayEndMinutes = ClockTime.minutes(from: $0) }
        )
    }
}
