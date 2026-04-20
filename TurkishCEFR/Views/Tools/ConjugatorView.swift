import SwiftUI

/// Turkish verb conjugator. Enter any dictionary-form verb (`-mek` / `-mak`)
/// and the app conjugates it across 8 tenses × 6 persons purely from the
/// rules in `TurkishMorphology` — no network, no lookup table.
struct ConjugatorView: View {
    @State private var input: String = "gelmek"
    @State private var focus: TurkishMorphology.Tense? = nil

    private var rows: [(TurkishMorphology.Tense, [(TurkishMorphology.Person, String)])] {
        let all = TurkishMorphology.conjugate(input)
        return TurkishMorphology.Tense.allCases.map { tense in
            (tense, all.filter { $0.tense == tense }.map { ($0.person, $0.form) })
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            header
            Divider()
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    ForEach(rows, id: \.0) { row in
                        tenseCard(row.0, forms: row.1)
                    }
                    Text("Automatic conjugation follows Turkish vowel/consonant harmony rules. Irregulars like *yemek*, *demek* or compounds like *hissetmek* may need manual tweaking.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .padding(.top, 6)
                }
                .padding(22)
            }
        }
        .frame(minWidth: 560, minHeight: 500)
    }

    private var header: some View {
        HStack(spacing: 12) {
            Image(systemName: "wand.and.stars")
                .foregroundStyle(BrandTheme.gold)
            TextField("Enter a Turkish verb (e.g. gelmek, gitmek, yapmak)", text: $input)
                .textFieldStyle(.plain)
                .font(.title3.weight(.semibold))
                .onSubmit { /* triggers redraw */ }
            Button {
                Speech.shared.speak(input)
            } label: {
                Image(systemName: "speaker.wave.2.fill")
            }
            .buttonStyle(.borderless)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 14)
        .background(.regularMaterial)
    }

    private func tenseCard(_ t: TurkishMorphology.Tense, forms: [(TurkishMorphology.Person, String)]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(t.rawValue)
                    .font(.headline)
                Spacer()
                Button {
                    Speech.shared.speak(forms.map(\.1).joined(separator: ", "))
                } label: {
                    Image(systemName: "speaker.wave.2.fill")
                }
                .buttonStyle(.borderless)
            }
            ForEach(forms, id: \.0) { (person, form) in
                HStack(alignment: .firstTextBaseline) {
                    Text(person.rawValue)
                        .font(.system(.body, design: .monospaced))
                        .foregroundStyle(.secondary)
                        .frame(width: 56, alignment: .leading)
                    Text(form)
                        .font(.body.weight(.semibold))
                        .textSelection(.enabled)
                    Spacer()
                    Text(person.english)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(.ultraThinMaterial)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .strokeBorder(.white.opacity(0.08), lineWidth: 1)
        )
    }
}
