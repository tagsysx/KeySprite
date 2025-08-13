//
//  KeyboardViewController.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import UIKit

class KeyboardViewController: UIInputViewController, KeyboardViewDelegate {

    // 移除@IBOutlet，改为普通的可选属性
    private var nextKeyboardButton: UIButton!
    
    // MARK: - Properties
    private var keyboardView: KeyboardView!
    private var aiPredictor: AIPredictor!
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("🚀 KeyboardViewController viewDidLoad called")
        print("📱 View frame: \(view.frame)")
        print("📱 View bounds: \(view.bounds)")
        print("📱 View constraints: \(view.constraints.count)")
        
        // 初始化AI预测器
        aiPredictor = AIPredictor()
        
        // 初始化共享数据管理器
        setupSharedData()
        
        // 设置键盘视图 - 移除延迟，直接设置
        setupKeyboardView()
        setupNextKeyboardButton()
        
        print("🎯 ViewDidLoad setup complete")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("📱 ViewWillAppear called")
        
        // 验证视图约束
        validateViewConstraints()
        
        // 在视图即将显示时处理nextKeyboardButton，使用安全的方法
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.updateNextKeyboardButtonVisibility()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("📱 ViewDidAppear called")
        
        // 强制更新布局，确保视图尺寸正确
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            self?.forceLayoutUpdate()
        }
        
        // 如果视图仍然没有正确的尺寸，尝试延迟处理
        if view.frame.width == 0 || view.frame.height == 0 {
            print("⚠️ View still has zero frame in viewDidAppear, scheduling delayed layout")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
                self?.handleDelayedLayout()
            }
        }
        
        // 添加额外的延迟检查，确保布局最终正确
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.finalLayoutCheck()
        }
    }
    
    private func finalLayoutCheck() {
        print("🔍 Final layout check...")
        
        if view.frame.width > 0 && view.frame.height > 0 {
            print("✅ Final check: View has proper dimensions")
            if let keyboardView = keyboardView, keyboardView.keyViews.isEmpty {
                print("🔧 Final check: Creating keyboard layout")
                keyboardView.createKeyboardLayout()
            }
        } else {
            print("⚠️ Final check: View still has invalid dimensions")
        }
    }
    
    private func forceLayoutUpdate() {
        print("🔄 Forcing layout update...")
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        // 如果键盘视图还没有正确尺寸，强制更新
        if let keyboardView = keyboardView, keyboardView.frame.width == 0 || keyboardView.frame.height == 0 {
            print("🔄 Forcing keyboard view layout update...")
            keyboardView.forceUpdate()
        }
    }
    
    private func handleDelayedLayout() {
        print("⏰ Handling delayed layout...")
        
        if view.frame.width > 0 && view.frame.height > 0 {
            print("✅ Delayed layout: View has proper dimensions now")
            if let keyboardView = keyboardView, keyboardView.keyViews.isEmpty {
                print("🔧 Delayed layout: Creating keyboard layout")
                keyboardView.createKeyboardLayout()
            }
        } else {
            print("⚠️ Delayed layout: View still has invalid dimensions")
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // 在布局完成后再次检查frame
        print("📱 ViewDidLayoutSubviews - Frame: \(view.frame)")
        print("🎹 KeyboardView frame: \(keyboardView?.frame ?? .zero)")
        
        // 如果视图有有效尺寸且键盘视图还没有布局，则创建键盘布局
        if view.frame.width > 0 && view.frame.height > 0 && keyboardView != nil {
            // 检查键盘视图是否已经有内容，避免重复创建
            if keyboardView.keyViews.isEmpty {
                print("🔧 Creating keyboard layout in viewDidLayoutSubviews")
                print("🔧 KeyboardView bounds before creation: \(keyboardView.bounds)")
                keyboardView.createKeyboardLayout()
                
                // 强制布局更新
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                    self?.keyboardView?.setNeedsLayout()
                    self?.keyboardView?.layoutIfNeeded()
                    print("🔧 Layout forced after creation")
                }
            }
        }
        
        // 验证约束
        validateViewConstraints()
    }
    
    // MARK: - Next Keyboard Button Management
    
    private func updateNextKeyboardButtonVisibility() {
        guard let nextKeyboardButton = nextKeyboardButton else {
            print("⚠️ nextKeyboardButton is nil")
            return
        }
        
        // 检查是否有父视图控制器和窗口连接
        guard parent != nil && view.window != nil else {
            print("⚠️ View controller not properly connected, setting button visible by default")
            nextKeyboardButton.isHidden = false
            return
        }
        
        // 额外等待确保连接已完全建立
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return }
            self.nextKeyboardButton.isHidden = !self.needsInputModeSwitchKey
            print("✅ needsInputModeSwitchKey called successfully: \(!self.nextKeyboardButton.isHidden)")
        }
    }
    
    private func validateViewConstraints() {
        print("🔍 Validating constraints...")
        
        if view.constraints.count < 4 {
            print("⚠️ View has insufficient constraints: \(view.constraints.count)")
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        print("📱 Transitioning to size: \(size)")
        
        coordinator.animate(alongsideTransition: { [weak self] _ in
            // 在动画期间更新布局
            self?.view.setNeedsLayout()
            self?.view.layoutIfNeeded()
        }) { [weak self] _ in
            // 动画完成后重新创建键盘布局
            self?.keyboardView?.resetLayout()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.keyboardView?.setNeedsLayout()
                self?.keyboardView?.layoutIfNeeded()
                print("🔧 Layout forced after creation")
            }
        }
    }
    
    // MARK: - Setup Methods
    
    private func setupSharedData() {
        print("🔧 Setting up shared data...")
        
        // 检查App Group是否可用
        if SharedDataManager.shared.isAppGroupAvailable {
            print("✅ App Group is available for data sharing")
        }
        
        // 设置默认偏好设置
        setupDefaultPreferences()
    }
    
    private func setupKeyboardView() {
        print("🔧 Setting up keyboard view...")
        
        keyboardView = KeyboardView()
        keyboardView.translatesAutoresizingMaskIntoConstraints = false
        keyboardView.delegate = self  // 设置delegate
        
        view.addSubview(keyboardView)
        
        // 设置约束
        NSLayoutConstraint.activate([
            keyboardView.topAnchor.constraint(equalTo: view.topAnchor),
            keyboardView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            keyboardView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        print("✅ Keyboard view setup complete")
        print("🎹 KeyboardView added to superview")
    }
    
    private func setupNextKeyboardButton() {
        // 创建 next keyboard button
        nextKeyboardButton = UIButton(type: .system)
        nextKeyboardButton.setTitle(NSLocalizedString("Next Keyboard", comment: "Title for 'Next Keyboard' button"), for: [])
        nextKeyboardButton.sizeToFit()
        nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        // 延迟调用needsInputModeSwitchKey，避免过早调用
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.updateNextKeyboardButtonVisibility()
        }
        
        // 设置外观
        if let nextKeyboardButton = nextKeyboardButton {
            let textColor = UIColor.label
            nextKeyboardButton.setTitleColor(textColor, for: [])
        }
    }
    
    private func setupDefaultPreferences() {
        print("🔧 Setting up default preferences...")
        
        // 设置默认键盘布局
        if SharedDataManager.shared.getUserPreference(forKey: "keyboard_layout") == nil {
            SharedDataManager.shared.saveUserPreference("qwerty", forKey: "keyboard_layout")
        }
        
        // 设置默认AI预测开关
        if SharedDataManager.shared.getUserPreference(forKey: "ai_prediction_enabled") == nil {
            SharedDataManager.shared.saveUserPreference(true, forKey: "ai_prediction_enabled")
        }
        
        print("✅ Default preferences setup complete")
    }
    
    deinit {
        print("🗑️ KeyboardViewController deinit")
    }
}

