import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi/Notlardao.dart';
import 'package:notlar_uygulamasi/main.dart';

class NotKayitSayfa extends StatefulWidget {
  const NotKayitSayfa({super.key});

  @override
  State<NotKayitSayfa> createState() => _NotKayitSayfaState();
}

class _NotKayitSayfaState extends State<NotKayitSayfa> {

  var tfDersAdi = TextEditingController();
  var tfDersNot1 = TextEditingController();
  var tfDersNot2 = TextEditingController();

  Future<void> kayit(String dersAdi,int not1,int not2) async{
    await Notlardao().notEkle(dersAdi, not1, not2);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AnaSayfa()),
          (Route<dynamic> route) => false,
    );
    setState(() {});
  }

  Future<void> kaydetOnayla(String dersAdi, int not1, int not2) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Kaydetme İşlemi'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bu notu kaydetmek istediğinizden emin misiniz?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('İptal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Kaydet'),
              onPressed: () {
                Navigator.of(context).pop();
                kayit(dersAdi, not1, not2);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text("Not Kayıt",style: TextStyle(color: Colors.white,)),
      ),
      body: Center(
        child: Padding(

          padding: const EdgeInsets.only(left: 50.0,right: 50.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextField(
                controller: tfDersAdi,
                decoration: InputDecoration(hintText: "Ders Adı"),
              ),
              TextField(
                controller: tfDersNot1,
                decoration: const InputDecoration(hintText: "Not 1"),
              ),TextField(
                controller: tfDersNot2,
                decoration: const InputDecoration(hintText: "Not 2"),
              ),

            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          kayit(tfDersAdi.text, int.parse(tfDersNot1.text), int.parse(tfDersNot2.text));
        },
        tooltip: 'Not Ekle',
        label: Text('Yeni Ders Ekle'),
        icon: Icon(Icons.save),
      ),

    );
  }
}
