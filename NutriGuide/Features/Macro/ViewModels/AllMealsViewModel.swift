import Foundation

@MainActor
@Observable
final class AllMealsViewModel {
    var searchText = ""
    var selectedFilter: MealTypeFilter = .all
    var selectedMeal: MealEntry?

    func selectMeal(_ meal: MealEntry) {
        selectedMeal = meal
    }

    func sections(from meals: [MealEntry], calendar: Calendar = .current) -> [(Date, [MealEntry])] {
        let grouped = Dictionary(grouping: filteredMeals(from: meals)) { meal in
            calendar.startOfDay(for: meal.loggedAt)
        }

        return grouped
            .map { ($0.key, $0.value.sorted { $0.loggedAt > $1.loggedAt }) }
            .sorted { $0.0 > $1.0 }
    }

    private func filteredMeals(from meals: [MealEntry]) -> [MealEntry] {
        meals.filter { meal in
            filterMatches(meal) && searchMatches(meal)
        }
    }

    private func filterMatches(_ meal: MealEntry) -> Bool {
        switch selectedFilter {
        case .all:
            true
        case .type(let mealType):
            meal.mealType == mealType
        }
    }

    private func searchMatches(_ meal: MealEntry) -> Bool {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return true }

        if meal.name.localizedStandardContains(query) {
            return true
        }

        return meal.ingredients.contains { ingredient in
            ingredient.name.localizedStandardContains(query)
        }
    }
}
