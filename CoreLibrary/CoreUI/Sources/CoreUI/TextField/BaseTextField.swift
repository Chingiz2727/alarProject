import UIKit

public protocol TextFieldListener {
    func textFieldChanging(textField: BaseTextField, text: String)
    
}

public protocol BaseTextField where Self: UITextField {
    var textFieldText: String { get }
    var isValid: Bool { get set }
    var listenerDelegate: TextFieldListener? { get set}
    func changeState(state: TextfieldState)
}
