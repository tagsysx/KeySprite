//
//  KeyboardView.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import UIKit
import ObjectiveC

private struct AssociatedKeys {
    static var lastBounds = "lastBounds"
}

protocol KeyboardViewDelegate: AnyObject {
    func didTapKey(_ key: KeyboardKey)
    func didLongPressKey(_ key: KeyboardKey)
    func didTapLayoutButton(_ layout: KeyboardLayout)
}

class KeyboardView: UIView {
    
    // MARK: - Properties
    weak var delegate: KeyboardViewDelegate?
    private var currentLayout: KeyboardLayout = .qwerty
    var keyViews: [[KeyboardKeyView]] = []  // 改为internal访问级别
    private var t9InputEngine: T9InputEngine?
    private var isLayoutCreated = false  // 添加标志防止重复创建布局
    
    // MARK: - UI Components
    private let stackView = UIStackView()
    private let backgroundView = UIView()
    private let titleLabel = UILabel()
    private let layoutButtonsStackView = UIStackView()
    
    // MARK: - Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - Setup
    private func setupUI() {
        print("🎹 KeyboardView setupUI called")
        
        backgroundColor = UIColor.systemBackground
        
        // 设置背景
        backgroundView.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        // 设置标题标签（隐藏以节省空间）
        titleLabel.text = "KeySprite"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        titleLabel.textColor = UIColor.systemBlue
        titleLabel.backgroundColor = UIColor.systemBlue.withAlphaComponent(0.2)
        titleLabel.layer.cornerRadius = 8
        titleLabel.layer.masksToBounds = true
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.isHidden = true  // 隐藏标题以节省空间
        addSubview(titleLabel)
        
        
        // 设置主堆栈视图
        stackView.axis = .vertical
        stackView.distribution = .fillEqually  // 改为fillEqually，确保行高度一致
        stackView.spacing = 4  // 减少行间距以压缩空白
        stackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView)
        
        // 设置布局按钮
        setupLayoutButtons()
        
