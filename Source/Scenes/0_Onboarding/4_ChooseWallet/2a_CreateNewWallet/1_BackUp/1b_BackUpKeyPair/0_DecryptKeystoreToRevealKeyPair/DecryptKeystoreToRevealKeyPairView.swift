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

final class DecryptKeystoreToRevealKeyPairView: ScrollableStackViewOwner {

    private lazy var decryptToRevealLabel       = UILabel()
    private lazy var encryptionPasswordField  = FloatingLabelTextField()
    private lazy var revealButton               = ButtonWithSpinner()

    lazy var stackViewStyle = UIStackView.Style([
        decryptToRevealLabel,
        encryptionPasswordField,
        .spacer,
        revealButton
        ], spacing: 20)

    override func setup() {
        setupSubviews()
    }
}

extension DecryptKeystoreToRevealKeyPairView: ViewModelled {
    typealias ViewModel = DecryptKeystoreToRevealKeyPairViewModel

    func populate(with viewModel: ViewModel.Output) -> [Disposable] {
        return [
            viewModel.encryptionPasswordValidation    --> encryptionPasswordField.rx.validation,
            viewModel.isRevealButtonLoading             --> revealButton.rx.isLoading,
            viewModel.isRevealButtonEnabled             --> revealButton.rx.isEnabled
        ]
    }

    var inputFromView: InputFromView {
        return InputFromView(
            encryptionPassword: encryptionPasswordField.rx.text.orEmpty.asDriver(),
            isEditingEncryptionPassword: encryptionPasswordField.rx.isEditing,
            revealTrigger: revealButton.rx.tap.asDriver()
        )
    }
}

private typealias € = L10n.Scene.DecryptKeystoreToRevealKeyPair
private extension DecryptKeystoreToRevealKeyPairView {
    func setupSubviews() {

        decryptToRevealLabel.withStyle(.body) {
            $0.text(€.Label.decryptToReaveal)
        }

        encryptionPasswordField.withStyle(.password) {
            $0.placeholder(€.Field.encryptionPassword)
        }

        revealButton .withStyle(.primary) {
            $0.title(€.Button.reveal)
                .disabled()
        }
    }
}
