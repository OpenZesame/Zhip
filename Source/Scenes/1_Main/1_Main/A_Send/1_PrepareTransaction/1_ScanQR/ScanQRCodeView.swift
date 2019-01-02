//
//  ScanQRCodeView.swift
//  Zhip
//
//  Created by Alexander Cyon on 2018-12-13.
//  Copyright © 2018 Open Zesame. All rights reserved.
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

        reader.didFailDecoding = {
            log.error("failed to decode QR")
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

