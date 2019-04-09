// DO NOT EDIT.
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: Source/Models/Protobuf/messages.proto
//
// For information on using the generated types, please see the documenation:
//   https://github.com/apple/swift-protobuf/

// ============================================================================
// File: messages.proto
// Git source: github.com/Zilliqa/Zilliqa-JavaScript-Library
// Git commit: 884588bb888b8c2fb34ef459f5b38d85c16607ae
// Date:  2019-01-23
//
// Full path: https://github.com/Zilliqa/Zilliqa-JavaScript-Library/blob/884588bb888b8c2fb34ef459f5b38d85c16607ae/packages/zilliqa-js-proto/src/messages.proto
// 
// Run instructions: `cd Source/Models/Protobuf && protoc --swift_opt=Visibility=Public --swift_out=. messages.proto`
//
// ============================================================================

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that your are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

public struct ByteArray {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var data: Data {
    get {return _data ?? SwiftProtobuf.Internal.emptyData}
    set {_data = newValue}
  }
  /// Returns true if `data` has been explicitly set.
  public var hasData: Bool {return self._data != nil}
  /// Clears the value of `data`. Subsequent reads from it will return its default value.
  public mutating func clearData() {self._data = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _data: Data? = nil
}

public struct ProtoTransactionCoreInfo {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var version: UInt32 {
    get {return _storage._version ?? 0}
    set {_uniqueStorage()._version = newValue}
  }
  /// Returns true if `version` has been explicitly set.
  public var hasVersion: Bool {return _storage._version != nil}
  /// Clears the value of `version`. Subsequent reads from it will return its default value.
  public mutating func clearVersion() {_uniqueStorage()._version = nil}

  public var nonce: UInt64 {
    get {return _storage._nonce ?? 0}
    set {_uniqueStorage()._nonce = newValue}
  }
  /// Returns true if `nonce` has been explicitly set.
  public var hasNonce: Bool {return _storage._nonce != nil}
  /// Clears the value of `nonce`. Subsequent reads from it will return its default value.
  public mutating func clearNonce() {_uniqueStorage()._nonce = nil}

  public var toaddr: Data {
    get {return _storage._toaddr ?? SwiftProtobuf.Internal.emptyData}
    set {_uniqueStorage()._toaddr = newValue}
  }
  /// Returns true if `toaddr` has been explicitly set.
  public var hasToaddr: Bool {return _storage._toaddr != nil}
  /// Clears the value of `toaddr`. Subsequent reads from it will return its default value.
  public mutating func clearToaddr() {_uniqueStorage()._toaddr = nil}

  public var senderpubkey: ByteArray {
    get {return _storage._senderpubkey ?? ByteArray()}
    set {_uniqueStorage()._senderpubkey = newValue}
  }
  /// Returns true if `senderpubkey` has been explicitly set.
  public var hasSenderpubkey: Bool {return _storage._senderpubkey != nil}
  /// Clears the value of `senderpubkey`. Subsequent reads from it will return its default value.
  public mutating func clearSenderpubkey() {_uniqueStorage()._senderpubkey = nil}

  public var amount: ByteArray {
    get {return _storage._amount ?? ByteArray()}
    set {_uniqueStorage()._amount = newValue}
  }
  /// Returns true if `amount` has been explicitly set.
  public var hasAmount: Bool {return _storage._amount != nil}
  /// Clears the value of `amount`. Subsequent reads from it will return its default value.
  public mutating func clearAmount() {_uniqueStorage()._amount = nil}

  public var gasprice: ByteArray {
    get {return _storage._gasprice ?? ByteArray()}
    set {_uniqueStorage()._gasprice = newValue}
  }
  /// Returns true if `gasprice` has been explicitly set.
  public var hasGasprice: Bool {return _storage._gasprice != nil}
  /// Clears the value of `gasprice`. Subsequent reads from it will return its default value.
  public mutating func clearGasprice() {_uniqueStorage()._gasprice = nil}

  public var gaslimit: UInt64 {
    get {return _storage._gaslimit ?? 0}
    set {_uniqueStorage()._gaslimit = newValue}
  }
  /// Returns true if `gaslimit` has been explicitly set.
  public var hasGaslimit: Bool {return _storage._gaslimit != nil}
  /// Clears the value of `gaslimit`. Subsequent reads from it will return its default value.
  public mutating func clearGaslimit() {_uniqueStorage()._gaslimit = nil}

  public var code: Data {
    get {return _storage._code ?? SwiftProtobuf.Internal.emptyData}
    set {_uniqueStorage()._code = newValue}
  }
  /// Returns true if `code` has been explicitly set.
  public var hasCode: Bool {return _storage._code != nil}
  /// Clears the value of `code`. Subsequent reads from it will return its default value.
  public mutating func clearCode() {_uniqueStorage()._code = nil}

