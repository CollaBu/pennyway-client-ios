
import SwiftUI

enum DynamicSizeFactor {
    static func factor() -> CGFloat {
        let height = UIScreen.main.bounds.size.height
        var factor: CGFloat = 1.25 // 기본값

        switch height {
        case 480.0: // Iphone 3,4S => 3.5 inch
            factor = 1.1
        case 568.0: // iphone 5, SE => 4 inch
            factor = 1.15
        case 667.0: // iphone 6, 6s, 7, 8 => 4.7 inch
            factor = 1.15
        case 736.0: // iphone 6s+ 6+, 7+, 8+ => 5.5 inch
            factor = 1.2
        case 812.0: // iphone X, XS => 5.8 inch, 13 mini, 12, mini
            factor = 1.23
        case 844.0: // iphone 15, iphone 14, iphone 13 pro, iphone 13, 12 pro, 12
            factor = 1.25
        case 852.0: // iphone 14 pro, iphone 15 pro
            factor = 1.25
        case 926.0: // iphone 14 plus, iphone 13 pro max, 12 pro max
            factor = 1.3
        case 896.0: // iphone XR => 6.1 inch  // iphone XS MAX => 6.5 inch, 11 pro max, 11
            factor = 1.3
        case 932.0: // iPhone14 Pro Max
            factor = 1.33
        default:
            factor = 1.25
        }
        return factor
    }
}
