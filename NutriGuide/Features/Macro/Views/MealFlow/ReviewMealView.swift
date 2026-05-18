import SwiftUI

struct ReviewMealView: View {
    @Environment(\.dismiss) private var dismiss

    let photo: CapturedMealPhoto
    let onDiscard: () -> Void
    let onRetakePhoto: () -> Void
    let onSave: (ReviewMealDraft) -> Void

    @State private var viewModel: ReviewMealViewModel

    init(
        photo: CapturedMealPhoto,
        initialDraft: ReviewMealDraft,
        onDiscard: @escaping () -> Void,
        onRetakePhoto: @escaping () -> Void,
        onSave: @escaping (ReviewMealDraft) -> Void
    ) {
        self.photo = photo
        _viewModel = State(initialValue: ReviewMealViewModel(initialDraft: initialDraft))
        self.onDiscard = onDiscard
        self.onRetakePhoto = onRetakePhoto
        self.onSave = onSave
    }

    var body: some View {
        @Bindable var viewModel = viewModel

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
        .colorScheme(.light)
        .background(NutriColors.cream.ignoresSafeArea())
        .confirmationDialog(
            "Discard this analysis?",
            isPresented: $viewModel.showsDiscardConfirmation,
            titleVisibility: .visible
        ) {
            Button("Discard", role: .destructive, action: onDiscard)
            Button("Continue editing", role: .cancel) {}
        }
        .sheet(isPresented: $viewModel.isEditingIngredients) {
            IngredientDraftEditorSheet(ingredients: $viewModel.draft.ingredients)
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
                        action: { viewModel.showsDiscardConfirmation = true }
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
                Text("\(viewModel.draft.loggedAt.metadataDayText()) • \(viewModel.draft.loggedAt.mealTimeText())")
            } icon: {
                Image(systemName: viewModel.draft.mealType.foodSymbol)
                    .foregroundStyle(viewModel.draft.mealType.iconForeground)
            }
            .font(NutriTypography.captionSemibold)
            .foregroundStyle(NutriColors.textMuted)

            titleBlock
            caloriesBlock
        }
        .colorScheme(.light)
        .frame(maxWidth: .infinity)
    }

    @ViewBuilder
    private var titleBlock: some View {
        if viewModel.isEditingTitle {
            HStack(spacing: 10) {
                TextField("Meal name", text: $viewModel.draft.name)
                    .font(NutriTypography.body)
                    .foregroundStyle(NutriColors.text)
                    .tint(NutriColors.olive)
                    .textFieldStyle(.plain)
                    .submitLabel(.done)
                    .onSubmit { closeTitleEditor() }

                Button("Done") {
                    closeTitleEditor()
                }
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.olive)
            }
            .padding(14)
            .background(NutriColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        } else {
            Button {
                openTitleEditor()
            } label: {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(viewModel.draft.name)
                        .font(NutriTypography.mealTitle)
                        .foregroundStyle(NutriColors.oliveDark)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .minimumScaleFactor(0.82)

                    Image(systemName: "pencil")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(NutriColors.olive)
                }
            }
            .buttonStyle(.plain)
        }
    }

    @ViewBuilder
    private var caloriesBlock: some View {
        if viewModel.isEditingCalories {
            HStack(spacing: 10) {
                Text("Calories")
                    .font(NutriTypography.bodySemibold)
                    .foregroundStyle(NutriColors.text)

                Spacer()

                TextField("Calories", value: $viewModel.draft.calories, format: .number.precision(.fractionLength(0)))
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.trailing)
                    .font(NutriTypography.body)
                    .foregroundStyle(NutriColors.text)
                    .tint(NutriColors.olive)
                    .frame(width: 90)
                    .submitLabel(.done)
                    .onSubmit { closeCaloriesEditor() }

                Text("kcal")
                    .font(NutriTypography.caption)
                    .foregroundStyle(NutriColors.textMuted)

                Button("Done") {
                    closeCaloriesEditor()
                }
                .font(NutriTypography.captionSemibold)
                .foregroundStyle(NutriColors.olive)
            }
            .padding(14)
            .background(NutriColors.surface)
            .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
        } else {
            Button {
                openCaloriesEditor()
            } label: {
                HStack(alignment: .firstTextBaseline, spacing: 6) {
                    Text(viewModel.draft.calories.formatted(.number.precision(.fractionLength(0))))
                        .font(.system(size: 52, weight: .regular, design: .serif))
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

    private var macroSection: some View {
        VStack(spacing: 12) {
            HStack(spacing: 10) {
                macroButton(kind: .protein, value: viewModel.draft.protein, tint: NutriColors.protein)
                macroButton(kind: .fat, value: viewModel.draft.fat, tint: NutriColors.fat)
                macroButton(kind: .carbs, value: viewModel.draft.carbs, tint: NutriColors.carbs)
            }

            if let editingMacro = viewModel.editingMacro {
                HStack(spacing: 10) {
                    Text(editingMacro.title)
                        .font(NutriTypography.bodySemibold)
                        .foregroundStyle(NutriColors.text)

                    Spacer()

                    TextField(editingMacro.title, value: $viewModel.temporaryMacroValue, format: .number.precision(.fractionLength(0)))
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
            viewModel.isEditingIngredients = true
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

                ForEach(Array(viewModel.draft.ingredients.prefix(4))) { ingredient in
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

            HStack {
                ForEach(MealType.allCases) { mealType in
                    NutriFilterChip(
                        title: mealType.title,
                        isSelected: viewModel.draft.mealType == mealType,
                        action: { viewModel.draft.mealType = mealType }
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }
        .nutriSurfaceCard()
    }

    private var bottomSave: some View {
        NutriPrimaryButton(title: "Save", systemImage: "checkmark") {
            onSave(viewModel.draft)
        }
        .padding(.horizontal, 20)
        .padding(.top, 14)
        .padding(.bottom, 24)
        .background(.ultraThinMaterial)
    }

    private func macroButton(kind: MacroKind, value: Double, tint: Color) -> some View {
        Button {
            beginMacroEdit(kind: kind, value: value)
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

    private func openTitleEditor() {
        withAnimation(.snappy(duration: 0.22)) {
            viewModel.isEditingTitle = true
            viewModel.isEditingCalories = false
        }
    }

    private func closeTitleEditor() {
        withAnimation(.snappy(duration: 0.22)) {
            viewModel.isEditingTitle = false
        }
    }

    private func openCaloriesEditor() {
        withAnimation(.snappy(duration: 0.22)) {
            viewModel.isEditingCalories = true
            viewModel.isEditingTitle = false
        }
    }

    private func closeCaloriesEditor() {
        withAnimation(.snappy(duration: 0.22)) {
            viewModel.isEditingCalories = false
        }
    }

    private func beginMacroEdit(kind: MacroKind, value: Double) {
        withAnimation(.snappy(duration: 0.22)) {
            viewModel.beginMacroEdit(kind: kind, value: value)
        }
    }

    private func applyMacroEdit() {
        withAnimation(.snappy(duration: 0.22)) {
            viewModel.applyMacroEdit()
        }
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
