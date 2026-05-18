import Foundation
import SwiftData

enum ProfileSeedService {
    static func seedDefaultProfileIfNeeded(in modelContext: ModelContext) throws {
        let descriptor = FetchDescriptor<UserProfile>()
        let existingCount = try modelContext.fetchCount(descriptor)

        guard existingCount == 0 else { return }

        modelContext.insert(UserProfile())
        try modelContext.save()
    }
}
