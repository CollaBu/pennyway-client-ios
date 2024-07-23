
import SwiftUI

class MapCategoryIconUtil{
    
    static func mapToCategoryIcon(_ icon: CategoryIconName, outputState: IconState) -> CategoryIconName{
        return CategoryIconName(baseName: icon.baseName, state: outputState)
    }
}
