
import SwiftUI

extension String {
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
  
    private func _makeAttributeText(
        text: String, attribute: StringAttributeProtocol
    ) -> Text {
        if #available(iOS 17.0, *) {
            return Text(text)
                .font(attribute.font)
                .foregroundColor(attribute.color)
        } else {
            return Text(text)
                .font(attribute.font)
                .foregroundColor(attribute.color)
        }
    }
}