  public var data: Data {
    get {return _storage._data ?? SwiftProtobuf.Internal.emptyData}
    set {_uniqueStorage()._data = newValue}
  }
  /// Returns true if `data` has been explicitly set.
  public var hasData: Bool {return _storage._data != nil}
  /// Clears the value of `data`. Subsequent reads from it will return its default value.
  public mutating func clearData() {_uniqueStorage()._data = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

public struct ProtoTransaction {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var tranid: Data {
    get {return _storage._tranid ?? SwiftProtobuf.Internal.emptyData}
    set {_uniqueStorage()._tranid = newValue}
  }
  /// Returns true if `tranid` has been explicitly set.
  public var hasTranid: Bool {return _storage._tranid != nil}
  /// Clears the value of `tranid`. Subsequent reads from it will return its default value.
  public mutating func clearTranid() {_uniqueStorage()._tranid = nil}

  public var info: ProtoTransactionCoreInfo {
    get {return _storage._info ?? ProtoTransactionCoreInfo()}
    set {_uniqueStorage()._info = newValue}
  }
  /// Returns true if `info` has been explicitly set.
  public var hasInfo: Bool {return _storage._info != nil}
  /// Clears the value of `info`. Subsequent reads from it will return its default value.
  public mutating func clearInfo() {_uniqueStorage()._info = nil}

  public var signature: ByteArray {
    get {return _storage._signature ?? ByteArray()}
    set {_uniqueStorage()._signature = newValue}
  }
  /// Returns true if `signature` has been explicitly set.
  public var hasSignature: Bool {return _storage._signature != nil}
  /// Clears the value of `signature`. Subsequent reads from it will return its default value.
  public mutating func clearSignature() {_uniqueStorage()._signature = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

public struct ProtoTransactionReceipt {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var receipt: Data {
    get {return _receipt ?? SwiftProtobuf.Internal.emptyData}
    set {_receipt = newValue}
  }
  /// Returns true if `receipt` has been explicitly set.
  public var hasReceipt: Bool {return self._receipt != nil}
  /// Clears the value of `receipt`. Subsequent reads from it will return its default value.
  public mutating func clearReceipt() {self._receipt = nil}

  public var cumgas: UInt64 {
    get {return _cumgas ?? 0}
    set {_cumgas = newValue}
  }
  /// Returns true if `cumgas` has been explicitly set.
  public var hasCumgas: Bool {return self._cumgas != nil}
  /// Clears the value of `cumgas`. Subsequent reads from it will return its default value.
  public mutating func clearCumgas() {self._cumgas = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _receipt: Data? = nil
  fileprivate var _cumgas: UInt64? = nil
}

public struct ProtoTransactionWithReceipt {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  public var transaction: ProtoTransaction {
    get {return _storage._transaction ?? ProtoTransaction()}
    set {_uniqueStorage()._transaction = newValue}
  }
  /// Returns true if `transaction` has been explicitly set.
  public var hasTransaction: Bool {return _storage._transaction != nil}
  /// Clears the value of `transaction`. Subsequent reads from it will return its default value.
  public mutating func clearTransaction() {_uniqueStorage()._transaction = nil}

  public var receipt: ProtoTransactionReceipt {
    get {return _storage._receipt ?? ProtoTransactionReceipt()}
    set {_uniqueStorage()._receipt = newValue}
  }
  /// Returns true if `receipt` has been explicitly set.
  public var hasReceipt: Bool {return _storage._receipt != nil}
  /// Clears the value of `receipt`. Subsequent reads from it will return its default value.
  public mutating func clearReceipt() {_uniqueStorage()._receipt = nil}

  public var unknownFields = SwiftProtobuf.UnknownStorage()

  public init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension ByteArray: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "ByteArray"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "data"),
  ]

  public var isInitialized: Bool {
    if self._data == nil {return false}
    return true
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularBytesField(value: &self._data)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._data {
      try visitor.visitSingularBytesField(value: v, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ByteArray, rhs: ByteArray) -> Bool {
    if lhs._data != rhs._data {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ProtoTransactionCoreInfo: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "ProtoTransactionCoreInfo"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "version"),
    2: .same(proto: "nonce"),
    3: .same(proto: "toaddr"),
    4: .same(proto: "senderpubkey"),
    5: .same(proto: "amount"),
    6: .same(proto: "gasprice"),
    7: .same(proto: "gaslimit"),
    8: .same(proto: "code"),
    9: .same(proto: "data"),
  ]

  fileprivate class _StorageClass {
    var _version: UInt32? = nil
    var _nonce: UInt64? = nil
    var _toaddr: Data? = nil
    var _senderpubkey: ByteArray? = nil
    var _amount: ByteArray? = nil
    var _gasprice: ByteArray? = nil
    var _gaslimit: UInt64? = nil
    var _code: Data? = nil
    var _data: Data? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _version = source._version
      _nonce = source._nonce
      _toaddr = source._toaddr
      _senderpubkey = source._senderpubkey
      _amount = source._amount
      _gasprice = source._gasprice
      _gaslimit = source._gaslimit
      _code = source._code
      _data = source._data
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public var isInitialized: Bool {
    return withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._senderpubkey, !v.isInitialized {return false}
      if let v = _storage._amount, !v.isInitialized {return false}
      if let v = _storage._gasprice, !v.isInitialized {return false}
      return true
    }
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularUInt32Field(value: &_storage._version)
        case 2: try decoder.decodeSingularUInt64Field(value: &_storage._nonce)
        case 3: try decoder.decodeSingularBytesField(value: &_storage._toaddr)
        case 4: try decoder.decodeSingularMessageField(value: &_storage._senderpubkey)
        case 5: try decoder.decodeSingularMessageField(value: &_storage._amount)
        case 6: try decoder.decodeSingularMessageField(value: &_storage._gasprice)
        case 7: try decoder.decodeSingularUInt64Field(value: &_storage._gaslimit)
        case 8: try decoder.decodeSingularBytesField(value: &_storage._code)
        case 9: try decoder.decodeSingularBytesField(value: &_storage._data)
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._version {
        try visitor.visitSingularUInt32Field(value: v, fieldNumber: 1)
      }
      if let v = _storage._nonce {
        try visitor.visitSingularUInt64Field(value: v, fieldNumber: 2)
      }
      if let v = _storage._toaddr {
        try visitor.visitSingularBytesField(value: v, fieldNumber: 3)
      }
      if let v = _storage._senderpubkey {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      }
      if let v = _storage._amount {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      }
      if let v = _storage._gasprice {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
      }
      if let v = _storage._gaslimit {
        try visitor.visitSingularUInt64Field(value: v, fieldNumber: 7)
      }
      if let v = _storage._code {
        try visitor.visitSingularBytesField(value: v, fieldNumber: 8)
      }
      if let v = _storage._data {
        try visitor.visitSingularBytesField(value: v, fieldNumber: 9)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ProtoTransactionCoreInfo, rhs: ProtoTransactionCoreInfo) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._version != rhs_storage._version {return false}
        if _storage._nonce != rhs_storage._nonce {return false}
        if _storage._toaddr != rhs_storage._toaddr {return false}
        if _storage._senderpubkey != rhs_storage._senderpubkey {return false}
        if _storage._amount != rhs_storage._amount {return false}
        if _storage._gasprice != rhs_storage._gasprice {return false}
        if _storage._gaslimit != rhs_storage._gaslimit {return false}
        if _storage._code != rhs_storage._code {return false}
        if _storage._data != rhs_storage._data {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ProtoTransaction: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "ProtoTransaction"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "tranid"),
    2: .same(proto: "info"),
    3: .same(proto: "signature"),
  ]

  fileprivate class _StorageClass {
    var _tranid: Data? = nil
    var _info: ProtoTransactionCoreInfo? = nil
    var _signature: ByteArray? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _tranid = source._tranid
      _info = source._info
      _signature = source._signature
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public var isInitialized: Bool {
    return withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._info, !v.isInitialized {return false}
      if let v = _storage._signature, !v.isInitialized {return false}
      return true
    }
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularBytesField(value: &_storage._tranid)
        case 2: try decoder.decodeSingularMessageField(value: &_storage._info)
        case 3: try decoder.decodeSingularMessageField(value: &_storage._signature)
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._tranid {
        try visitor.visitSingularBytesField(value: v, fieldNumber: 1)
      }
      if let v = _storage._info {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      }
      if let v = _storage._signature {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ProtoTransaction, rhs: ProtoTransaction) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._tranid != rhs_storage._tranid {return false}
        if _storage._info != rhs_storage._info {return false}
        if _storage._signature != rhs_storage._signature {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ProtoTransactionReceipt: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "ProtoTransactionReceipt"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "receipt"),
    2: .same(proto: "cumgas"),
  ]

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      switch fieldNumber {
      case 1: try decoder.decodeSingularBytesField(value: &self._receipt)
      case 2: try decoder.decodeSingularUInt64Field(value: &self._cumgas)
      default: break
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if let v = self._receipt {
      try visitor.visitSingularBytesField(value: v, fieldNumber: 1)
    }
    if let v = self._cumgas {
      try visitor.visitSingularUInt64Field(value: v, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ProtoTransactionReceipt, rhs: ProtoTransactionReceipt) -> Bool {
    if lhs._receipt != rhs._receipt {return false}
    if lhs._cumgas != rhs._cumgas {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension ProtoTransactionWithReceipt: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  public static let protoMessageName: String = "ProtoTransactionWithReceipt"
  public static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "transaction"),
    2: .same(proto: "receipt"),
  ]

  fileprivate class _StorageClass {
    var _transaction: ProtoTransaction? = nil
    var _receipt: ProtoTransactionReceipt? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _transaction = source._transaction
      _receipt = source._receipt
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  public var isInitialized: Bool {
    return withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._transaction, !v.isInitialized {return false}
      return true
    }
  }

  public mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        switch fieldNumber {
        case 1: try decoder.decodeSingularMessageField(value: &_storage._transaction)
        case 2: try decoder.decodeSingularMessageField(value: &_storage._receipt)
        default: break
        }
      }
    }
  }

  public func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if let v = _storage._transaction {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
      }
      if let v = _storage._receipt {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  public static func ==(lhs: ProtoTransactionWithReceipt, rhs: ProtoTransactionWithReceipt) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._transaction != rhs_storage._transaction {return false}
        if _storage._receipt != rhs_storage._receipt {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}