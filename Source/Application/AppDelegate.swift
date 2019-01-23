//
// Copyright 2019 Open Zesame
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under thexc License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
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
            useCaseProvider: DefaultUseCaseProvider.shared
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

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return appCoordinator.handleDeepLink(url, options: options)
    }

    func applicationWillResignActive(_ application: UIApplication) {
        appCoordinator.appWillResignActive()
    }
}