// MARK: - KeyboardViewDelegate
extension KeyboardViewController {
    
    func didTapKey(_ key: KeyboardKey) {
        print("🎯 Key tapped: \(key.character)")
        
        switch key.type {
        case .character:
            // 输入字符
            textDocumentProxy.insertText(key.character)
            
        case .space:
            textDocumentProxy.insertText(" ")
            
        case .backspace:
            textDocumentProxy.deleteBackward()
            
        case .return:
            textDocumentProxy.insertText("\n")
            
        case .shift:
            // 处理大小写切换
            print("🔄 Shift key pressed")
            // TODO: 实现shift功能
            
        case .layout:
            // 布局切换在 didTapLayoutButton 中处理
            break
            
        case .emoji:
            // 表情键
            textDocumentProxy.insertText(key.character)
        }
    }
    
    func didLongPressKey(_ key: KeyboardKey) {
        print("🎯 Key long pressed: \(key.character)")
        
        switch key.type {
        case .character:
            // 长按字符键可以显示特殊字符选项
            // TODO: 实现特殊字符选择器
            print("🔄 Long press character: \(key.character)")
            
        case .backspace:
            // 长按删除键删除整个单词
            if let documentContextBeforeInput = textDocumentProxy.documentContextBeforeInput {
                let words = documentContextBeforeInput.components(separatedBy: .whitespacesAndNewlines)
                if let lastWord = words.last, !lastWord.isEmpty {
                    for _ in lastWord {
                        textDocumentProxy.deleteBackward()
                    }
                }
            }
            
        default:
            break
        }
    }
    
    func didTapLayoutButton(_ layout: KeyboardLayout) {
        print("🎯 Layout button tapped: \(layout)")
        // TODO: 实现布局切换功能
        // keyboardView.updateLayout(layout)
    }
}