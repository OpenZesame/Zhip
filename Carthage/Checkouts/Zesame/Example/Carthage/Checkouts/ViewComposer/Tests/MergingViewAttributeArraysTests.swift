//
//  MergingViewAttributeArraysTests.swift
//  ViewComposer
//
//  Created by Alexander Cyon on 2017-06-01.
//
//

import XCTest
@testable import ViewComposer

class MergeResultingInAttributeArrayTests: XCTestCase {
    func testMergeCountMasterArray() {
        let attr1: [ViewAttribute] = [.text(text), .color(color)]
        let attr2: [ViewAttribute] = [.hidden(isHidden)]
        let mergeMaster2: ViewStyle = attr1.merge(master: attr2) // declaring type is not needed
        XCTAssert(mergeMaster2.count == 3)
        let mergeMaster1 = attr2.merge(master: attr1)
        XCTAssert(type(of: mergeMaster1) == ViewStyle.self)
        XCTAssert(mergeMaster1.count == 3)
    }
    
    func testMergeCountSlaveArray() {
        let attr1: [ViewAttribute] = [.text(text), .color(color)]
        let attr2: [ViewAttribute] = [.hidden(isHidden)]
        let mergeSlave2 = attr1.merge(slave: attr2)
        XCTAssert(mergeSlave2.count == 3)
        let mergeSlave1 = attr2.merge(slave: attr1)
        XCTAssert(mergeSlave1.count == 3)
    }
    
    func testMergeOperatorCountMasterArray() {
        let attr1: [ViewAttribute] = [.text(text), .color(color)]
        let attr2: [ViewAttribute] = [.hidden(isHidden)]
        let mergeMaster2 = attr1 <<- attr2
        XCTAssert(mergeMaster2.count == 3)
        let mergeMaster1 = attr2 <<- attr1
        XCTAssert(mergeMaster1.count == 3)
    }
    
    func testMergeOperatorCountSlaveArray() {
        let attr1: [ViewAttribute] = [.text(text), .color(color)]
        let attr2: [ViewAttribute] = [.hidden(isHidden)]
        let mergeSlave2 = attr1 <- attr2
        XCTAssert(mergeSlave2.count == 3)
        let mergeSlave1 = attr2 <- attr1
        XCTAssert(mergeSlave1.count == 3)
    }
    
