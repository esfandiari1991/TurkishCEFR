import SwiftUI

/// Central design tokens. Everything visual — spacing, icons, line height,
/// display fonts — resolves through these so we can rebalance the whole app
/// from one place. Sizes were chosen to feel premium on a 15" Retina display:
/// generous breathing room, oversized titles, and icon glyphs that read
/// effortlessly from a metre away.
enum Spacing {
    /// 4 — micro padding, used inside pills/chips.
    static let xxs: CGFloat = 4
    /// 8 — tight padding between label + icon.
    static let xs:  CGFloat = 8
    /// 12 — compact stack gaps.
    static let sm:  CGFloat = 12
    /// 18 — default gap between rows of related content.
    static let md:  CGFloat = 18
    /// 24 — gap between sections.
    static let lg:  CGFloat = 24
    /// 32 — large page padding.
    static let xl:  CGFloat = 32
    /// 44 — hero/header spacing.
    static let xxl: CGFloat = 44
}

enum IconSize {
    /// 12 — micro glyph next to very small text.
    static let small:   CGFloat = 12
    /// 14 — inline with caption text.
    static let caption: CGFloat = 14
    /// 18 — inline with body/title3.
    static let body:    CGFloat = 18
    /// 24 — section headers.
    static let section: CGFloat = 24
    /// 28 — sidebar row glyph (larger than before so tools read from
    /// across the room on a Retina display).
    static let large:   CGFloat = 28
    /// 32 — tool/row leading glyphs.
    static let row:     CGFloat = 32
    /// 40 — prominent display inline with a title.
    static let display: CGFloat = 40
    /// 48 — sidebar category glyphs + lesson cards.
    static let listing: CGFloat = 48
    /// 72 — lesson hero + empty-state glyphs.
    static let hero:    CGFloat = 72
    /// 104 — level overview hero.
    static let displayHero: CGFloat = 104
}

enum LineHeight {
    /// Extra leading used on body copy so dense Turkish grammar reads like
    /// a book page rather than a config file.
    static let body: CGFloat = 6
    static let tight: CGFloat = 3
    static let generous: CGFloat = 9
}

/// Display fonts — designed for the biggest visual titles. SF Pro Rounded
/// gives the "premium modern" feel, serif used for the big Turkish
/// `titleTR` to echo the bookish heritage of the language.
enum DisplayFont {
    /// The biggest heading on a page (lesson / level hero).
    static var title: Font { .system(size: 38, weight: .heavy, design: .rounded) }
    /// The Turkish-language title set in a serif — e.g. lesson `titleTR`.
    static var turkishTitle: Font { .system(size: 36, weight: .bold, design: .serif) }
    /// Sidebar / overview section title.
    static var section: Font { .system(size: 26, weight: .bold, design: .rounded) }
    /// Card title.
    static var card: Font { .system(size: 20, weight: .semibold, design: .rounded) }
    /// Inline bold body.
    static var strong: Font { .system(size: 16, weight: .semibold, design: .rounded) }
    /// Body copy. Slightly larger than .body so grammar rules don't feel cramped.
    static var body: Font { .system(size: 15, weight: .regular) }
    /// Caption — shown under a title. .caption is a touch tight for long text.
    static var caption: Font { .system(size: 12, weight: .regular) }
}

extension View {
    /// Apply a premium display title treatment: heavy rounded font +
    /// subtle tracking that makes capital letters breathe.
    func displayTitle() -> some View {
        self.font(DisplayFont.title)
            .tracking(-0.4)
            .lineSpacing(LineHeight.tight)
    }

    /// Apply the serif Turkish heading style.
    func turkishDisplayTitle() -> some View {
        self.font(DisplayFont.turkishTitle)
            .tracking(-0.2)
            .lineSpacing(LineHeight.tight)
    }

    /// Apply section heading treatment.
    func sectionTitle() -> some View {
        self.font(DisplayFont.section)
            .tracking(-0.2)
    }

    /// Readable body text — slightly larger than default, extra line spacing.
    func readableBody() -> some View {
        self.font(DisplayFont.body)
            .lineSpacing(LineHeight.body)
            .fixedSize(horizontal: false, vertical: true)
    }
}
