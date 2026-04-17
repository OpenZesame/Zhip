# Zhip — Codebase Guide for Claude

## Overview

Zhip is an iOS Zilliqa wallet app built with UIKit + RxSwift using a custom MVVM architecture centered on reactive data-binding. The app targets **iOS 16.6**.

Dependencies relevant to architecture: `RxSwift 6.1`, `RxCocoa`, `RxDataSources 5.0`.

---

## Architecture: Reactive MVVM with `SceneController<View>`

### Core Concept

Every screen consists of exactly two files:
- **`<Scene>View.swift`** — UIView subclass conforming to `ViewModelled`
- **`<Scene>ViewModel.swift`** — inherits `BaseViewModel`, implements `ViewModelType`

A generic `SceneController<View>` instantiates both, wires them together, and is almost never subclassed. The "scene controller" is the glue, not the business logic.

### Data Flow (Unidirectional)

```
User Action (tap, type, toggle)
        ↓
InputFromView struct  ←  View's `inputFromView` computed property
        ↓
ViewModel.Input(fromView:, fromController:)
        ↓
ViewModel.transform(input:) → Output
        ↓
View.populate(with: output) → [Disposable]
        ↓
UI updated via `-->` operator binding outputs to Binders
```

---

## Key Protocols & Types

### `ViewModelType`
**File**: `Sources/Application/ViewModel/ViewModelType.swift`

```swift
protocol ViewModelType {
    associatedtype Input: InputType
    associatedtype OutputVM
    func transform(input: Input) -> OutputVM
}
```

All ViewModels implement `transform`. It is the only public method — input in, output out.

### `InputType`
**File**: `Sources/Application/ViewModel/InputType.swift`

```swift
protocol InputType {
    associatedtype FromView
    associatedtype FromController
    var fromView: FromView { get }
    var fromController: FromController { get }
    init(fromView: FromView, fromController: FromController)
}
```

Every ViewModel's `Input` has two channels:
- `fromView` — user interactions (taps, text, toggles) as `Driver<T>`
- `fromController` — lifecycle events and navigation subjects from `InputFromController`

### `ViewModelled`
**File**: `Sources/Views/Protocols/ViewModelled.swift`

```swift
protocol ViewModelled: EmptyInitializable {
    associatedtype ViewModel: ViewModelType
    typealias InputFromView = ViewModel.Input.FromView
    var inputFromView: InputFromView { get }
    func populate(with viewModel: ViewModel.OutputVM) -> [Disposable]
}
```

Views provide:
- `inputFromView` — computed property building the `InputFromView` struct from UIKit reactive extensions
- `populate(with:)` — binds ViewModel output streams back to UI controls, returns `[Disposable]`

### `InputFromController`
**File**: `Sources/Application/ViewModel/InputFromController.swift`

```swift
struct InputFromController {
    let viewDidLoad: Driver<Void>
    let viewWillAppear: Driver<Void>
    let viewDidAppear: Driver<Void>
    let leftBarButtonTrigger: Driver<Void>
    let rightBarButtonTrigger: Driver<Void>
    let titleSubject: PublishSubject<String>         // ViewModel writes → controller updates nav title
    let leftBarButtonContentSubject: PublishSubject<BarButtonContent>
    let rightBarButtonContentSubject: PublishSubject<BarButtonContent>
    let toastSubject: PublishSubject<Toast>
}
```

The subjects are passed *into* the ViewModel so it can imperatively push navigation/title/toast updates.

### `AbstractViewModel` / `BaseViewModel`

```
AbstractViewModel<FromView, FromController, Output>  (has DisposeBag, defines Input struct)
    └── BaseViewModel<NavigationStep, FromView, Output>  (adds navigator: Navigator<Step>)
            └── Concrete ViewModels
```

`BaseViewModel` conforms to `Navigating` which lets the ViewModel emit navigation steps picked up by the coordinator.

---

## SceneController — The Orchestrator
**File**: `Sources/Controller/SceneController.swift`

```swift
class SceneController<View: ContentView>: AbstractController
    where View.ViewModel.Input.FromController == InputFromController
```

Key responsibility chain on init:
1. Creates `View()` (via `EmptyInitializable`)
2. `makeAndSubscribeToInputFromController()` — builds `InputFromController` with lifecycle drivers and subscribed subjects
3. `viewModel.transform(input:)` — runs the ViewModel transformation
4. `rootContentView.populate(with: output)` — establishes all UI bindings; disposes into `bag`

`SceneController` is never overridden for logic — it's purely mechanical wiring.

### `TitledScene`
**File**: `Sources/Controller/TitledScene.swift`

Optional protocol on `SceneController` subclasses. When conformed, `SceneController` sets `title` automatically from `static var title: String`.

### Scene Typealias
**File**: `Sources/Controller/Scene.swift`

