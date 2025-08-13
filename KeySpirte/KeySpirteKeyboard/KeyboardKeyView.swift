//
//  KeyboardKeyView.swift
//  KeySpirteKeyboard
//
//  Created by Lei Yang on 12/8/2025.
//

import UIKit

protocol KeyboardKeyViewDelegate: AnyObject {
    func didTapKey(_ key: KeyboardKey)
    func didLongPressKey(_ key: KeyboardKey)
}

class KeyboardKeyView: UIView {
    
    // MARK: - Properties
    weak var delegate: KeyboardKeyViewDelegate?
    private let key: KeyboardKey
    
    // MARK: - UI Components
    private let label = UILabel()
    private let subLabel = UILabel()  // 新增：用于显示T9键盘的字母
    private let backgroundView = UIView()
    
    // MARK: - Initialization
    init(key: KeyboardKey) {
        self.key = key
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .clear
        
        // 设置背景
        backgroundView.backgroundColor = UIColor.systemBackground
        backgroundView.layer.cornerRadius = 6
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize(width: 0, height: 1)
        backgroundView.layer.shadowOpacity = 0.1
        backgroundView.layer.shadowRadius = 2
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(backgroundView)
        
        // 设置主标签 - 将用于显示组合文本（数字+字母）
        label.text = key.character
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)  // 稍微减小字体以容纳更多内容
        label.textColor = UIColor.label
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1  // 确保单行显示
        label.adjustsFontSizeToFitWidth = true  // 自动调整字体大小
        label.minimumScaleFactor = 0.7  // 允许更小的缩放比例
        addSubview(label)
        
        // 设置子标签（保留用于特殊情况，但现在主要用主标签显示组合文本）
        subLabel.textAlignment = .center
        subLabel.font = UIFont.systemFont(ofSize: 10, weight: .regular)
        subLabel.textColor = UIColor.systemGray
        subLabel.translatesAutoresizingMaskIntoConstraints = false
        subLabel.numberOfLines = 1  // 确保单行显示
        subLabel.isHidden = true  // 现在默认隐藏
        addSubview(subLabel)
        
        // 设置约束
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 4),
            label.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -4),
            
            subLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            subLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 2),
            subLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 2),
            subLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -2)
        ])
        
        // 设置手势
        setupGestures()
        
        // 根据按键类型设置特殊样式
        configureForKeyType()
    }
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        addGestureRecognizer(tapGesture)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        addGestureRecognizer(longPressGesture)
    }
    
    private func configureForKeyType() {
        switch key.type {
        case .backspace, .return, .shift:
            label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
            backgroundView.backgroundColor = UIColor.systemGray4
        case .space:
            label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            backgroundView.backgroundColor = UIColor.systemGray5
        case .layout:
            label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
            backgroundView.backgroundColor = UIColor.systemBlue
            label.textColor = UIColor.white
        case .emoji:
            label.font = UIFont.systemFont(ofSize: 20)
        default:
            break
        }
    }
    
    // MARK: - Gesture Handlers
    @objc private func handleTap() {
        // 添加触觉反馈
        let impactFeedback = UIImpactFeedbackGenerator(style: .light)
        impactFeedback.impactOccurred()
        
        // 添加视觉反馈
        UIView.animate(withDuration: 0.1, animations: {
            self.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
            }
        }
        
        delegate?.didTapKey(key)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            // 长按开始
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            }
            
            // 触觉反馈
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
        case .ended, .cancelled:
            // 长按结束
            UIView.animate(withDuration: 0.2) {
                self.transform = .identity
            }
            
            delegate?.didLongPressKey(key)
            
        default:
            break
        }
    }
    
    // MARK: - Highlight States
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        highlightKey(true)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        highlightKey(false)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        highlightKey(false)
    }
    
    private func highlightKey(_ highlighted: Bool) {
        UIView.animate(withDuration: 0.1) {
            if highlighted {
                self.backgroundView.backgroundColor = self.backgroundView.backgroundColor?.withAlphaComponent(0.7)
            } else {
                self.configureForKeyType()
            }
        }
    }
    
    // MARK: - T9 Keyboard Support
    func setT9SubLabel(_ letters: String) {
        // 将数字和字母组合在主标签中显示
        let originalText = key.character
        let combinedText = "\(originalText) \(letters)"
        label.text = combinedText
        
        // 不再使用子标签
        subLabel.isHidden = true
    }
    
    func updateAppearance() {
        // 更新外观以匹配当前的用户界面样式
        label.textColor = UIColor.label
        subLabel.textColor = UIColor.systemGray
        backgroundView.backgroundColor = UIColor.systemBackground
    }
}
