import SwiftUI

struct ListeningExerciseView: View {
    let prompt: ListeningPrompt
    let tint: Color
    let onComplete: (Bool) -> Void

    @State private var input: String = ""
    @State private var submitted: Bool = false
    @State private var attempts: Int = 0
    @State private var showTranslation: Bool = false
    @State private var wavePhase: CGFloat = 0

    private var isCorrect: Bool {
        Self.normalize(input) == Self.normalize(prompt.turkish)
    }

    var body: some View {
        VStack(spacing: 22) {
            Text("Listen & type what you hear")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.top, 26)

            Button {
                Speech.shared.speak(prompt.turkish)
                withAnimation(.linear(duration: 0.8).repeatForever(autoreverses: true)) {
                    wavePhase = 1
                }
            } label: {
                ZStack {
                    Circle()
                        .fill(tint.gradient)
                        .frame(width: 120, height: 120)
                        .shadow(color: tint.opacity(0.4), radius: 22, y: 10)
                    Circle()
                        .stroke(tint.opacity(0.35), lineWidth: 4)
                        .frame(width: 150 + wavePhase * 20, height: 150 + wavePhase * 20)
                        .opacity(Double(1.0 - wavePhase * 0.6))
                    Image(systemName: "play.fill")
                        .font(.system(size: 44, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .buttonStyle(.plain)
            .help("Play the Turkish audio")

            HStack(spacing: 10) {
                Button {
                    Speech.shared.speak(prompt.turkish, rate: 0.35)
                } label: {
                    Label("Slower", systemImage: "tortoise.fill")
                }
                Button {
                    Speech.shared.speak(prompt.turkish)
                } label: {
                    Label("Normal", systemImage: "speaker.wave.2.fill")
                }
                Button {
                    showTranslation.toggle()
                } label: {
                    Label(showTranslation ? "Hide translation" : "Show translation",
                          systemImage: showTranslation ? "eye.slash" : "eye")
                }
            }
            .controlSize(.small)

            if showTranslation {
                Text(prompt.english)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }

            TextField("Type the Turkish sentence you hear…", text: $input)
                .textFieldStyle(.roundedBorder)
                .font(.title3)
                .frame(maxWidth: 420)
                .disabled(submitted)
                .onSubmit { check() }

            if let hint = prompt.hint, !submitted {
                Label(hint, systemImage: "lightbulb")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if submitted {
                ResultBanner(isCorrect: isCorrect,
                             explanation: isCorrect
                                ? prompt.english
                                : "Doğrusu: \(prompt.turkish)\n(\(prompt.english))",
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
        .padding(.horizontal, 40)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                Speech.shared.speak(prompt.turkish)
            }
        }
    }

    private func check() {
        guard !input.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        attempts += 1
        withAnimation(.spring()) { submitted = true }
    }

    /// Normalises Turkish text for comparison: lowercased (Turkish-aware),
    /// trimmed, and stripped of punctuation.
    static func normalize(_ s: String) -> String {
        let lower = s.lowercased(with: Locale(identifier: "tr_TR"))
        return lower.unicodeScalars
            .filter { !CharacterSet.punctuationCharacters.contains($0) }
            .reduce(into: "") { $0.append(Character($1)) }
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "\\s+", with: " ", options: .regularExpression)
    }
}
