import Foundation

// C1 — Advanced. Scaffold.
enum C1Content {
    static let lessons: [Lesson] = [
        Lesson(
            id: "c1-subordination",
            level: .c1,
            number: 1,
            titleTR: "Ortaç ve Ulaç Yapıları",
            titleEN: "Participles & Converbs",
            summary: "Build complex sentences with participles (-An, -DIK, -AcAK) and converbs (-erek, -ince, -dikten sonra).",
            systemImage: "link.circle.fill",
            vocabulary: [],
            grammar: [
                GrammarNote(
                    title: "Relative clauses with -An / -DIK",
                    explanation: "Turkish relative clauses precede the noun and use participial forms. 'gelen adam' — the man who came. 'okuduğum kitap' — the book that I read.",
                    examples: [
                        Phrase("Dün gördüğüm film çok güzeldi.", "The film I saw yesterday was very nice.")
                    ]
                )
            ],
            phrases: [],
            exercises: []
        ),
        Lesson(
            id: "c1-evidentiality",
            level: .c1,
            number: 2,
            titleTR: "Duyulan Geçmiş Zaman: -mIş",
            titleEN: "Evidential / Reported Past",
            summary: "Report hearsay, indirect knowledge, and inferred events.",
            systemImage: "bubble.left.and.bubble.right.fill",
            vocabulary: [],
            grammar: [
                GrammarNote(
                    title: "-mIş for hearsay and inference",
                    explanation: "'gelmiş' — apparently he came / I hear he came. Compare with -dI (direct witness).",
                    examples: [
                        Phrase("Ali Ankara'ya gitmiş.", "Apparently Ali went to Ankara.")
                    ]
                )
            ],
            phrases: [],
            exercises: []
        )
    ]
}
