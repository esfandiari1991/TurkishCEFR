import Foundation

/// Situational Turkish dialogues curated for day-to-day survival.
/// Each dialogue runs 6–12 lines, alternating between two speakers so the
/// audio player can pan or pitch-shift to differentiate them.
struct Dialogue: Identifiable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    let systemImage: String
    let level: CEFRLevel
    let lines: [Line]

    struct Line: Identifiable, Hashable {
        let id = UUID()
        let speaker: Speaker
        let tr: String
        let en: String
    }

    enum Speaker: String, Hashable {
        case a = "A"
        case b = "B"
    }
}

@inline(__always)
private func a(_ tr: String, _ en: String) -> Dialogue.Line {
    Dialogue.Line(speaker: .a, tr: tr, en: en)
}
@inline(__always)
private func b(_ tr: String, _ en: String) -> Dialogue.Line {
    Dialogue.Line(speaker: .b, tr: tr, en: en)
}

enum DialoguesContent {
    static let all: [Dialogue] = [
        Dialogue(id: "d-cafe", title: "At a café", subtitle: "Kafede",
                 systemImage: "cup.and.saucer.fill", level: .a1, lines: [
            a("Merhaba, hoş geldiniz.", "Hello, welcome."),
            b("Hoş bulduk. Bir Türk kahvesi alabilir miyim?", "Thanks. Could I have a Turkish coffee?"),
            a("Tabii. Az şekerli mi, orta mı, sade mi?", "Sure. Low-sugar, medium, or plain?"),
            b("Orta şekerli, lütfen. Yanında su da alır mıyım?", "Medium sweet, please. Can I also get some water?"),
            a("Elbette. Başka bir şey?", "Of course. Anything else?"),
            b("Bir dilim cheesecake de rica ederim.", "A slice of cheesecake too, please."),
            a("Hemen getiriyorum. Afiyet olsun.", "Coming right up. Enjoy!"),
        ]),
        Dialogue(id: "d-taxi", title: "Taking a taxi", subtitle: "Takside",
                 systemImage: "car.fill", level: .a2, lines: [
            a("Merhaba. Taksim'e gider misiniz?", "Hello. Can you go to Taksim?"),
            b("Tabii, buyurun. Yaklaşık yirmi dakika sürer.", "Sure, please. It'll take about twenty minutes."),
            a("Trafik yoğun mu?", "Is traffic heavy?"),
            b("Biraz yoğun ama boğaz yolundan gidelim, daha hızlı.", "A bit heavy, but let's take the Bosphorus road, faster."),
            a("Kartla ödeme kabul ediyor musunuz?", "Do you accept card?"),
            b("Evet, kartla olur. İndiğinizde faturayı verebilirim.", "Yes, card's fine. I can give you the receipt when you get out."),
        ]),
        Dialogue(id: "d-hotel", title: "Hotel check-in", subtitle: "Otelde",
                 systemImage: "bed.double.fill", level: .a2, lines: [
            a("İyi akşamlar, rezervasyonum var. Adım Ali Demir.", "Good evening, I have a reservation. My name is Ali Demir."),
            b("Hoş geldiniz Ali Bey. İki kişilik, üç gece, doğru mu?", "Welcome, Mr. Ali. Double room, three nights, correct?"),
            a("Evet, doğru. Oda numarası nedir?", "Yes, correct. What's the room number?"),
            b("302. Kahvaltı saat yedi ile onbir arası, yedinci katta.", "302. Breakfast is between seven and eleven on the seventh floor."),
            a("Wi-Fi şifresi nedir?", "What's the Wi-Fi password?"),
            b("Odada kartta yazılı. İyi tatiller!", "It's on the card in the room. Enjoy your stay!"),
        ]),
        Dialogue(id: "d-doctor", title: "At the doctor's", subtitle: "Doktorda",
                 systemImage: "stethoscope", level: .b1, lines: [
            a("Şikayetiniz nedir?", "What's bothering you?"),
            b("Üç gündür boğazım ağrıyor ve ateşim var.", "My throat has hurt for three days and I have a fever."),
            a("Ağzınızı açın, bir bakayım. Öksürük var mı?", "Open your mouth, let me look. Do you have a cough?"),
            b("Evet, özellikle geceleri.", "Yes, especially at night."),
            a("Boğaz iltihabı olmuş. Antibiyotik yazıyorum, günde iki kez.", "It's throat inflammation. I'm prescribing antibiotics, twice a day."),
            b("Ne kadar sürede iyileşirim?", "How long until I recover?"),
            a("Beş gün içinde düzelirsiniz. Bol sıvı için.", "You'll be better within five days. Drink plenty of fluids."),
        ]),
        Dialogue(id: "d-airport", title: "At the airport", subtitle: "Havalimanında",
                 systemImage: "airplane", level: .a2, lines: [
            a("İstanbul'a giden uçuşunuzun kapısı B14.", "Your flight to Istanbul boards at gate B14."),
            b("Teşekkür ederim. İniş ne zaman?", "Thank you. When does it land?"),
            a("Saat 18:40'ta İstanbul Havalimanı'na inecek.", "It lands at Istanbul Airport at 18:40."),
            b("El bagajım fazla mı?", "Is my carry-on too heavy?"),
            a("Sekiz kiloya kadar ücretsiz. Şu an yedi buçuk kilo, uygun.", "Up to eight kilos is free. Right now it's seven and a half, fine."),
            b("Harika. Teşekkürler, iyi günler!", "Great. Thanks, have a good day!"),
        ]),
        Dialogue(id: "d-shop", title: "Shopping for clothes", subtitle: "Kıyafet alışverişi",
                 systemImage: "bag.fill", level: .a2, lines: [
            a("Bu gömleğin M bedenini rica etsem?", "Could I have a medium of this shirt?"),
            b("Tabii, renk seçeneklerimiz mavi, siyah ve beyaz.", "Sure, color options are blue, black, and white."),
            a("Mavisini deneyebilir miyim?", "Can I try the blue one?"),
            b("Elbette, kabin arkada.", "Of course, the changing room is at the back."),
            a("Biraz dar geldi. L beden var mı?", "A bit tight. Do you have large?"),
            b("Evet, hemen getiriyorum.", "Yes, I'll grab it right away."),
            a("Teşekkürler. Kartla ödeyebilir miyim?", "Thanks. Can I pay by card?"),
            b("Elbette.", "Of course."),
        ]),
        Dialogue(id: "d-market", title: "At the farmers' market", subtitle: "Pazarda",
                 systemImage: "basket.fill", level: .a1, lines: [
            a("Domates kilosu kaç lira?", "How much per kilo are the tomatoes?"),
            b("Otuz lira, çok taze.", "Thirty liras, very fresh."),
            a("İki kilo alayım. Biber de var mı?", "I'll take two kilos. Got peppers?"),
            b("Tabii, kırmızı ve yeşil var.", "Sure, red and green."),
            a("Yarım kilo kırmızı biber, lütfen.", "Half a kilo of red peppers, please."),
            b("Başka bir şey?", "Anything else?"),
            a("Hayır, teşekkürler. Toplam ne kadar?", "No, thanks. How much in total?"),
            b("Seksen lira olur.", "Eighty liras."),
        ]),
        Dialogue(id: "d-bank", title: "At the bank", subtitle: "Bankada",
                 systemImage: "banknote.fill", level: .b1, lines: [
            a("Hoş geldiniz, nasıl yardımcı olabilirim?", "Welcome, how can I help?"),
            b("Dövizlerimi euro'ya çevirtmek istiyorum.", "I'd like to exchange my currency to euro."),
            a("Ne kadar çevireceksiniz?", "How much will you convert?"),
            b("Beş yüz dolar.", "Five hundred dollars."),
            a("Bugün kur 29,40. Toplam 470 euro olur.", "Today's rate is 29.40. Total would be 470 euros."),
            b("Kimliğimi göstermem gerekiyor mu?", "Do I need to show my ID?"),
            a("Evet, pasaportunuzu alabilir miyim?", "Yes, may I have your passport?"),
        ]),
        Dialogue(id: "d-directions", title: "Asking for directions", subtitle: "Yol sorma",
                 systemImage: "map.fill", level: .a2, lines: [
            a("Affedersiniz, Galata Kulesi nerede?", "Excuse me, where is Galata Tower?"),
            b("Bu caddeden düz gidin, ikinci sokaktan sağa dönün.", "Go straight on this street, turn right at the second street."),
            a("Yürüyerek ne kadar sürer?", "How long does it take on foot?"),
            b("Yaklaşık on dakika.", "About ten minutes."),
            a("Yakınlarda metro var mı?", "Is there a metro nearby?"),
            b("Evet, 'Şişhane' istasyonu beş dakika mesafede.", "Yes, Şişhane station is five minutes away."),
        ]),
        Dialogue(id: "d-phone", title: "Making a phone call", subtitle: "Telefon görüşmesi",
                 systemImage: "phone.fill", level: .b1, lines: [
            a("Alo, iyi günler. Ayşe Hanım'la görüşebilir miyim?", "Hello, good day. May I speak with Ms. Ayşe?"),
            b("Kendisi toplantıda. Kim arıyor acaba?", "She's in a meeting. Who's calling, please?"),
            a("Ben Mehmet Yılmaz. Akşam beni ararsa sevinirim.", "It's Mehmet Yılmaz. I'd appreciate if she called me back this evening."),
            b("Mesajınızı iletirim. Numara aynı mı?", "I'll pass the message. Is the number the same?"),
            a("Evet, aynı. Teşekkür ederim.", "Yes, the same. Thank you."),
            b("Rica ederim, iyi günler.", "You're welcome, good day."),
        ]),
        Dialogue(id: "d-invite", title: "Inviting a friend", subtitle: "Arkadaşı davet etme",
                 systemImage: "party.popper.fill", level: .a2, lines: [
            a("Bu cumartesi doğum günü partisi veriyorum, gelir misin?", "I'm throwing a birthday party this Saturday, will you come?"),
            b("Çok isterim! Saat kaçta?", "I'd love to! What time?"),
            a("Sekizde başlıyor.", "It starts at eight."),
            b("Ne getirmemi istersin?", "What should I bring?"),
            a("Pasta ben alıyorum, sen bir şişe şarap getir.", "I'm getting the cake, you bring a bottle of wine."),
            b("Harika, görüşürüz.", "Great, see you."),
        ]),
        Dialogue(id: "d-workplace", title: "At the office", subtitle: "Ofiste",
                 systemImage: "building.2.fill", level: .b1, lines: [
            a("Toplantı raporunu bitirdin mi?", "Did you finish the meeting report?"),
            b("Hâlâ son bölüm üzerinde çalışıyorum.", "I'm still working on the last section."),
            a("Öğleden sonra iki için hazır olabilir mi?", "Can it be ready by two in the afternoon?"),
            b("Bire kadar taslağı atarım, geri bildirimini beklerim.", "I'll send the draft by one and wait for your feedback."),
            a("Harika. Yardım gerekirse söyle.", "Great. Let me know if you need help."),
        ]),
        Dialogue(id: "d-haircut", title: "At the barber", subtitle: "Berberde",
                 systemImage: "scissors", level: .b1, lines: [
            a("Nasıl istersiniz?", "How would you like it?"),
            b("Yanları kısa, üstü biraz uzun kalsın.", "Short on the sides, leave the top a bit longer."),
            a("Sakalı da düzeltelim mi?", "Shall I trim the beard too?"),
            b("Lütfen, ama çok kısa olmasın.", "Please, but not too short."),
            a("Bitti. Beğendiniz mi?", "Done. Do you like it?"),
            b("Çok güzel oldu, eline sağlık.", "Looks great, well done."),
        ]),
        Dialogue(id: "d-pharmacy", title: "At the pharmacy", subtitle: "Eczanede",
                 systemImage: "cross.case.fill", level: .a2, lines: [
            a("Merhaba, baş ağrım var. Ne önerirsiniz?", "Hello, I have a headache. What do you recommend?"),
            b("Bunu deneyin, günde iki tane, tok karnına.", "Try this, two a day, on a full stomach."),
            a("Yan etkisi var mı?", "Does it have side effects?"),
            b("Nadiren uyku yapar. Araba kullanırsanız dikkat edin.", "Rarely causes drowsiness. Be careful if you drive."),
            a("Fiyatı ne kadar?", "How much is it?"),
            b("Seksen beş lira.", "Eighty-five liras."),
        ]),
        Dialogue(id: "d-restaurant", title: "At a restaurant", subtitle: "Restoranda",
                 systemImage: "fork.knife", level: .a2, lines: [
            a("Rezervasyonumuz var, Demir adına.", "We have a reservation under Demir."),
            b("Buyurun, pencere kenarına geçelim.", "This way, please, let's go by the window."),
            a("Garson bey, menüyü rica edebilir miyiz?", "Waiter, could we have the menu?"),
            b("Elbette, birazdan geliyorum.", "Of course, I'll be right back."),
            a("Günün yemeği ne?", "What's today's special?"),
            b("Izgara levrek ve mevsim salatası.", "Grilled sea bass and seasonal salad."),
        ]),
        Dialogue(id: "d-parents", title: "Talking with parents", subtitle: "Ailece sohbet",
                 systemImage: "figure.2.and.child.holdinghands", level: .a2, lines: [
            a("Bugün nasıldı oğlum?", "How was your day, son?"),
            b("Güzeldi anne, sınavdan yüksek aldım.", "It was good, mom, I got a high score on the exam."),
            a("Çok sevindim. Yemeğini yedin mi?", "I'm so glad. Did you eat?"),
            b("Evet, teşekkür ederim.", "Yes, thanks."),
            a("Ödev var mı?", "Any homework?"),
            b("Az, birazdan başlayacağım.", "A little, I'll start soon."),
        ]),
        Dialogue(id: "d-weather", title: "Small talk: weather", subtitle: "Hava durumu",
                 systemImage: "cloud.sun.fill", level: .a1, lines: [
            a("Bugün hava nasıl?", "How's the weather today?"),
            b("Biraz serin ama güneşli.", "A bit cool but sunny."),
            a("Yağmur yağacak mı?", "Will it rain?"),
            b("Akşam yağabilir, şemsiye al.", "Might rain in the evening, grab an umbrella."),
            a("Teşekkürler.", "Thanks."),
        ]),
        Dialogue(id: "d-dating", title: "On a date", subtitle: "Randevuda",
                 systemImage: "heart.fill", level: .b1, lines: [
            a("Seninle tanışmak güzeldi.", "It was nice meeting you."),
            b("Benim için de öyle. Tekrar görüşelim mi?", "Same here. Should we meet again?"),
            a("Tabii, cumartesi boş musun?", "Sure, are you free on Saturday?"),
            b("Akşamdan sonra uygunum.", "I'm free after the evening."),
            a("O zaman saat yedide, aynı yerde?", "Then seven o'clock, same place?"),
            b("Harika, görüşürüz.", "Great, see you."),
        ]),
        Dialogue(id: "d-news", title: "Discussing the news", subtitle: "Haberleri tartışmak",
                 systemImage: "newspaper.fill", level: .c1, lines: [
            a("Bugünkü ekonomi haberlerini okudun mu?", "Did you read today's economy news?"),
            b("Evet, faizin yeniden arttırılması tartışılıyor.", "Yes, another rate hike is being debated."),
            a("Bunun enflasyonu düşüreceğine inanıyor musun?", "Do you believe this will reduce inflation?"),
            b("Kısa vadede belki, ama uzun vadede yatırımı olumsuz etkileyebilir.", "Maybe in the short term, but in the long term it could hurt investment."),
            a("Merkez Bankası daha kararlı adımlar atmalı.", "The central bank should take firmer steps."),
            b("Katılıyorum, güvenilirlik çok önemli.", "I agree, credibility is crucial."),
        ]),
        Dialogue(id: "d-gym", title: "At the gym", subtitle: "Spor salonunda",
                 systemImage: "figure.run", level: .b1, lines: [
            a("Üyelik nasıl çalışıyor?", "How does membership work?"),
            b("Aylık veya yıllık paketler var.", "There are monthly or yearly packages."),
            a("Deneme dersi alabilir miyim?", "Can I take a trial class?"),
            b("Elbette, yarın onda pilates var.", "Sure, there's pilates tomorrow at ten."),
            a("Ekipman getirmeli miyim?", "Do I need to bring equipment?"),
            b("Mat biz veriyoruz, havlu getirin.", "We provide mats, bring a towel."),
        ]),
    ]
}
