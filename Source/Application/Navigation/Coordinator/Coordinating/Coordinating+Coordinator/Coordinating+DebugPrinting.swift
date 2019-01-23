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

extension Coordinating {
    // Please fix this ugly code for me... we want a nice ascii representation of the coordinator and its
    // coordinator stack and navigation stack (both presented scenes and non presented scenes.),
    // using an increasing indentation for each level of depth
    // swiftlint:disable:next function_body_length
    func stringRepresentation(level: Int) -> String {
        let indendation: String = [String](repeating: "\t", count: level).joined()

        func scenesFor(_ navCont: UIViewController?) -> String? {
            guard let navCont = navCont as? UINavigationController, !navCont.viewControllers.isEmpty else { return nil }
            return navCont.viewControllers.compactMap { $0 as? AbstractController }.map { $0.description }.joined(separator: ", ")
        }

        let scenesString: String = {
            guard !(self is AppCoordinator) else { return ", " }
            let directScenes = scenesFor(navigationController) ?? ""

            var presentedScenes = ""
            if let presentedScenesString = scenesFor(navigationController.presentedViewController) {
                presentedScenes = "presented scenes: [\(presentedScenesString)]\n\(indendation)\t"
                if directScenes.isEmpty {
                    return presentedScenes
                } else {
                    presentedScenes = ", \(presentedScenes)"
                }
            } else if directScenes.isEmpty {
                return ""
            }

            return """
                , scenes: [
                \(indendation)\t\t\(directScenes)
                \(indendation)\t]
                """ + presentedScenes
        }()

        let children: String = childCoordinators.map { $0.stringRepresentation(level: level + 2) }.joined(separator: ", \n\t")

        let childrenString: String = {
            guard !childCoordinators.isEmpty else {
                return ""
            }

            let separator = scenesString.isEmpty ? "" : ", "

            return """
            \(separator)children: [\(children)
            \(indendation)\t]
            """
        }()

        return """
        \n\(indendation){
        \(indendation)\t\(type(of: self))(nc: \(navigationController.hashValue.description.dropFirst(12)))\(scenesString)\(childrenString)
        \(indendation)}
        """
    }
}