    func testMergeArrays() {
        let fooAttr: [ViewAttribute] = [.text(fooText), .color(color)]
        let barAttr: [ViewAttribute] = [.text(barText), .hidden(isHidden)]
        let fooMasterUsingSlave = fooAttr.merge(slave: barAttr)
        let fooMasterUsingMaster = barAttr.merge(master: fooAttr)
        let barMasterUsingSlave = barAttr.merge(slave: fooAttr)
        let barMasterUsingMaster = fooAttr.merge(master: barAttr)
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.color))
            XCTAssert(attributes.contains(.hidden))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == fooText)
        XCTAssert(barMasterUsingSlave.associatedValue(.text) == barText)
        XCTAssert(barMasterUsingMaster.associatedValue(.text) == barText)
    }
    
    func testMergeArraysOperators() {
        let fooAttr: [ViewAttribute] = [.text(fooText), .color(color)]
        let barAttr: [ViewAttribute] = [.text(barText), .hidden(isHidden)]
        let fooMasterUsingSlave = fooAttr <- barAttr
        let fooMasterUsingMaster = barAttr <<- fooAttr
        let barMasterUsingSlave = barAttr <- fooAttr
        let barMasterUsingMaster = fooAttr <<- barAttr
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.color))
            XCTAssert(attributes.contains(.hidden))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == fooText)
        XCTAssert(barMasterUsingSlave.associatedValue(.text) == barText)
        XCTAssert(barMasterUsingMaster.associatedValue(.text) == barText)
    }
    
    func testMergeArraysByLiteralsOperators() {
        let fooMasterUsingSlave = [.text(fooText), .color(color)] <- [.text(barText), .hidden(isHidden)]
        let fooMasterUsingMaster = [.text(barText), .hidden(isHidden)] <<- [.text(fooText), .color(color)]
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.color))
            XCTAssert(attributes.contains(.hidden))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == fooText)
    }
    
    func testMergeArraysTwoDoublets() {
        let fooAttr: [ViewAttribute] = [.text(fooText), .cornerRadius(fooRadius)]
        let barAttr: [ViewAttribute] = [.text(barText), .cornerRadius(barRadius)]
        let fooMasterUsingSlave = fooAttr.merge(slave: barAttr)
        let fooMasterUsingMaster = barAttr.merge(master: fooAttr)
        let barMasterUsingSlave = barAttr.merge(slave: fooAttr)
        let barMasterUsingMaster = fooAttr.merge(master: barAttr)
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == fooText)
        XCTAssert(barMasterUsingSlave.associatedValue(.text) == barText)
        XCTAssert(barMasterUsingMaster.associatedValue(.text) == barText)
        
        XCTAssert(fooMasterUsingSlave.associatedValue(.cornerRadius) == fooRadius)
        XCTAssert(fooMasterUsingMaster.associatedValue(.cornerRadius) == fooRadius)
        XCTAssert(barMasterUsingSlave.associatedValue(.cornerRadius) == barRadius)
        XCTAssert(barMasterUsingMaster.associatedValue(.cornerRadius) == barRadius)
    }
    
    func testMergeArraysTwoDoubletsOperators() {
        let fooAttr: [ViewAttribute] = [.text(fooText), .cornerRadius(fooRadius)]
        let barAttr: [ViewAttribute] = [.text(barText), .cornerRadius(barRadius)]
        let fooMasterUsingSlave = fooAttr <- barAttr
        let fooMasterUsingMaster = barAttr <<- fooAttr
        let barMasterUsingSlave = barAttr <- fooAttr
        let barMasterUsingMaster = fooAttr <<- barAttr
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooMasterUsingMaster.associatedValue(.text) == fooText)
        XCTAssert(barMasterUsingSlave.associatedValue(.text) == barText)
        XCTAssert(barMasterUsingMaster.associatedValue(.text) == barText)
        
        XCTAssert(fooMasterUsingSlave.associatedValue(.cornerRadius) == fooRadius)
        XCTAssert(fooMasterUsingMaster.associatedValue(.cornerRadius) == fooRadius)
        XCTAssert(barMasterUsingSlave.associatedValue(.cornerRadius) == barRadius)
        XCTAssert(barMasterUsingMaster.associatedValue(.cornerRadius) == barRadius)
    }
    
    func testMergeArraysOneIsEmpty() {
        let fooAttr: [ViewAttribute] = [.text(fooText), .cornerRadius(fooRadius)]
        let barAttr: [ViewAttribute] = []
        let fooMasterUsingSlave = fooAttr.merge(slave: barAttr)
        let fooMasterUsingMaster = barAttr.merge(master: fooAttr)
        let barMasterUsingSlave = barAttr.merge(slave: fooAttr)
        let barMasterUsingMaster = fooAttr.merge(master: barAttr)
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == fooText)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeArraysOperatorOneIsEmpty() {
        let fooAttr: [ViewAttribute] = [.text(fooText), .cornerRadius(fooRadius)]
        let barAttr: [ViewAttribute] = []
        let fooMasterUsingSlave = fooAttr <- barAttr
        let fooMasterUsingMaster = barAttr <<- fooAttr
        let barMasterUsingSlave = barAttr <- fooAttr
        let barMasterUsingMaster = fooAttr <<- barAttr
        let attrs = [fooMasterUsingSlave, fooMasterUsingMaster, barMasterUsingSlave, barMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == fooText)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeArrayWithSingleAttribute() {
        let array: [ViewAttribute] = [.text(fooText), .cornerRadius(fooRadius)]
        let single: ViewAttribute = .color(color)
        let arrayIsMasterUsingSlave = array.merge(slave: single)
        let arrayIsMasterUsingMaster = single.merge(master: array)
        let singleAttributeIsMasterUsingSlave = single.merge(slave: array)
        let singleAttributeIsMasterUsingMaster = array.merge(master: single)
        let attrs = [arrayIsMasterUsingSlave, arrayIsMasterUsingMaster, singleAttributeIsMasterUsingSlave, singleAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.contains(.color))
            XCTAssert(attributes.associatedValue(.text) == fooText)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeOperatorArrayWithSingleAttribute() {
        let array: [ViewAttribute] = [.text(fooText), .cornerRadius(fooRadius)]
        let single: ViewAttribute = .color(color)
        let arrayIsMasterUsingSlave = array <- single
        let arrayIsMasterUsingMaster = single <<- array
        let singleAttributeIsMasterUsingSlave = single <- array
        let singleAttributeIsMasterUsingMaster = array <<- single
        let attrs = [arrayIsMasterUsingSlave, arrayIsMasterUsingMaster, singleAttributeIsMasterUsingSlave, singleAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 3)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.contains(.color))
            XCTAssert(attributes.associatedValue(.text) == fooText)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeLhsEmptyArrayRhsSingleAttribute() {
        let array: [ViewAttribute] = []
        let single: ViewAttribute = .text(fooText)
        let arrayIsMasterUsingSlave = array.merge(slave: single)
        let arrayIsMasterUsingMaster = single.merge(master: array)
        let singleAttributeIsMasterUsingSlave = single.merge(slave: array)
        let singleAttributeIsMasterUsingMaster = array.merge(master: single)
        let attrs = [arrayIsMasterUsingSlave, arrayIsMasterUsingMaster, singleAttributeIsMasterUsingSlave, singleAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 1)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == fooText)
        }
    }
    
    func testMergeOperatorLhsEmptyArrayRhsSingleAttribute() {
        let array: [ViewAttribute] = []
        let single: ViewAttribute = .text(fooText)
        let arrayIsMasterUsingSlave = array <- single
        let arrayIsMasterUsingMaster = single <<- array
        let singleAttributeIsMasterUsingSlave = single <- array
        let singleAttributeIsMasterUsingMaster = array <<- single
        let attrs = [arrayIsMasterUsingSlave, arrayIsMasterUsingMaster, singleAttributeIsMasterUsingSlave, singleAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 1)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == fooText)
        }
    }
    
    func testMergeArrayWithSingleAttributeDoublets() {
        let fooArray: [ViewAttribute] = [.text(fooText), .cornerRadius(fooRadius)]
        let barSingle: ViewAttribute = .text(barText)
        let fooIsMasterUsingSlave = fooArray.merge(slave: barSingle)
        let fooIsMasterUsingMaster = barSingle.merge(master: fooArray)
        let barAttributeIsMasterUsingSlave = barSingle.merge(slave: fooArray)
        let barAttributeIsMasterUsingMaster = fooArray.merge(master: barSingle)
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooIsMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooIsMasterUsingMaster.associatedValue(.text) == fooText)
        XCTAssert(barAttributeIsMasterUsingSlave.associatedValue(.text) == barText)
        XCTAssert(barAttributeIsMasterUsingMaster.associatedValue(.text) == barText)
    }
    
    func testMergeOperatorArrayWithSingleAttributeDoublets() {
        let fooArray: [ViewAttribute] = [.text(fooText), .cornerRadius(fooRadius)]
        let barSingle: ViewAttribute = .text(barText)
        let fooIsMasterUsingSlave = fooArray <- barSingle
        let fooIsMasterUsingMaster = barSingle <<- fooArray
        let barAttributeIsMasterUsingSlave = barSingle <- fooArray
        let barAttributeIsMasterUsingMaster = fooArray <<- barSingle
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooIsMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooIsMasterUsingMaster.associatedValue(.text) == fooText)
        XCTAssert(barAttributeIsMasterUsingSlave.associatedValue(.text) == barText)
        XCTAssert(barAttributeIsMasterUsingMaster.associatedValue(.text) == barText)
    }
    
    func testMergeSinglesNoDoublets() {
        let fooAttribute: ViewAttribute = .cornerRadius(fooRadius)
        let barAttribute: ViewAttribute = .text(barText)
        let fooIsMasterUsingSlave = fooAttribute.merge(slave: barAttribute)
        let fooIsMasterUsingMaster = barAttribute.merge(master: fooAttribute)
        let barAttributeIsMasterUsingSlave = barAttribute.merge(slave: fooAttribute)
        let barAttributeIsMasterUsingMaster = fooAttribute.merge(master: barAttribute)
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == barText)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeOperatorSinglesNoDoublets() {
        let fooAttribute: ViewAttribute = .cornerRadius(fooRadius)
        let barAttribute: ViewAttribute = .text(barText)
        let fooIsMasterUsingSlave = fooAttribute <- barAttribute
        let fooIsMasterUsingMaster = barAttribute <<- fooAttribute
        let barAttributeIsMasterUsingSlave = barAttribute <- fooAttribute
        let barAttributeIsMasterUsingMaster = fooAttribute <<- barAttribute
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 2)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.cornerRadius))
            XCTAssert(attributes.contains(.text))
            XCTAssert(attributes.associatedValue(.text) == barText)
            XCTAssert(attributes.associatedValue(.cornerRadius) == fooRadius)
        }
    }
    
    func testMergeSinglesDoublets() {
        let fooAttribute: ViewAttribute = .text(fooText)
        let barAttribute: ViewAttribute = .text(barText)
        let fooIsMasterUsingSlave = fooAttribute.merge(slave: barAttribute)
        let fooIsMasterUsingMaster = barAttribute.merge(master: fooAttribute)
        let barAttributeIsMasterUsingSlave = barAttribute.merge(slave: fooAttribute)
        let barAttributeIsMasterUsingMaster = fooAttribute.merge(master: barAttribute)
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 1)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooIsMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooIsMasterUsingMaster.associatedValue(.text) == fooText)
        XCTAssert(barAttributeIsMasterUsingSlave.associatedValue(.text) == barText)
        XCTAssert(barAttributeIsMasterUsingMaster.associatedValue(.text) == barText)
    }
    
    func testMergeOperatorSinglesDoublets() {
        let fooAttribute: ViewAttribute = .text(fooText)
        let barAttribute: ViewAttribute = .text(barText)
        let fooIsMasterUsingSlave = fooAttribute <- barAttribute
        let fooIsMasterUsingMaster = barAttribute <<- fooAttribute
        let barAttributeIsMasterUsingSlave = barAttribute <- fooAttribute
        let barAttributeIsMasterUsingMaster = fooAttribute <<- barAttribute
        let attrs = [fooIsMasterUsingSlave, fooIsMasterUsingMaster, barAttributeIsMasterUsingSlave, barAttributeIsMasterUsingMaster]
        for attributes in attrs {
            XCTAssert(attributes.count == 1)
            XCTAssert(type(of: attributes) == ViewStyle.self)
            XCTAssert(attributes.contains(.text))
        }
        XCTAssert(fooIsMasterUsingSlave.associatedValue(.text) == fooText)
        XCTAssert(fooIsMasterUsingMaster.associatedValue(.text) == fooText)
        XCTAssert(barAttributeIsMasterUsingSlave.associatedValue(.text) == barText)
        XCTAssert(barAttributeIsMasterUsingMaster.associatedValue(.text) == barText)
    }
}

