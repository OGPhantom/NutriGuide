import Foundation
import UIKit

struct CapturedMealPhoto: Identifiable, Equatable {
    let id: UUID
    var data: Data

    init(id: UUID = UUID(), data: Data) {
        self.id = id
        self.data = data
    }

    var image: UIImage? {
        UIImage(data: data)
    }
}
