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
