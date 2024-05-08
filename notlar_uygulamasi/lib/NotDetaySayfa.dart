import 'package:flutter/material.dart';
import 'package:notlar_uygulamasi/Notlar.dart';
import 'Notlardao.dart';
import 'main.dart';

class NotDetaySayfa extends StatefulWidget {
  final Notlar not;

  NotDetaySayfa({required this.not});

  @override
  State<NotDetaySayfa> createState() => _NotDetaySayfaState(not: not);
}

class _NotDetaySayfaState extends State<NotDetaySayfa> {
  final Notlar not;

  _NotDetaySayfaState({required this.not});

  var tfDersAdi = TextEditingController();
  var tfDersNot1 = TextEditingController();
  var tfDersNot2 = TextEditingController();

  Future<void> sil(int not_id) async{
    print("$not_id silindi");
    await Notlardao().notSil(not_id);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AnaSayfa()),
          (Route<dynamic> route) => false,
    );


  }

  Future<void> guncelle(int not_id,String dersAdi,int not1,int not2) async{
    print("$not_id $dersAdi-$not1-$not2 güncellendi");
    await Notlardao().notGuncelle(not_id, dersAdi, not1, not2);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AnaSayfa()),
          (Route<dynamic> route) => false,
    );

  }

  Future<void> guncelleOnayla() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Silme İşlemi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bu notu güncellemek istediğinizden emin misiniz?'),
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
                guncelle(widget.not.not_id, tfDersAdi.text, int.parse(tfDersNot1.text), int.parse(tfDersNot2.text));
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> silOnayla() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Silme İşlemi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bu notu silmek istediğinizden emin misiniz?'),
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
                sil(widget.not.not_id);
              },
            ),
          ],
        );
      },
    );
  }


  @override
  void initState() {
    super.initState();
    var not = widget.not;
    tfDersAdi.text = not.ders_ad.toString();
    tfDersNot1.text = not.not1.toString();
    tfDersNot2.text = not.not2.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigoAccent,
        title: Text("Not Detay",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            onPressed: () {
              sil(widget.not.not_id);
            },
            icon: Icon(Icons.delete,color: Colors.white,),
          ),
          IconButton(
            onPressed: () {
              guncelle(widget.not.not_id, tfDersAdi.text, int.parse(tfDersNot1.text), int.parse(tfDersNot2.text));
            },
            icon: const Icon(Icons.edit,color: Colors.white,),
          ),
        ],
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
    );
  }
}
