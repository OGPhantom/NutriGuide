import Foundation

enum MealFlowDestination: Identifiable {
    case camera
    case analyzing(CapturedMealPhoto)
    case review(CapturedMealPhoto, FoodAnalysisDraft)
    case detail(MealEntry)

    var id: String {
        switch self {
        case .camera:
            "camera"
        case .analyzing(let photo):
            "analyzing-\(photo.id.uuidString)"
        case .review(let photo, _):
            "review-\(photo.id.uuidString)"
        case .detail(let meal):
            "detail-\(meal.id.uuidString)"
        }
    }
}
