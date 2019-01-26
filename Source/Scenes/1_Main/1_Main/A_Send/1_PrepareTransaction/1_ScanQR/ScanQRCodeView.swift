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

import QRCodeReader
import AVFoundation

private typealias € = L10n.Scene.ScanQRCode

final class ScanQRCodeView: UIView {

    private let scannedQrCodeSubject = PublishSubject<String>()
    private lazy var readerView = QRCodeReaderView()
    private lazy var reader = QRCodeReader(metadataObjectTypes: [.qr], captureDevicePosition: .back)
    private let tracker: Tracking = Tracker()

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) {
        interfaceBuilderSucks
    }
}

private extension ScanQRCodeView {

    func setup() {
        reader.stopScanningWhenCodeIsFound = true
        readerView.backgroundColor = .black
        addSubview(readerView)
        readerView.translatesAutoresizingMaskIntoConstraints = false
        readerView.edgesToSuperview()
        readerView.setupComponents(showCancelButton: false, showSwitchCameraButton: true, showTorchButton: true, showOverlayView: true, reader: reader)

        reader.didFindCode = { [unowned self] in
            self.scannedQrCodeSubject.onNext($0.value)
        }

        reader.didFailDecoding = { [unowned self] in
            self.tracker.track(event: ScanQRCodeViewEvents.failedToScanQRCode, context: self)
        }

        reader.startScanning()
    }
}

extension ScanQRCodeView: ViewModelled {
    typealias ViewModel = ScanQRCodeViewModel

    var inputFromView: InputFromView {
        return InputFromView(
            scannedQrCodeString: scannedQrCodeSubject.asDriverOnErrorReturnEmpty()
        )
    }
}

enum ScanQRCodeViewEvents: String, TrackableEvent {
    case failedToScanQRCode
}
