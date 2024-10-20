
import SwiftUI

// MARK: - StringAttributeProtocol

protocol StringAttributeProtocol {
    var font: Font { get }
    var color: Color { get }
}

// MARK: - BaseAttribute

/// 전체 text
public struct BaseAttribute: StringAttributeProtocol {
    let font: Font
    let color: Color

    public init(font: Font, color: Color) {
        self.font = font
        self.color = color
    }
}

// MARK: - StringAttribute

/// 특정 text
public struct StringAttribute: StringAttributeProtocol {
    let text: String
    let font: Font
    let color: Color

    public init(text: String, font: Font, color: Color) {
        self.text = text
        self.font = font
        self.color = color
    }
}
