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
