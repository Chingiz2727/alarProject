import UIKit
import SnapKit

@IBDesignable public class FloatLabelTextField: UITextField, BaseTextField {
    public var textFieldText: String {
        return text ?? ""
    }
    
    public var isValid: Bool = false
    
    public var fieldState: TextfieldState = .onEditing {
        didSet {
            changeState(state: fieldState)
        }
    }
    
    public var listenerDelegate: TextFieldListener?
    private let animationDuration = 0.3
    public var title = UILabel()
    public var descriptionLabel = UILabel()
    public var line = UIView()
    public var isButtonHidable: Bool = false
    
    public let rightButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "crossButton")
        button.setImage(image, for: .normal)
        return button
    }()
    
    private enum Constants {
        static let buttonWidth: CGFloat = 22
        static let buttonHeight: CGFloat = 20
        static let rightSpacing: CGFloat = -17
    }
    
    // MARK:- Properties
    public override var accessibilityLabel:String? {
        get {
            if let txt = text , txt.isEmpty {
                return title.text
            } else {
                return text
            }
        }
        set {
            self.accessibilityLabel = newValue
        }
    }
    
    public override var placeholder:String? {
        didSet {
            title.text = placeholder
            title.sizeToFit()
        }
    }
    
    public override var attributedPlaceholder:NSAttributedString? {
        didSet {
            title.text = attributedPlaceholder?.string
            title.sizeToFit()
        }
    }
    
    public var titleFont:UIFont = UIFont.systemFont(ofSize: 14.0) {
        didSet {
            title.font = titleFont
            title.sizeToFit()
        }
    }
    
    @IBInspectable public var hintYPadding:CGFloat = 0.0
    
    @IBInspectable public var titleYPadding:CGFloat = 0.0 {
        didSet {
            var r = title.frame
            r.origin.y = titleYPadding
            title.frame = r
        }
    }
    
    @IBInspectable var titleTextColour:UIColor = .systemBlue {
        didSet {
            if !isFirstResponder {
                title.textColor = titleTextColour
            }
        }
    }
    
    @IBInspectable public var titleActiveTextColour:UIColor! = .systemBlue {
        didSet {
            if isFirstResponder {
                title.textColor = titleActiveTextColour
            }
        }
    }
    
    // MARK:- Init
    public required init?(coder aDecoder:NSCoder) {
        super.init(coder:aDecoder)
        setup()
    }
    
    public override init(frame:CGRect) {
        super.init(frame:frame)
        setup()
    }
    
    public func changeState(state: TextfieldState) {
        switch state {
        case .onEditing:
            title.textColor = titleActiveTextColour
            line.backgroundColor = titleActiveTextColour
            descriptionLabel.isHidden = true
        case .onError(let text):
            title.textColor = .red
            descriptionLabel.textColor = .red
            descriptionLabel.isHidden = false
            descriptionLabel.text = text
            line.backgroundColor = .red
        case .onWarning:
            break
        }
    }
    
    // MARK:- Overrides
    public override func layoutSubviews() {
        super.layoutSubviews()
        setTitlePositionForTextAlignment()
        checkState()
    }
    
    public override func clearButtonRect(forBounds bounds:CGRect) -> CGRect {
        var r = super.clearButtonRect(forBounds: bounds)
        if let txt = text , !txt.isEmpty {
            var top = ceil(title.font.lineHeight + hintYPadding)
            top = min(top, maxTopInset())
            r = CGRect(x:r.origin.x, y:r.origin.y + (top * 0.5), width:r.size.width, height:r.size.height)
        }
        return r.integral
    }
    
    
    public override func textRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.textRect(forBounds: bounds)
        return CGRect(
            x: superRect.origin.x,
            y: 0,
            width: superRect.width - Constants.buttonWidth + Constants.rightSpacing - 5,
            height: superRect.height
        )
    }
    
    public override func editingRect(forBounds bounds: CGRect) -> CGRect {
        let superRect = super.editingRect(forBounds: bounds)
        return CGRect(
            x: superRect.origin.x,
            y: 0,
            width: superRect.width - Constants.buttonWidth + Constants.rightSpacing - 5,
            height: superRect.height
        )
    }
    
    // MARK:- Public Methods
    
    // MARK:- Private Methods
    fileprivate func setup() {
        borderStyle = UITextField.BorderStyle.none
        addSubview(line)
        addSubview(rightButton)
        addSubview(descriptionLabel)
        line.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview()
            make.height.equalTo(1)
        }
        
        rightButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
            make.trailing.equalToSuperview().inset(5)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(line.snp.bottom).offset(5)
            $0.leading.equalToSuperview()
        }
        
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.textAlignment = .left
        // Set up title label
        title.alpha = 0.0
        title.font = titleFont
        title.textColor = titleActiveTextColour
        line.backgroundColor = .lightGray
        if let str = placeholder , !str.isEmpty {
            title.text = str
            title.sizeToFit()
        }
        self.addSubview(title)
    }
    
    @objc private func clear() {
        text = nil
    }

    fileprivate func maxTopInset()->CGFloat {
        if let fnt = font {
            return max(0, floor(bounds.size.height - fnt.lineHeight - 4.0))
        }
        return 0
    }
    
    fileprivate func setTitlePositionForTextAlignment() {
        let r = textRect(forBounds: bounds)
        var x = r.origin.x
        if textAlignment == NSTextAlignment.center {
            x = r.origin.x + (r.size.width * 0.5) - title.frame.size.width
        } else if textAlignment == NSTextAlignment.right {
            x = r.origin.x + r.size.width - title.frame.size.width
        }
        title.frame = CGRect(x:x, y:title.frame.origin.y, width:title.frame.size.width, height:title.frame.size.height)
    }
    
    fileprivate func showTitle(_ animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay: 0, options: [UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseOut], animations: {
            // Animation
            if self.isButtonHidable {
                self.rightButton.isHidden = false
            }
            
            self.title.alpha = 1.0
            self.line.backgroundColor = self.titleActiveTextColour
            var r = self.title.frame
            r.origin.y = self.titleYPadding - 10
            self.title.frame = r
        }, completion: nil)
    }
    
    fileprivate func hideTitle(_ animated:Bool) {
        let dur = animated ? animationDuration : 0
        UIView.animate(withDuration: dur, delay: 0, options: [UIView.AnimationOptions.beginFromCurrentState, UIView.AnimationOptions.curveEaseIn], animations: {
            // Animation
            if self.isButtonHidable {
                self.rightButton.isHidden = true
            }
            
            self.title.alpha = 0.0
            self.line.backgroundColor = .lightGray
            var r = self.title.frame
            r.origin.y = self.title.font.lineHeight - 10
            self.title.frame = r
        }, completion: nil)
    }
    
    fileprivate func checkState() {
        let isResp = isFirstResponder
        if let txt = text , !txt.isEmpty && isResp {
            title.textColor = titleActiveTextColour
            descriptionLabel.isHidden = true
        } else {
            changeState(state: fieldState)
        }
        // Should we show or hide the title label?
        if let txt = text , txt.isEmpty {
            // Hide
            if isButtonHidable {
                rightButton.isHidden = true
            }
            hideTitle(isResp)
        } else {
            // Show
            if isButtonHidable {
                rightButton.isHidden = false
            }
            showTitle(isResp)
        }
    }
}
