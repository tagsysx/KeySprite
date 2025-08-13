import Foundation

/// 数据共享管理器
/// 用于在主应用和键盘扩展之间共享数据
class SharedDataManager {
    
    static let shared = SharedDataManager()
    
    private let userDefaults: UserDefaults
    private let appGroupIdentifier = "group.org.tagsys.KeySpirte"
    
    private init() {
        // 使用更安全的App Group检测方式，避免CFPrefs错误
        if let sharedDefaults = UserDefaults(suiteName: appGroupIdentifier) {
            self.userDefaults = sharedDefaults
            print("✅ App Group is available and working")
        } else {
            print("⚠️ App Group not available, using standard UserDefaults")
            self.userDefaults = UserDefaults.standard
        }
    }
    
    // MARK: - 用户偏好设置
    
    /// 保存用户偏好设置
    func saveUserPreference(_ value: Any, forKey key: String) {
        userDefaults.set(value, forKey: key)
        // 移除synchronize调用，避免不必要的性能开销
    }
    
    /// 获取用户偏好设置
    func getUserPreference(forKey key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
    
    /// 获取字符串类型的用户偏好设置
    func getUserPreferenceString(forKey key: String) -> String? {
        return userDefaults.string(forKey: key)
    }
    
    /// 获取布尔类型的用户偏好设置
    func getUserPreferenceBool(forKey key: String) -> Bool {
        return userDefaults.bool(forKey: key)
    }
    
    /// 获取整数类型的用户偏好设置
    func getUserPreferenceInt(forKey key: String) -> Int {
        return userDefaults.integer(forKey: key)
    }
    
    // MARK: - 键盘设置
    
    /// 保存键盘主题设置
    func saveKeyboardTheme(_ theme: String) {
        saveUserPreference(theme, forKey: "keyboard_theme")
    }
    
    /// 获取键盘主题设置
    func getKeyboardTheme() -> String {
        return getUserPreferenceString(forKey: "keyboard_theme") ?? "default"
    }
    
    /// 保存键盘布局设置
    func saveKeyboardLayout(_ layout: String) {
        saveUserPreference(layout, forKey: "keyboard_layout")
    }
    
    /// 获取键盘布局设置
    func getKeyboardLayout() -> String {
        return getUserPreferenceString(forKey: "keyboard_layout") ?? "qwerty"
    }
    
    /// 保存AI预测开关状态
    func saveAIPredictionEnabled(_ enabled: Bool) {
        saveUserPreference(enabled, forKey: "ai_prediction_enabled")
    }
    
    /// 获取AI预测开关状态
    func getAIPredictionEnabled() -> Bool {
        return getUserPreferenceBool(forKey: "ai_prediction_enabled")
    }
    
    // MARK: - 用户数据
    
    /// 保存用户输入历史
    func saveInputHistory(_ history: [String]) {
        saveUserPreference(history, forKey: "input_history")
    }
    
    /// 获取用户输入历史
    func getInputHistory() -> [String] {
        return userDefaults.stringArray(forKey: "input_history") ?? []
    }
    
    /// 添加新的输入到历史记录
    func addToInputHistory(_ input: String) {
        var history = getInputHistory()
        // 避免重复添加
        if !history.contains(input) {
            history.insert(input, at: 0)
            // 限制历史记录数量
            if history.count > 100 {
                history = Array(history.prefix(100))
            }
            saveInputHistory(history)
        }
    }
    
    // MARK: - 应用状态
    
    /// 保存应用最后活跃时间
    func saveLastActiveTime() {
        let timestamp = Date().timeIntervalSince1970
        saveUserPreference(timestamp, forKey: "last_active_time")
    }
    
    /// 获取应用最后活跃时间
    func getLastActiveTime() -> Date? {
        let timestamp = userDefaults.double(forKey: "last_active_time")
        if timestamp > 0 {
            return Date(timeIntervalSince1970: timestamp)
        }
        return nil
    }
    
    // MARK: - 清理数据
    
    /// 清理所有共享数据
    func clearAllData() {
        let domain = Bundle.main.bundleIdentifier ?? ""
        userDefaults.removePersistentDomain(forName: domain)
        // 移除synchronize调用
    }
    
    /// 清理特定类型的数据
    func clearData(forKey key: String) {
        userDefaults.removeObject(forKey: key)
        // 移除synchronize调用
    }
}

// MARK: - 扩展：便捷访问方法

extension SharedDataManager {
    
    /// 检查App Group是否可用
    var isAppGroupAvailable: Bool {
        // 简单检测：如果能创建UserDefaults实例，就认为可用
        return UserDefaults(suiteName: appGroupIdentifier) != nil
    }
    
    /// 获取App Group标识符
    var appGroupID: String {
        return appGroupIdentifier
    }
}
