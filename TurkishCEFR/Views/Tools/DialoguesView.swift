import SwiftUI

/// Situational dialogue library: 20 role-play conversations with per-line
/// audio playback for both speakers.
struct DialoguesView: View {
    @State private var selected: Dialogue = DialoguesContent.all.first!
    @State private var playingLineID: UUID? = nil

    var body: some View {
        HSplitView {
            sidebar
                .frame(minWidth: 240, idealWidth: 260, maxWidth: 320)
            detail
                .frame(minWidth: 360)
        }
        .frame(minWidth: 720, minHeight: 520)
    }

    private var sidebar: some View {
        List(DialoguesContent.all, selection: Binding(
            get: { selected.id },
            set: { new in
                if let d = DialoguesContent.all.first(where: { $0.id == new }) { selected = d }
            }
        )) { d in
            HStack {
                Image(systemName: d.systemImage)
                    .foregroundStyle(BrandTheme.turquoise)
                VStack(alignment: .leading, spacing: 2) {
                    Text(d.title).font(.body.weight(.medium))
                    Text(d.subtitle).font(.caption).foregroundStyle(.secondary)
                }
                Spacer()
                Text(d.level.rawValue)
                    .font(.caption.weight(.bold))
                    .padding(.horizontal, 6).padding(.vertical, 2)
                    .background(BrandTheme.crimson.opacity(0.18), in: Capsule())
                    .foregroundStyle(BrandTheme.crimson)
            }
            .tag(d.id)
        }
        .listStyle(.sidebar)
    }

    private var detail: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Label(selected.title, systemImage: selected.systemImage)
                        .font(.title2.weight(.semibold))
                    Spacer()
                    Button {
                        playAll()
                    } label: {
                        Label("Play all", systemImage: "play.fill")
                    }
                    .buttonStyle(.borderedProminent)
                }
                Text(selected.subtitle)
                    .font(.callout).foregroundStyle(.secondary)

                ForEach(selected.lines) { line in
                    lineRow(line)
                }
            }
            .padding(24)
        }
    }

    private func lineRow(_ line: Dialogue.Line) -> some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(speakerColor(line.speaker).opacity(0.22))
                    .frame(width: 30, height: 30)
                Text(line.speaker.rawValue)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(speakerColor(line.speaker))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(line.tr)
                    .font(.body.weight(.semibold))
                Text(line.en)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Button {
                Speech.shared.speak(line.tr)
                playingLineID = line.id
            } label: {
                Image(systemName: playingLineID == line.id ? "speaker.wave.3.fill" : "speaker.wave.2.fill")
            }
            .buttonStyle(.borderless)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.ultraThinMaterial)
        )
    }

    private func speakerColor(_ s: Dialogue.Speaker) -> Color {
        s == .a ? BrandTheme.crimson : BrandTheme.turquoise
    }

    private func playAll() {
        // Use the synthesizer's built-in queue so each line plays to
        // completion instead of being cut off by the next asyncAfter tick.
        Speech.shared.speakAll(selected.lines.map(\.tr))
        playingLineID = selected.lines.first?.id
    }
}
