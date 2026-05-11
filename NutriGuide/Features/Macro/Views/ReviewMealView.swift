import SwiftUI

struct ReviewMealView: View {
    @Environment(\.dismiss) private var dismiss

    let photo: CapturedMealPhoto
    let onDiscard: () -> Void
    let onRetakePhoto: () -> Void
    let onSave: (ReviewMealDraft) -> Void

    @State private var draft: ReviewMealDraft
    @State private var showsDiscardConfirmation = false
    @State private var isEditingTitle = false
    @State private var isEditingCalories = false
    @State private var isEditingIngredients = false
    @State private var editingMacro: MacroKind?
    @State private var temporaryMacroValue = 0.0

    init(
        photo: CapturedMealPhoto,
        initialDraft: ReviewMealDraft,
        onDiscard: @escaping () -> Void,
        onRetakePhoto: @escaping () -> Void,
        onSave: @escaping (ReviewMealDraft) -> Void
    ) {
        self.photo = photo
        _draft = State(initialValue: initialDraft)
        self.onDiscard = onDiscard
        self.onRetakePhoto = onRetakePhoto
        self.onSave = onSave
    }

    var body: some View {
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    photoSection
                    header
                    macroSection
                    ingredientsSection
                    mealTypeSection
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 116)
            }

            bottomSave
        }
        .background(NutriColors.cream.ignoresSafeArea())
        .confirmationDialog(
            "Discard this analysis?",
            isPresented: $showsDiscardConfirmation,
            titleVisibility: .visible
        ) {
            Button("Discard", role: .destructive, action: onDiscard)
            Button("Continue editing", role: .cancel) {}
        }
        .sheet(isPresented: $isEditingIngredients) {
            IngredientDraftEditorSheet(ingredients: $draft.ingredients)
        }
    }

    private var photoSection: some View {
        ZStack(alignment: .top) {
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 330)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
                    .clipped()
                    .ignoresSafeArea(edges: .top)
            } else {
                Rectangle()
                    .fill(NutriColors.oliveSoft)
                    .frame(height: 330)
                    .overlay {
                        Image(systemName: "photo")
                            .font(.largeTitle)
                            .foregroundStyle(NutriColors.olive)
                    }
                    .ignoresSafeArea(edges: .top)
            }

            VStack {
                HStack {
                    NutriIconButton(
                        title: "Close",
                        systemImage: "xmark",
                        size: 42,
                        action: { showsDiscardConfirmation = true }
                    )

                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.top, 18)

                Spacer()

                Button("Retake photo", systemImage: "camera.rotate") {
                    onRetakePhoto()
                }
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(.white)
                .padding(.horizontal, 14)
                .padding(.vertical, 10)
                .background(NutriColors.cameraControl)
                .clipShape(Capsule())
                .padding(.bottom, 16)
            }
            .frame(height: 330)
        }
        .padding(.horizontal, -20)
    }

    private var header: some View {
        VStack(spacing: 14) {
            Label {
                Text("\(draft.loggedAt.metadataDayText()) • \(draft.loggedAt.mealTimeText())")
            } icon: {
                Image(systemName: draft.mealType.foodSymbol)
                    .foregroundStyle(draft.mealType.iconForeground)
            }
            .font(NutriTypography.captionSemibold)
            .foregroundStyle(NutriColors.textMuted)

            if isEditingTitle {
                TextField("Meal name", text: $draft.name)
                    .font(NutriTypography.screenTitle)
                    .multilineTextAlignment(.center)
                    .textFieldStyle(.plain)
                    .submitLabel(.done)
                    .onSubmit { isEditingTitle = false }
            } else {
                Button {
                    isEditingTitle = true
                } label: {
                    HStack(spacing: 8) {
                        Text(draft.name)
                            .font(NutriTypography.screenTitle)
                            .foregroundStyle(NutriColors.oliveDark)
                            .multilineTextAlignment(.center)

                        Image(systemName: "pencil")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(NutriColors.olive)
                    }
                }
                .buttonStyle(.plain)
            }

            if isEditingCalories {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    TextField("Calories", value: $draft.calories, format: .number.precision(.fractionLength(0)))
                        .font(NutriTypography.largeNumber)
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 140)
                        .onSubmit { isEditingCalories = false }

                    Text("kcal")
                        .font(NutriTypography.body)
                        .foregroundStyle(NutriColors.textMuted)
                }
            } else {
                Button {
                    isEditingCalories = true
                } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 6) {
                        Text(draft.calories.formatted(.number.precision(.fractionLength(0))))
                            .font(NutriTypography.largeNumber)
                            .foregroundStyle(NutriColors.oliveDark)

                        Text("kcal")
                            .font(NutriTypography.body)
                            .foregroundStyle(NutriColors.textMuted)

                        Image(systemName: "pencil")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(NutriColors.olive)
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var macroSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                macroButton(kind: .protein, value: draft.protein, tint: NutriColors.olive)
                macroButton(kind: .fat, value: draft.fat, tint: NutriColors.apricot)
                macroButton(kind: .carbs, value: draft.carbs, tint: Color(hex: 0xE8B14F))
            }

            if let editingMacro {
                HStack(spacing: 10) {
                    Text(editingMacro.title)
                        .font(NutriTypography.bodySemibold)
                        .foregroundStyle(NutriColors.text)

                    Spacer()

                    TextField(editingMacro.title, value: $temporaryMacroValue, format: .number.precision(.fractionLength(0)))
                        .keyboardType(.decimalPad)
                        .multilineTextAlignment(.trailing)
                        .frame(width: 90)

                    Text(editingMacro.unit)
                        .font(NutriTypography.caption)
                        .foregroundStyle(NutriColors.textMuted)

                    Button("Done", action: applyMacroEdit)
                        .font(NutriTypography.captionSemibold)
                        .foregroundStyle(NutriColors.olive)
                }
                .padding(14)
                .background(NutriColors.surface)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
            }
        }
    }

    private var ingredientsSection: some View {
        Button {
            isEditingIngredients = true
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Text("Ingredients")
                        .font(NutriTypography.cardTitle)
                        .foregroundStyle(NutriColors.text)

                    Spacer()

                    Image(systemName: "pencil")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(NutriColors.olive)
                }

                ForEach(Array(draft.ingredients.prefix(4))) { ingredient in
                    HStack {
                        Text(ingredient.name)
                            .font(NutriTypography.bodySemibold)
                            .foregroundStyle(NutriColors.text)

                        Spacer()

                        Text("\(ingredient.amount.portionText) \(ingredient.unit)")
                            .font(NutriTypography.body)
                            .foregroundStyle(NutriColors.textMuted)
                    }
                }
            }
            .nutriSurfaceCard()
        }
        .buttonStyle(.plain)
    }

    private var mealTypeSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Meal type")
                .font(NutriTypography.cardTitle)
                .foregroundStyle(NutriColors.text)

            HStack(spacing: 8) {
                ForEach(MealType.allCases) { mealType in
                    NutriFilterChip(
                        title: mealType.title,
                        isSelected: draft.mealType == mealType,
                        action: { draft.mealType = mealType }
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .nutriSurfaceCard()
    }

    private var bottomSave: some View {
        NutriPrimaryButton(title: "Save", systemImage: "checkmark") {
            onSave(draft)
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 24)
        .background(.ultraThinMaterial)
    }

    private func macroButton(kind: MacroKind, value: Double, tint: Color) -> some View {
        Button {
            editingMacro = kind
            temporaryMacroValue = value
        } label: {
            MacroMetricCard(
                title: kind.title,
                value: value,
                unit: kind.unit,
                tint: tint,
                showsEditAffordance: true
            )
        }
        .buttonStyle(.plain)
    }

    private func applyMacroEdit() {
        switch editingMacro {
        case .protein:
            draft.protein = temporaryMacroValue
        case .fat:
            draft.fat = temporaryMacroValue
        case .carbs:
            draft.carbs = temporaryMacroValue
        case .calories:
            draft.calories = temporaryMacroValue
        case nil:
            break
        }

        editingMacro = nil
    }
}

#Preview {
    ReviewMealView(
        photo: CapturedMealPhoto(data: Data()),
        initialDraft: .preview,
        onDiscard: {},
        onRetakePhoto: {},
        onSave: { _ in }
    )
}