        // 设置约束，使用优先级处理零宽度情况
        let stackViewLeadingConstraint = stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        let stackViewTrailingConstraint = stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)

        let layoutButtonsLeadingConstraint = layoutButtonsStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8)
        let layoutButtonsTrailingConstraint = layoutButtonsStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        
        // 降低水平约束的优先级以避免零宽度冲突
        stackViewLeadingConstraint.priority = .defaultHigh
        stackViewTrailingConstraint.priority = .defaultHigh

        layoutButtonsLeadingConstraint.priority = .defaultHigh
        layoutButtonsTrailingConstraint.priority = .defaultHigh
        
        // 创建约束并设置优先级
        let titleLabelHeightConstraint = titleLabel.heightAnchor.constraint(equalToConstant: 30)

        let layoutButtonsHeightConstraint = layoutButtonsStackView.heightAnchor.constraint(equalToConstant: 40)
        let layoutButtonsBottomConstraint = layoutButtonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4)  // 减少底部间距
        
        // 设置合理的约束优先级 - 这些是必需的高度
        titleLabelHeightConstraint.priority = .required

        layoutButtonsHeightConstraint.priority = .required
        layoutButtonsBottomConstraint.priority = .required
        
        // 创建stackView约束
        let stackViewBottomConstraint = stackView.bottomAnchor.constraint(lessThanOrEqualTo: layoutButtonsStackView.topAnchor, constant: -2)  // 进一步减少间距
        stackViewBottomConstraint.priority = .defaultHigh
        
        // 为stackView设置合理的最小高度
        let stackViewMinHeightConstraint = stackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160)  // 4行×40pt
        stackViewMinHeightConstraint.priority = .defaultHigh  // 降低优先级
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.widthAnchor.constraint(equalToConstant: 100),
            titleLabelHeightConstraint,
            
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 4),  // 直接从顶部开始
            stackViewLeadingConstraint,
            stackViewTrailingConstraint,
            
            layoutButtonsLeadingConstraint,
            layoutButtonsTrailingConstraint,
            layoutButtonsBottomConstraint,
            layoutButtonsHeightConstraint,
            
            // stackView约束
            stackViewBottomConstraint,
            stackViewMinHeightConstraint
        ])
        
        // 添加最小宽度约束作为备选
        let minWidthConstraint = stackView.widthAnchor.constraint(greaterThanOrEqualToConstant: 200)
        minWidthConstraint.priority = .defaultLow
        minWidthConstraint.isActive = true
        
        // 设置内容压缩和内容拥抱优先级
        stackView.setContentHuggingPriority(.defaultLow, for: .vertical)
        stackView.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        
        // 设置键盘视图的动态高度约束
        let minHeightConstraint = heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
        minHeightConstraint.priority = .defaultHigh  // 降低优先级
        minHeightConstraint.isActive = true
        
        // 验证约束设置
        validateConstraints()
        
        print("✅ Keyboard view setup complete")
    }
    
    // MARK: - Layout Buttons Setup
    private func setupLayoutButtons() {
        layoutButtonsStackView.axis = .horizontal
        layoutButtonsStackView.distribution = .fillEqually
        layoutButtonsStackView.spacing = 3  // 减少布局按钮间距
        layoutButtonsStackView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(layoutButtonsStackView)
        
        let layouts: [(KeyboardLayout, String)] = [
            (.qwerty, "QWERTY"),
            (.chinese, "Chinese"),  // 改为英文
            (.number, "Numbers"),   // 改为英文
            (.symbol, "Symbols"),   // 改为英文
            (.emoji, "Emoji")       // 改为英文
        ]
        
        for (index, (layout, title)) in layouts.enumerated() {
            let button = createLayoutButton(title: title, layout: layout, index: index)
            layoutButtonsStackView.addArrangedSubview(button)
        }
    }
    
    private func createLayoutButton(title: String, layout: KeyboardLayout, index: Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        button.backgroundColor = layout == currentLayout ? UIColor.systemBlue : UIColor.systemGray4
        button.setTitleColor(layout == currentLayout ? UIColor.white : UIColor.systemGray, for: .normal)
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.tag = index
        
        button.addTarget(self, action: #selector(layoutButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }
    
    @objc private func layoutButtonTapped(_ sender: UIButton) {
        let layouts: [KeyboardLayout] = [.qwerty, .chinese, .number, .symbol, .emoji]
        guard sender.tag < layouts.count else { return }
        
        let layout = layouts[sender.tag]
        updateLayout(layout)
        updateLayoutButtonStates()
        delegate?.didTapLayoutButton(layout)
    }
    
    private func updateLayoutButtonStates() {
        let layouts: [KeyboardLayout] = [.qwerty, .chinese, .number, .symbol, .emoji]
        
        for case let button as UIButton in layoutButtonsStackView.arrangedSubviews {
            guard button.tag < layouts.count else { continue }
            let layout = layouts[button.tag]
            let isSelected = layout == currentLayout
            
            button.backgroundColor = isSelected ? UIColor.systemBlue : UIColor.systemGray4
            button.setTitleColor(isSelected ? UIColor.white : UIColor.systemGray, for: .normal)
        }
    }
    
    // MARK: - Layout Creation
    func createKeyboardLayout() {  // 改为internal访问级别
        // 防止重复创建布局
        guard !isLayoutCreated else {
            print("⚠️ Keyboard layout already created, skipping...")
            return
        }
        
        // 检查视图尺寸是否有效，允许父视图有零高度但要有宽度
        guard bounds.width > 0 else {
            print("⚠️ Invalid bounds for layout creation (no width): \(bounds), delaying layout...")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                self?.createKeyboardLayout()
            }
            return
        }
        
        // 如果高度为0，仍然尝试创建布局，但发出警告
        if bounds.height == 0 {
            print("⚠️ Warning: Parent view has zero height, layout may be compressed")
            if let superview = superview {
                print("⚠️ Parent view info: frame=\(superview.frame), bounds=\(superview.bounds)")
            }
        }
        
        print("🎯 Creating keyboard layout for: \(currentLayout)")
        print("🎯 Current bounds: \(bounds)")
        print("🎯 Current frame: \(frame)")
        
        // 调试约束状态
        debugConstraintState()
        
        // 清除现有布局
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        keyViews.removeAll()
        
        let layoutSpec = getLayoutSpec(for: currentLayout)
        print("📐 Layout spec: \(layoutSpec.rows) rows, keys per row: \(layoutSpec.keysPerRow)")
        
        // 初始化T9输入引擎（如果是中文布局）
        if currentLayout == .chinese {
            t9InputEngine = T9InputEngine()
        } else {
            t9InputEngine = nil
        }
        
        for rowIndex in 0..<layoutSpec.rows {
            let rowStackView = UIStackView()
            rowStackView.axis = .horizontal
            rowStackView.distribution = .fillEqually
            rowStackView.spacing = 3  // 减少按键间距以压缩空白
            rowStackView.translatesAutoresizingMaskIntoConstraints = false
            
            var rowKeyViews: [KeyboardKeyView] = []
            
            for keyIndex in 0..<layoutSpec.keysPerRow[rowIndex] {
                let keySpec = layoutSpec.layout[rowIndex][keyIndex]
                let keyView = createKeyView(for: keySpec, row: rowIndex, index: keyIndex)
                rowKeyViews.append(keyView)
                rowStackView.addArrangedSubview(keyView)
            }
            
            keyViews.append(rowKeyViews)
            stackView.addArrangedSubview(rowStackView)
        }
        
        // 更新布局按钮状态
        updateLayoutButtonStates()
        
        // 标记布局已创建
        isLayoutCreated = true
        
        print("✅ Keyboard layout created with \(keyViews.count) rows")
        print("✅ Final bounds: \(bounds)")
        print("✅ Final frame: \(frame)")
    }
    
    private func createKeyView(for keySpec: String, row: Int, index: Int) -> KeyboardKeyView {
        let keyType = determineKeyType(from: keySpec)
        let key = KeyboardKey(character: keySpec, type: keyType)
        
        let keyView = KeyboardKeyView(key: key)
        keyView.delegate = self
        
        // 设置特殊按键的宽度和样式
        if currentLayout == .chinese {
            // T9键盘的特殊处理 - 为数字键设置对应的字母子标签
            let layoutSpec = getLayoutSpec(for: currentLayout) as! ChineseLayoutSpec
            if let letterMapping = layoutSpec.t9LetterMapping[keySpec] {
                keyView.setT9SubLabel(letterMapping)
            }
        } else {
            // 其他布局的默认处理
            if keyType == .space {
                keyView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            } else if keyType == .return || keyType == .backspace {
                keyView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
            }
        }
        
        return keyView
    }
    
    private func determineKeyType(from keySpec: String) -> KeyType {
        if currentLayout == .chinese {
            // T9键盘的特殊按键类型
            switch keySpec {
            case "Delete":
                return .backspace
            case "0":
                return .space
            case "Confirm":
                return .return
            case "Candidates":
                return .layout
            case "1", "2", "3", "4", "5", "6", "7", "8", "9", "*", "#":
                return .character
            default:
                return .character
            }
        } else {
            // 其他布局的默认处理
            switch keySpec {
            case "⌫":
                return .backspace
            case "Space":
                return .space
            case "Return", "↵":
                return .return
            case "⇧":
                return .shift
            case "123", "ABC", "🌐", "😀", "Symbols":
                return .layout
            default:
                return .character
            }
        }
    }
    
    // MARK: - Layout Update
    func updateLayout(_ layout: KeyboardLayout) {
        currentLayout = layout
        isLayoutCreated = false  // 重置标志，允许重新创建布局
        createKeyboardLayout()
    }
    
    func resetLayout() {
        isLayoutCreated = false
        keyViews.removeAll()
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
    
    func forceUpdate() {
        print("🔄 Forcing KeyboardView update...")
        setNeedsLayout()
        layoutIfNeeded()
        
        // 如果布局还没有创建，创建它
        if !isLayoutCreated && bounds.width > 0 && bounds.height > 0 {
            createKeyboardLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 确保在尺寸变化时重新计算布局，但只在必要时
        if bounds.width > 0 && bounds.height > 0 && keyViews.isEmpty && !isLayoutCreated {
            print("🔧 LayoutSubviews: Creating keyboard layout due to size change")
            DispatchQueue.main.async { [weak self] in
                self?.createKeyboardLayout()
            }
        }
        
        // 检查尺寸变化
        if let lastBounds = objc_getAssociatedObject(self, &AssociatedKeys.lastBounds) as? CGRect {
            let sizeChange = abs(bounds.width - lastBounds.width) + abs(bounds.height - lastBounds.height)
            if sizeChange > 50 {
                print("🔄 Significant size change detected: \(sizeChange)")
                handleSignificantSizeChange()
            }
        }
        
        // 保存当前bounds
        objc_setAssociatedObject(self, &AssociatedKeys.lastBounds, bounds, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    private func handleSignificantSizeChange() {
        print("🔄 Handling significant size change...")
        
        // 如果尺寸变化很大，可能需要重新创建布局
        if bounds.width > 0 && bounds.height > 0 && !keyViews.isEmpty {
            print("🔄 Recreating layout due to significant size change")
            isLayoutCreated = false
            createKeyboardLayout()
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // 当特征集合改变时（如深色模式切换），重新创建布局
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            print("🎨 Color appearance changed, updating layout")
            DispatchQueue.main.async { [weak self] in
                self?.updateLayoutAppearance()
            }
        }
    }
    
    private func updateLayoutAppearance() {
        // 更新按键的外观以匹配新的特征集合
        for rowKeyViews in keyViews {
            for keyView in rowKeyViews {
                keyView.updateAppearance()
            }
        }
    }
    
    // MARK: - Intrinsic Content Size
    override var intrinsicContentSize: CGSize {
        // 动态计算键盘所需的高度，而不是固定值
        let topMargin: CGFloat = 4  // 顶部间距
        let buttonRowsHeight: CGFloat = 4 * 40 + 3 * 4  // 4行按键，每行40pt + 3个间距4pt
        let layoutButtonsHeight: CGFloat = 40 + 4  // 布局按钮 + 间距
        let totalHeight = topMargin + buttonRowsHeight + layoutButtonsHeight + 8  // 额外的边距
        
        print("🎯 Calculated intrinsic height: \(totalHeight)")
        
        let keyboardWidth: CGFloat = bounds.width > 0 ? bounds.width : UIView.noIntrinsicMetric
        return CGSize(width: keyboardWidth, height: totalHeight)
    }
    
    // MARK: - Constraint Debugging
    private func debugConstraintState() {
        print("🔍 Constraint Debug State:")
        print("  - View frame: \(frame)")
        print("  - View bounds: \(bounds)")
        print("  - Intrinsic content size: \(intrinsicContentSize)")
        if let superview = superview {
            print("  - Superview frame: \(superview.frame)")
            print("  - Superview bounds: \(superview.bounds)")
        }
        print("  - StackView frame: \(stackView.frame)")
        print("  - Active constraints count: \(constraints.count)")
        
        // 检查是否有约束冲突的可能性
        if bounds.width < 50 {
            print("⚠️ Warning: View width is very small (\(bounds.width)), may cause constraint conflicts")
        }
        if bounds.height == 0 {
            print("⚠️ Warning: View height is zero, requesting intrinsic content size")
            invalidateIntrinsicContentSize()
        }
    }
    
    // MARK: - Layout Specifications
    private func getLayoutSpec(for layout: KeyboardLayout) -> KeyboardLayoutSpec {
        switch layout {
        case .qwerty:
            return QWERTYLayoutSpec()
        case .chinese:
            return ChineseLayoutSpec()
        case .number:
            return NumberLayoutSpec()
        case .symbol:
            return SymbolLayoutSpec()
        case .emoji:
            return EmojiLayoutSpec()
        }
    }
    

    
    // MARK: - T9 Input Handling
    func handleT9Input(_ key: String) -> T9InputResult? {
        guard let t9Engine = t9InputEngine else { return nil }
        
        let result = t9Engine.inputKey(key)
        
        // T9输入结果处理（不再显示候选词）
        switch result {
        case .input(let input):
            print("T9 Input: \(input)")
        case .candidate(let candidate):
            print("T9 Candidate: \(candidate)")
        case .confirmed(let word):
            print("T9 Confirmed: \(word)")
        case .space:
            print("T9 Space")
        case .cleared:
            print("T9 Cleared")
        case .none:
            break
        }
        
        return result
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            print("🎹 KeyboardView added to superview")
            // 当视图被添加到父视图时，确保约束已设置
            setNeedsLayout()
            layoutIfNeeded()
        } else {
            print("🎹 KeyboardView removed from superview")
            // 当视图被移除时，重置状态
            isLayoutCreated = false
            keyViews.removeAll()
        }
    }
    
    override func didMoveToWindow() {
        super.didMoveToWindow()
        
        if window != nil {
            print("🎹 KeyboardView added to window")
            print("🎹 Window bounds: \(window?.bounds ?? .zero)")
            print("🎹 View constraints: \(constraints.count)")
            // 当视图被添加到窗口时，确保布局正确
            DispatchQueue.main.async { [weak self] in
                self?.setNeedsLayout()
                self?.layoutIfNeeded()
            }
        } else {
            print("🎹 KeyboardView removed from window")
            // 当视图被移除时，重置状态
            isLayoutCreated = false
            keyViews.removeAll()
        }
    }
    
    private func validateConstraints() {
        print("🔍 Validating KeyboardView constraints...")
        print("🎹 Constraints count: \(constraints.count)")
        print("🎹 Bounds: \(bounds)")
        print("🎹 Frame: \(frame)")
        
        // 检查是否有足够的约束
        if constraints.count < 8 {
            print("⚠️ Warning: KeyboardView has fewer than 8 constraints")
        }
        
        // 检查约束是否有效
        for (index, constraint) in constraints.enumerated() {
            if !constraint.isActive {
                print("⚠️ Warning: Constraint \(index) is not active")
            }
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        print("🎹 KeyboardView deallocated")
        // 清理关联对象
        objc_setAssociatedObject(self, &AssociatedKeys.lastBounds, nil, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
}

// MARK: - KeyboardKeyViewDelegate
extension KeyboardView: KeyboardKeyViewDelegate {
    func didTapKey(_ key: KeyboardKey) {
        delegate?.didTapKey(key)
    }
    
    func didLongPressKey(_ key: KeyboardKey) {
        delegate?.didLongPressKey(key)
    }
}
