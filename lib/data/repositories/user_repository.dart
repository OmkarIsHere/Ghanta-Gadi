import 'package:cloud_firestore/cloud_firestore.dart';

import '../services/firestore_service.dart';

class UserRepository {
  final FirestoreService fs;

  UserRepository(this.fs);

  Future<dynamic> createUser(String id, Map<String, dynamic> data) async {
    await fs.usersRef.doc(id).set(data).then((val){
      return true;
    }).onError((error, stackTrace){
      return false;
    });
  }

  Stream<DocumentSnapshot> getUserStream(String id) {
    return fs.usersRef.doc(id).snapshots();
  }

/*
  Future<void> seedCitiesAndWards() async {
    final firestore = FirebaseFirestore.instance;

    final Map<String, List<String>> cityWardMap = {
      "Mumbai": [
        "Ward A",
        "Ward B",
        "Ward C",
        "Ward D",
        "Ward E",
        "Ward F North",
        "Ward F South",
        "Ward G North",
        "Ward G South",
        "Ward H East",
        "Ward H West",
        "Ward K East",
        "Ward K West",
        "Ward L",
        "Ward M East",
        "Ward M West",
        "Ward N",
        "Ward P North",
        "Ward P South",
        "Ward R North",
        "Ward R South",
        "Ward R Central",
        "Ward S",
        "Ward T",
      ],
      "Thane": [
        "Majiwada-Manpada",
        "Vartaknagar",
        "Lokmanyanagar-Savarkarnagar",
        "Naupada-Kopri",
        "Wagle Estate",
        "Kalwa",
        "Mumbra",
        "Diva",
        "Uthalsar",
        "Ovala-Majiwada",
        "Balkum Gaothan",
      ],
      "Kalyan-Dombivli":[
        "Ward No. 1",
        "Ward No. 2",
        "Ward No. 3",
        "Ward No. 4",
        "Ward No. 5",
        "Ward No. 6",
        "Ward No. 7",
        "Ward No. 8",
        "Ward No. 9",
        "Ward No. 10",
        "Ward No. 11",
        "Ward No. 12",
        "Ward No. 13",
        "Ward No. 14",
        "Ward No. 15",
        "Ward No. 16",
        "Ward No. 17",
        "Ward No. 18",
        "Ward No. 19",
        "Ward No. 20",
        "Ward No. 21",
        "Ward No. 22",
        "Ward No. 23",
        "Ward No. 24",
        "Ward No. 25",
        "Ward No. 26",
        "Ward No. 27",
        "Ward No. 28",
        "Ward No. 29",
        "Ward No. 30",
        "Ward No. 31",
        "Ward No. 32",
        "Ward No. 33",
        "Ward No. 34",
        "Ward No. 35",
        "Ward No. 36",
        "Ward No. 37",
        "Ward No. 38",
        "Ward No. 39",
        "Ward No. 40",
        "Ward No. 41",
        "Ward No. 42",
        "Ward No. 43",
        "Ward No. 44",
        "Ward No. 45",
        "Ward No. 46",
        "Ward No. 47",
        "Ward No. 48",
        "Ward No. 49",
        "Ward No. 50",
        "Ward No. 51",
        "Ward No. 52",
        "Ward No. 53",
        "Ward No. 54",
        "Ward No. 55",
        "Ward No. 56",
        "Ward No. 57",
        "Ward No. 58",
        "Ward No. 59",
        "Ward No. 60",
        "Ward No. 61",
        "Ward No. 62",
        "Ward No. 63",
        "Ward No. 64",
        "Ward No. 65",
        "Ward No. 66",
        "Ward No. 67",
        "Ward No. 68",
        "Ward No. 69",
        "Ward No. 70",
        "Ward No. 71",
        "Ward No. 72",
        "Ward No. 73",
        "Ward No. 74",
        "Ward No. 75",
        "Ward No. 76",
        "Ward No. 77",
        "Ward No. 78",
        "Ward No. 79",
        "Ward No. 80",
        "Ward No. 81",
        "Ward No. 82",
        "Ward No. 83",
        "Ward No. 84",
        "Ward No. 85",
        "Ward No. 86",
        "Ward No. 87",
        "Ward No. 88",
        "Ward No. 89",
        "Ward No. 90",
        "Ward No. 91",
        "Ward No. 92",
        "Ward No. 93",
        "Ward No. 94",
        "Ward No. 95",
        "Ward No. 96",
        "Ward No. 97",
        "Ward No. 98",
        "Ward No. 99",
        "Ward No. 100",
        "Ward No. 101",
        "Ward No. 102",
        "Ward No. 103",
        "Ward No. 104",
        "Ward No. 105",
        "Ward No. 106",
        "Ward No. 107",
        "Ward No. 108",
        "Ward No. 109",
        "Ward No. 110",
        "Ward No. 111",
        "Ward No. 112",
        "Ward No. 113",
        "Ward No. 114",
        "Ward No. 115",
        "Ward No. 116",
        "Ward No. 117",
        "Ward No. 118",
        "Ward No. 119",
        "Ward No. 120",
        "Ward No. 121",
        "Ward No. 122",
      ],
      "Navi Mumbai":[
        "Belapur (Ward A)",
        "Nerul (Ward B)",
        "Vashi (Ward C)",
        "Turbhe (Ward D)",
        "Kopar Khairane (Ward E)",
        "Ghansoli (Ward F)",
        "Airoli (Ward G)",
        "Digha (Ward H)",
    ]
    };

    for (final entry in cityWardMap.entries) {
      final cityName = entry.key;
      final wards = entry.value;

      // Create city document
      final cityRef = firestore.collection("cities").doc(cityName);
      await cityRef.set({"name": cityName});

      // Add wards as subcollection
      for (final ward in wards) {
        await cityRef.collection("wards").doc(ward).set({"name": ward});
      }
    }

    print("=============== Cities and wards seeded successfully! =================");
  }
 */
}
