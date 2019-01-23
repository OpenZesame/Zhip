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
import RxSwift
import RxCocoa

final class ButtonWithSpinner: UIButton {
	enum SpinnerMode {
		case replaceText
		case nextToText
	}

    private lazy var spinnerView = SpinnerView()
	private let mode: SpinnerMode
	init(mode: SpinnerMode = .replaceText) {
		self.mode = mode
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { interfaceBuilderSucks }
}

extension ButtonWithSpinner {
	func startSpinning() {
		switch mode {
		case .replaceText:
			titleLabel?.layer.opacity = 0
			bringSubviewToFront(spinnerView)
		case .nextToText: break
		}

		spinnerView.startSpinning()
	}

	func stopSpinning () {
		switch mode {
		case .replaceText:
			titleLabel?.layer.opacity = 1
			sendSubviewToBack(spinnerView)
		case .nextToText: break
		}
		spinnerView.stopSpinning()
	}
}

private extension ButtonWithSpinner {

    func setup() {
		addSubview(spinnerView)
		switch mode {
		case .replaceText:
			spinnerView.edgesToSuperview(insets: UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0))
		case .nextToText:
			spinnerView.size(CGSize(width: 32, height: 32))
			spinnerView.leftToSuperview(offset: 20)
			spinnerView.centerYToSuperview()
		}

    }

    func changeTo(isSpinning: Bool) {
        if isSpinning {
            startSpinning()
        } else {
            stopSpinning()
        }
    }
}

extension Reactive where Base: ButtonWithSpinner {
    var isLoading: Binder<Bool> {
        return Binder(base) {
            $0.changeTo(isSpinning: $1)
        }
    }
}
