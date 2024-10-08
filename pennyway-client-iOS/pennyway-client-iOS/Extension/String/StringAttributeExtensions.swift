
import SwiftUI

extension String {
    /// 전체 텍스트와 특정 텍스트 조합하여 만들기
    public func toAttributesText(
        base: BaseAttribute,
        _ attribute: StringAttribute
    ) -> Text {
        var text = Text("")
        let parsingStr = components(separatedBy: attribute.text)

        for (index, str) in parsingStr.enumerated() {
            let appendText = _makeAttributeText(text: str, attribute: base)
            text = text + appendText

            if index == (parsingStr.count - 1) {
                continue
            }

            let attributeText = _makeAttributeText(
                text: attribute.text,
                attribute: attribute
            )

            text = text + attributeText
        }

        return text
    }

    /// font와 color 지정한 Text 반환
    private func _makeAttributeText(
        text: String, attribute: StringAttributeProtocol
    ) -> Text {
        if #available(iOS 17.0, *) {
            return Text(text)
                .font(attribute.font)
                .foregroundStyle(attribute.color)
        } else {
            return Text(text)
                .font(attribute.font)
                .foregroundColor(attribute.color)
        }
    }
}
