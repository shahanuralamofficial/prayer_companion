import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Hadith {
  final String english;
  final String bengali;
  final String reference;

  Hadith({required this.english, required this.bengali, required this.reference});
}

class HadithService {
  final List<Hadith> _hadiths = [
    Hadith(
      english: "The first thing for which a person will be brought to account on the Day of Resurrection will be his prayer.",
      bengali: "কিয়ামতের দিন মানুষের আমলের মধ্যে সর্বপ্রথম সালাতের হিসাব নেয়া হবে।",
      reference: "Sunan an-Nasa'i 465",
    ),
    Hadith(
      english: "Between a man and shirk and disbelief is the abandonment of prayer.",
      bengali: "ব্যক্তি এবং শিরক ও কুফরের মধ্যে পার্থক্য হলো সালাত বর্জন করা।",
      reference: "Sahih Muslim 82",
    ),
    Hadith(
      english: "Prayer in congregation is twenty-seven times more meritorious than a prayer offered individually.",
      bengali: "একাকী সালাত আদায় করার চেয়ে জামাতে সালাত আদায় করার সওয়াব সাতাশ গুণ বেশি।",
      reference: "Sahih al-Bukhari 645",
    ),
    Hadith(
      english: "He who performs the Fajr prayer is under the protection of Allah.",
      bengali: "যে ব্যক্তি ফজরের সালাত আদায় করে, সে আল্লাহর রক্ষণাবেক্ষণের অন্তর্ভুক্ত হয়।",
      reference: "Sahih Muslim 657",
    ),
    Hadith(
      english: "Whoever builds a mosque for Allah, Allah will build for him a house in Paradise.",
      bengali: "যে ব্যক্তি আল্লাহর সন্তুষ্টির জন্য একটি মসজিদ নির্মাণ করবে, আল্লাহ তার জন্য জান্নাতে একটি ঘর নির্মাণ করবেন।",
      reference: "Sahih al-Bukhari 450",
    ),
    Hadith(
      english: "The best among you are those who are best to their families.",
      bengali: "তোমাদের মধ্যে সেই ব্যক্তিই সর্বোত্তম, যে তার পরিবারের নিকট সর্বোত্তম।",
      reference: "Sunan al-Tirmidhi 3895",
    ),
    Hadith(
      english: "A truthful and trustworthy merchant will be with the Prophets, the truthful ones, and the martyrs.",
      bengali: "সত্যবাদী ও আমানতদার ব্যবসায়ী (কিয়ামতের দিন) নবীগণ, সত্যবাদীগণ এবং শহীদদের সাথে থাকবেন।",
      reference: "Sunan al-Tirmidhi 1209",
    ),
    Hadith(
      english: "No one has ever eaten better food than what he eats from the work of his own hands.",
      bengali: "নিজ হাতের উপার্জিত খাদ্যের চেয়ে উত্তম খাদ্য কেউ কখনো আহার করেনি।",
      reference: "Sahih al-Bukhari 2072",
    ),
    Hadith(
      english: "Allah is pure and He only accepts that which is pure.",
      bengali: "নিশ্চয়ই আল্লাহ তা'আলা পবিত্র এবং তিনি পবিত্র বস্তু ছাড়া আর কিছু গ্রহণ করেন না।",
      reference: "Sahih Muslim 1015",
    ),
    Hadith(
      english: "Every act of goodness is a charity.",
      bengali: "প্রত্যেকটি ভালো কাজই একটি সাদাকা।",
      reference: "Sahih al-Bukhari 6021",
    ),
    Hadith(
      english: "Cleanliness is half of faith.",
      bengali: "পবিত্রতা ঈমানের অর্ধেক।",
      reference: "Sahih Muslim 223",
    ),
    Hadith(
      english: "The world is sweet and green, and Allah has made you vicegerents in it to see how you will act.",
      bengali: "দুনিয়া হলো মিষ্ট ও সবুজ, আর আল্লাহ তোমাদের এতে প্রতিনিধি বানিয়েছেন দেখার জন্য যে তোমরা কেমন আমল করো।",
      reference: "Sahih Muslim 2742",
    ),
    Hadith(
      english: "The most beloved of deeds to Allah are those that are most consistent, even if they are small.",
      bengali: "আল্লাহর নিকট সবচেয়ে প্রিয় আমল হলো যা নিয়মিত করা হয়, যদিও তা অল্প হয়।",
      reference: "Sahih al-Bukhari 6464",
    ),
    Hadith(
      english: "A Muslim is the one from whose tongue and hand the Muslims are safe.",
      bengali: "প্রকৃত মুসলিম সেই ব্যক্তি, যার জিহ্বা এবং হাত থেকে অন্য মুসলিমরা নিরাপদ থাকে।",
      reference: "Sahih al-Bukhari 10",
    ),
    Hadith(
      english: "Give the laborer his wages before his sweat dries.",
      bengali: "শ্রমিকের ঘাম শুকানোর আগেই তার মজুরি পরিশোধ করে দাও।",
      reference: "Sunan Ibn Majah 2443",
    ),
    Hadith(
      english: "None of you truly believes until he loves for his brother what he loves for himself.",
      bengali: "তোমাদের কেউ ততক্ষণ পর্যন্ত প্রকৃত মুমিন হতে পারবে না, যতক্ষণ না সে তার ভাইয়ের জন্য তা-ই পছন্দ করে যা সে নিজের জন্য পছন্দ করে।",
      reference: "Sahih al-Bukhari 13",
    ),
  ];

  Map<String, String> getRandomHadith(String locale) {
    final random = Random();
    final hadith = _hadiths[random.nextInt(_hadiths.length)];
    
    return {
      'text': locale == 'bn' ? hadith.bengali : hadith.english,
      'reference': hadith.reference,
    };
  }
}

final hadithServiceProvider = Provider((ref) => HadithService());