```swift
typealias Scene<View: ContentView> = SceneController<View> & TitledScene
    where View.ViewModel.Input.FromController == InputFromController
```

Used throughout coordinators: `Scene<ChoosePincodeView>`, `Scene<SettingsView>`, etc.

---

## The `-->` Binding Operator
**File**: `Sources/Extensions/RxSwift/Driver+Operator.swift`

```swift
infix operator -->
func --> <E>(driver: Driver<E>, binder: Binder<E>) -> Disposable { driver.drive(binder) }
```

Overloaded for `Binder<E?>`, `AnyObserver<E>`, `ControlProperty<String>`, `UILabel`, `UITextView`, `TitledValueView`.

Also defines `<~` for adding to `DisposeBag`:
```swift
infix operator <~
func <~ (bag: DisposeBag, disposable: Disposable) { disposable.disposed(by: bag) }
func <~ (bag: DisposeBag, disposables: [Disposable?]) { ... }
```

Usage in `populate`:
```swift
func populate(with viewModel: ViewModel.Output) -> [Disposable] {
    [
        viewModel.isContinueButtonEnabled --> continueButton.rx.isEnabled,
        viewModel.encryptionPasswordValidation --> encryptionPasswordField.rx.validation,
    ]
}
```

Usage in ViewModel `transform`:
```swift
bag <~ [
    input.fromView.createWalletTrigger
        .do(onNext: { userIntends(to: .createWallet) })
        .drive(),
]
```

---

## Custom UIKit Reactive Extensions

All are in `Sources/Extensions/UIKit/UIViews+Reactive/` or inline in view files.

| Extension | File | RxSwift type |
|-----------|------|-------------|
| `UITextField.rx.placeholder` | `UITextField+Rx.swift` | `Binder<String?>` |
| `UITextField.rx.isEditing` | `UITextField+Rx.swift` | `Driver<Bool>` |
| `UITextField.rx.didEndEditing` | `UITextField+Rx.swift` | `Driver<Void>` |
| `UITextView.rx.text` (write) | `UITextView+Rx.swift` | `AnyObserver<String>` |
| `UIView.rx.isVisible` | `UIView+Rx.swift` | `Binder<Bool>` |
| `UIControl.rx.becomeFirstResponder` | `UIControl+Rx.swift` | `Binder<Void>` |
| `FloatingLabelTextField.rx.validation` | `FloatingLabelTextField.swift` | `Binder<AnyValidation>` |
| `CheckboxView.rx.isChecked` | `CheckboxWithLabel.swift` | `ControlProperty<Bool>` |
| `CheckboxWithLabel.rx.isChecked` | `CheckboxWithLabel.swift` | `ControlProperty<Bool>` |
| `ButtonWithSpinner.rx.isLoading` | `ButtonWithSpinner.swift` | `Binder<Bool>` |
| `SpinnerView.rx.isLoading` | `SpinnerView.swift` | `Binder<Bool>` |
| `AbstractSceneView.rx.isRefreshing` | `AbstractSceneView.swift` | `Binder<Bool>` |
| `AbstractSceneView.rx.pullToRefreshTitle` | `AbstractSceneView.swift` | `Binder<String>` |
| `AbstractSceneView.rx.pullToRefreshTrigger` | `AbstractSceneView.swift` | `Driver<Void>` |
| `UITableView.rx.footerLabel` | `UITableView+Footer.swift` | `Binder<String>` |

---

## Table Views — RxDataSources
**File**: `Sources/Views/TableView/SingleCellTypeTableView.swift`

```swift
class SingleCellTypeTableView<Header, Cell: ListCell>: UITableView {
    typealias DataSource = RxTableViewSectionedReloadDataSource<SectionModel<Header, Cell.Model>>
    lazy var rxDataSource = DataSource(configureCell: { ... })
    lazy var sections: Sections<Header, Cell.Model> = rx.items(dataSource: rxDataSource)
    lazy var didSelectItem: Driver<IndexPath> = rx.itemSelected.asDriver()...
}
```

Used by `SettingsView` and others via `viewModel.sections.drive(tableView.sections)`.

---

## Validation System

`AnyValidation` enum with `.valid(withRemark:)`, `.empty`, `.errorMessage(String)`.
`FloatingLabelTextField.rx.validation` takes an `AnyValidation` and applies visual feedback.
ViewModels produce `Driver<AnyValidation>` which gets bound via `-->`.

## Activity Tracking

`ActivityIndicator` (wraps `BehaviorSubject<Bool>`) tracks async operations:
```swift
someObservable.trackActivity(activityIndicator)
// activityIndicator.asDriver() → Driver<Bool> → button.rx.isLoading
```

---

## Navigation / Coordination

