// 
// MIT License
//
// Copyright (c) 2018-2019 Open Zesame (https://github.com/OpenZesame)
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
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder {
    lazy var window: UIWindow? = .default

    fileprivate lazy var appCoordinator: AppCoordinator = {
        let navigationController = NavigationBarLayoutingNavigationController()
        
        window?.rootViewController = navigationController

        return AppCoordinator(
            navigationController: navigationController,
            deepLinkHandler: DeepLinkHandler(),
            useCaseProvider: DefaultUseCaseProvider.shared,
            isViewControllerRootOfWindow: { [weak self] in
                self?.window?.rootViewController == $0
            },
            setRootViewControllerOfWindow: { [weak self] in
                self?.window?.rootViewController = $0
            }
        )
    }()
}

extension AppDelegate: UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        defer {
            appCoordinator.start()
        }
        bootstrap()
        return true
    }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        guard
            userActivity.activityType == NSUserActivityTypeBrowsingWeb,
            let incomingURL = userActivity.webpageURL
        else {
            return false
        }

        return appCoordinator.handleDeepLink(incomingURL)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        appCoordinator.appWillResignActive()
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        appCoordinator.appDidBecomeActive()
    }
}
