import SwiftUI

struct FillInBlankView: View {
    let question: FillInBlankQuestion
    let tint: Color
    /// Parameter = true if the user got it right on the first attempt.
    let onComplete: (Bool) -> Void

    @State private var input: String = ""
    @State private var submitted: Bool = false
    @State private var attempts: Int = 0

    private var isCorrect: Bool {
        input.trimmingCharacters(in: .whitespacesAndNewlines)
            .localizedCaseInsensitiveCompare(question.answer) == .orderedSame
    }

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 6) {
                Text("Fill in the blank")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text(question.sentence)
                    .font(.system(size: 28, weight: .semibold, design: .serif))
                    .multilineTextAlignment(.center)
                Text(question.translation)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal, 40)
            .padding(.top, 32)

            TextField("Your answer", text: $input)
                .textFieldStyle(.roundedBorder)
                .font(.title2)
                .frame(maxWidth: 280)
                .disabled(submitted)
                .onSubmit { check() }

            if let hint = question.hint, !submitted {
                Label(hint, systemImage: "lightbulb")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if submitted {
                ResultBanner(isCorrect: isCorrect,
                             explanation: isCorrect
                                ? "Exactly right!"
                                : "The correct answer is: \(question.answer)",
                             tint: tint)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }

            Spacer(minLength: 0)

            HStack(spacing: 16) {
                if submitted {
                    Button("Try Again") {
                        input = ""
                        withAnimation { submitted = false }
                    }
                    Button {
                        onComplete(isCorrect && attempts == 1)
                    } label: {
                        Label("Done", systemImage: "checkmark").frame(minWidth: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(tint)
                } else {
                    Button {
                        check()
                    } label: {
                        Label("Check", systemImage: "checkmark.circle").frame(minWidth: 120)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(tint)
                    .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty)
                }
            }
            .padding(.bottom, 30)
        }
    }

    private func check() {
        guard !input.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        attempts += 1
        withAnimation(.spring()) { submitted = true }
    }
}
