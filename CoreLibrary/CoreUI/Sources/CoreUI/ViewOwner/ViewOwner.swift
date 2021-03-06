import UIKit

public protocol ViewOwner: AnyObject {
    associatedtype RootView: UIView
}

extension ViewOwner where Self: UIViewController {
    public var rootView: RootView {
        guard let rootView = view as? RootView else {
            fatalError("Not found \(RootView.description()) as rootView. Not \(type(of: view))")
        }
        return rootView
    }
}
