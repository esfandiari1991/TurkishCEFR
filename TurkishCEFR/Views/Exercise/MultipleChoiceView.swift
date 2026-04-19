import SwiftUI

struct MultipleChoiceView: View {
    let question: MultipleChoiceQuestion
    let tint: Color
    /// Called once when the player finishes. Parameter = true if they got it
    /// right on the first attempt (no "Try Again").
    let onComplete: (Bool) -> Void

    @State private var selected: Int?
    @State private var submitted: Bool = false
    @State private var attempts: Int = 0

    private var isCorrect: Bool { selected == question.correctIndex }

    var body: some View {
        VStack(spacing: 24) {
            Text(question.prompt)
                .font(.system(size: 24, weight: .semibold, design: .serif))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
                .padding(.top, 32)

            VStack(spacing: 12) {
                ForEach(Array(question.choices.enumerated()), id: \.offset) { i, choice in
                    ChoiceButton(text: choice,
                                 state: state(for: i),
                                 tint: tint) {
                        guard !submitted else { return }
                        selected = i
                    }
                }
            }
            .padding(.horizontal, 40)

            Spacer(minLength: 0)

            if submitted {
                ResultBanner(isCorrect: isCorrect,
                             explanation: question.explanation,
                             tint: tint)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }

            HStack(spacing: 16) {
                if submitted {
                    Button("Try Again") {
                        selected = nil
                        withAnimation { submitted = false }
                    }
                    Button {
                        onComplete(isCorrect && attempts == 1)
                    } label: {
                        Label("Done", systemImage: "checkmark")
                            .frame(minWidth: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(tint)
                } else {
                    Button {
                        guard selected != nil else { return }
                        attempts += 1
                        withAnimation(.spring()) { submitted = true }
                    } label: {
                        Label("Check", systemImage: "checkmark.circle")
                            .frame(minWidth: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(tint)
                    .disabled(selected == nil)
                }
            }
            .padding(.bottom, 30)
        }
    }

    private func state(for i: Int) -> ChoiceState {
        guard submitted else { return selected == i ? .selected : .normal }
        if i == question.correctIndex { return .correct }
        if i == selected { return .wrong }
        return .dim
    }
}

enum ChoiceState { case normal, selected, correct, wrong, dim }

private struct ChoiceButton: View {
    let text: String
    let state: ChoiceState
    let tint: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                Text(text)
                    .font(.title3)
                Spacer()
                iconView
            }
            .padding(16)
            .background(backgroundStyle, in: RoundedRectangle(cornerRadius: 14))
            .overlay(RoundedRectangle(cornerRadius: 14)
                .stroke(borderColor, lineWidth: state == .selected ? 2 : 1))
            .opacity(state == .dim ? 0.5 : 1)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    private var iconView: some View {
        switch state {
        case .correct: Image(systemName: "checkmark.circle.fill").foregroundStyle(.green)
        case .wrong: Image(systemName: "xmark.circle.fill").foregroundStyle(.red)
        case .selected: Image(systemName: "circle.inset.filled").foregroundStyle(tint)
        default: Image(systemName: "circle").foregroundStyle(.secondary)
        }
    }

    private var backgroundStyle: AnyShapeStyle {
        switch state {
        case .correct: return AnyShapeStyle(Color.green.opacity(0.15))
        case .wrong: return AnyShapeStyle(Color.red.opacity(0.15))
        case .selected: return AnyShapeStyle(tint.opacity(0.12))
        default: return AnyShapeStyle(.regularMaterial)
        }
    }

    private var borderColor: Color {
        switch state {
        case .correct: return .green.opacity(0.6)
        case .wrong: return .red.opacity(0.6)
        case .selected: return tint
        default: return .white.opacity(0.1)
        }
    }
}

struct ResultBanner: View {
    let isCorrect: Bool
    let explanation: String?
    let tint: Color

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 8) {
                Image(systemName: isCorrect ? "star.circle.fill" : "info.circle.fill")
                    .foregroundStyle(isCorrect ? .green : .orange)
                Text(isCorrect ? "Harika!" : "Tekrar dene")
                    .font(.headline)
            }
            if let e = explanation {
                Text(e).font(.subheadline).foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(14)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 40)
    }
}