`BaseViewModel` holds `navigator: Navigator<NavigationStep>` (a `Stepper`).
Coordinators subscribe to the navigator and handle screen transitions.
ViewModels call `userIntends(to: .someStep)` to trigger navigation.

---

## Key File Locations

| Concept | Path |
|---------|------|
| `ViewModelType` | `Sources/Application/ViewModel/ViewModelType.swift` |
| `InputType` | `Sources/Application/ViewModel/InputType.swift` |
| `ViewModelled` | `Sources/Views/Protocols/ViewModelled.swift` |
| `AbstractViewModel` | `Sources/Application/ViewModel/BaseClasses/AbstractViewModel.swift` |
| `BaseViewModel` | `Sources/Application/ViewModel/BaseClasses/BaseViewModel.swift` |
| `SceneController` | `Sources/Controller/SceneController.swift` |
| `InputFromController` | `Sources/Application/ViewModel/InputFromController.swift` |
| `Scene` typealias | `Sources/Controller/Scene.swift` |
| `-->` operator | `Sources/Extensions/RxSwift/Driver+Operator.swift` |
| `ActivityIndicator` | `Sources/Application/ViewModel/ActivityIndicator.swift` |
| `AnyValidation` | `Sources/Application/InputValidators/Validation/AnyValidation/AnyValidation.swift` |
| `SingleCellTypeTableView` | `Sources/Views/TableView/SingleCellTypeTableView.swift` |

---

## Combine Migration Feasibility (assessed 2026-04-17)

**Assessment: ~82% confident — feasible but below the 90% auto-migration threshold.**

### What maps cleanly

| RxSwift | Combine equivalent |
|---------|-------------------|
| `Driver<T>` | `AnyPublisher<T, Never>` with `.receive(on: RunLoop.main)` |
| `Observable<T>` | `AnyPublisher<T, Error>` |
| `Disposable` / `DisposeBag` | `AnyCancellable` / `Set<AnyCancellable>` |
| `PublishSubject<T>` | `PassthroughSubject<T, Never>` |
| `BehaviorSubject<T>` | `CurrentValueSubject<T, Never>` |
| `subject.onNext(x)` | `subject.send(x)` |
| `populate(...) -> [Disposable]` | `populate(...) -> [AnyCancellable]` |
| `bag <~ [...]` | custom `<~` operator on `Set<AnyCancellable>` |
| `-->` operator | reimplementable for `AnyPublisher` + closures |
| `UIViewController.rx.viewDidLoad` | `NotificationCenter` or override-based publisher |

### Points of uncertainty (the ~18%)

1. **`Driver` sharing/replay semantics**: `Driver` uses `share(replay:1, scope:.whileConnected)` — new subscribers receive the last emitted value. Combine's `share()` does NOT replay. Achieving this requires `CurrentValueSubject` or a custom `ReplaySubject`. Without it, late-subscribing UI elements (e.g. on `viewWillAppear`) might miss initial values.

2. **`ControlProperty<Bool>` (bidirectional)**: Used for `CheckboxView.rx.isChecked` — it's both a source (user toggles) and sink (set programmatically). In Combine there's no native equivalent. Requires a custom publisher wrapping `UIControl.addTarget` + a `CurrentValueSubject` for writes.

3. **UITextField text binding**: `rx.text.orEmpty.asDriver()` relies on `RxCocoa.ControlProperty<String?>`. In Combine: `NotificationCenter.publisher(for: UITextField.textDidChangeNotification, object: field).compactMap { ... }`. Works but more verbose; the `.orEmpty` helper needs a custom operator.

4. **`rx.itemSelected` on UITableView**: No native Combine publisher — needs `UITableViewDelegate` proxy or wrapping.

5. **RxDataSources** (`SingleCellTypeTableView`): `RxTableViewSectionedReloadDataSource` and the `sections: Sections<H,C>` typealias need full replacement. Best modern path is `UITableViewDiffableDataSource` (native, iOS 13+), but it is a meaningfully different API (snapshots vs section models). This affects `SettingsView`, `ChooseWalletView`, and other table-backed screens.

6. **Scale**: 89 files import `RxSwift`/`RxCocoa` — systematic but large.

### Recommended path if proceeding

1. Define bridging typealiases (`typealias Driver<T> = AnyPublisher<T, Never>`) and a `CancellableBag` class mirroring `DisposeBag` to allow incremental migration.
2. Rewrite all UIKit reactive extensions as Combine publishers/subscribers.
3. Reimplement `ActivityIndicator`, `ErrorTracker`, `FilterNil` in Combine.
4. Reimplement `-->` operator and `<~` operator.
5. Replace `RxDataSources` usage with `UITableViewDiffableDataSource`.
6. Migrate `InputFromController` subjects to `PassthroughSubject`.
7. Update `ViewModelled` protocol (`[Disposable]` → `[AnyCancellable]`).
8. Migrate ViewModels scene-by-scene.
