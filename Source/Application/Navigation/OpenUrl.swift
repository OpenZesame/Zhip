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

func openUrl(string baseUrlString: String, relative path: String? = nil, tracker: Tracker? = nil, context: Any = NoContext()) {
    func createUrl() -> URL? {
        guard let baseUrl = URL(string: baseUrlString) else { return nil }
        guard let path = path else { return baseUrl }
        return URL(string: path, relativeTo: baseUrl)
    }

    guard let url = createUrl() else {
        tracker?.track(event: TrackedError.failedToCreateUrl(from: baseUrlString), context: context)
        return
    }

    UIApplication.shared.open(url, options: [:], completionHandler: nil)
}
