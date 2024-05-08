 import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi/NotDetaySayfa.dart';
import 'package:notlar_uygulamasi/NotKayitSayfa.dart';
import 'package:notlar_uygulamasi/Notlardao.dart';

import 'Notlar.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: AnaSayfa(),
    );
  }
}

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

 class _AnaSayfaState extends State<AnaSayfa> {
   late Future<List<Notlar>> notlarFuture;
   List<Notlar> gosterilecekNotlar = [];
   bool aramaYapiliyorMu = false;
   String aramaKelimesi = '';

   @override
   void initState() {
     super.initState();
     notlarFuture = notlariGetir();
   }

   Future<List<Notlar>> notlariGetir() async {
     var notlarListesi = await Notlardao().tumNotlar();
     return notlarListesi;
   }

   Future<void> uygulamayiKapat() async {
     await exit(0);
   }

   Future<void> aramaYap(String yeniAramaKelimesi) async {
     setState(() {
       aramaKelimesi = yeniAramaKelimesi;
       aramaYapiliyorMu = true;
     });

     if (aramaKelimesi.isEmpty) {
       setState(() {
         notlarFuture = notlariGetir();
       });
     } else {
       var aramaSonucu = await Notlardao().searchKelime(aramaKelimesi);
       setState(() {
         notlarFuture = Future.value(aramaSonucu);
         aramaYapiliyorMu = false;
       });
     }
   }

   @override
   Widget build(BuildContext context) {
     return Scaffold(
       appBar: AppBar(
         backgroundColor: Colors.indigoAccent,
         title: Column(
           crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Text(
               "Notlarım",
               style: TextStyle(color: Colors.white, fontSize: 20),
             ),
             FutureBuilder(
               future: notlarFuture,
               builder: (context, snapshot) {
                 if (snapshot.connectionState == ConnectionState.done) {
                   var notlarListesi = snapshot.data as List<Notlar>;
                   double ortalama = 0.0;

                   if (notlarListesi.isNotEmpty) {
                     double toplam = 0.0;

                     for (var n in notlarListesi) {
                       toplam += (n.not1 + n.not2) / 2;
                     }
                     ortalama = toplam / notlarListesi.length;
                     return Text(
                       "Ortalama: ${ortalama.toInt()}",
                       style: TextStyle(color: Colors.white, fontSize: 15),
                     );
                   } else {
                     return Text("Ortalama: 0", style: TextStyle(fontWeight: FontWeight.bold));
                   }
                 } else {
                   return Text("Veri yükleniyor...");
                 }
               },
             )
           ],
         ),
         actions: [
           IconButton(
             icon: Icon(
               Icons.exit_to_app,
               color: Colors.white,
             ),
             onPressed: uygulamayiKapat,
           ),
         ],
       ),
       body: Column(
         children: [
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: TextField(
               decoration: InputDecoration(
                 labelText: 'Ara',
                 hintText: 'Bir ders arayın...',
                 prefixIcon: Icon(
                   Icons.search,
                   color: Colors.black,
                 ),
                 border: OutlineInputBorder(
                   borderRadius: BorderRadius.circular(50.0),
                 ),
               ),
               onChanged: aramaYap,
             ),
           ),
           Expanded(
             child: FutureBuilder(
               future: notlarFuture,
               builder: (context, snapshot) {
                   var notlarListesi = snapshot.data as List<Notlar>;
                   gosterilecekNotlar = notlarListesi;
                   return ListView.builder(
                     itemCount: gosterilecekNotlar.length,
                     itemBuilder: (context, index) {
                       var not = gosterilecekNotlar[index];
                       return GestureDetector(
                         onTap: () {
                           Navigator.push(context, MaterialPageRoute(builder: (context) => NotDetaySayfa(not: not)));
                         },
                         child: Card(
                           child: SizedBox(
                             height: 70,
                             child: Row(
                               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                               children: <Widget>[
                                 Text(not.ders_ad, style: TextStyle(fontWeight: FontWeight.bold)),
                                 Text(not.not1.toString()),
                                 Text(not.not2.toString()),
                               ],
                             ),
                           ),
                         ),
                       );
                     },
                   );

               },
             ),
           ),
         ],
       ),
       floatingActionButton: FloatingActionButton(
         onPressed: () async {
           print("Action butona tıklandı");
           Navigator.push(context, MaterialPageRoute(builder: (context) => NotKayitSayfa()));
           setState(() {});
         },
         tooltip: "Not Ekle",
         child: Icon(Icons.add_circle),
       ),
     );
   }
 }


