// The MIT License (MIT)
//
// Copyright (c) 2016 Suyeol Jeon (xoul.kr)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import UIKit

extension UIViewController {

    /// Returns the current application's top most view controller.
    public class func topMostViewController() -> UIViewController? {
        let rootViewController = UIApplication.sharedApplication().windows.first?.rootViewController
        return self.topMostViewControllerOfViewController(rootViewController)
    }

    /// Returns the top most view controller from given view controller's stack.
    class func topMostViewControllerOfViewController(viewController: UIViewController?) -> UIViewController? {
        // UITabBarController
        if let tabBarController = viewController as? UITabBarController,
           let selectedViewController = tabBarController.selectedViewController {
            return self.topMostViewControllerOfViewController(selectedViewController)
        }

        // UINavigationController
        if let navigationController = viewController as? UINavigationController,
           let visibleViewController = navigationController.visibleViewController {
            return self.topMostViewControllerOfViewController(visibleViewController)
        }

        // presented view controller
        if let presentedViewController = viewController?.presentedViewController {
            return self.topMostViewControllerOfViewController(presentedViewController)
        }

        // child view controller
        for subview in viewController?.view?.subviews ?? [] {
            if let childViewController = subview.nextResponder() as? UIViewController {
                return self.topMostViewControllerOfViewController(childViewController)
            }
        }

        return viewController
    }

}
