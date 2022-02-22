import XCTest
@testable import ZhipEngine

import SwiftUI

final class ZhipEngineTests: XCTestCase {
    func testTrivial() throws {
        XCTAssertTrue(true)
    }
    
    func testStringIndex() {
        struct TextStateOnwer {
            @State var text: String
        }
        struct TextBindingOwner {
            
            @Binding var text: String
            
            init(text: Binding<String>) {
                self._text = text
            }
            
            init(textStateOnwer: TextStateOnwer) {
                self.init(text: textStateOnwer.$text)
            }
        }
        
        let textStateOnwer = TextStateOnwer(text: "")
        let textBindingOwner = TextBindingOwner(textStateOnwer: textStateOnwer)
 
        let stringIndex = textBindingOwner.text.index(
            textBindingOwner.text.startIndex,
            offsetBy: 1,
            limitedBy: textBindingOwner.text.endIndex
        )
        XCTAssertNil(stringIndex)
    }
}
