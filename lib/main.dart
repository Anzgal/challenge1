import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter_svg/flutter_svg.dart';



void main() => runApp(new MarvelApp());

class MarvelApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.blueGrey
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(title: Text("Casos Coronavirus"),),
          body: InfinityDudes()


      ),
    );
  }
}

class InfinityDudes extends StatefulWidget{
  @override
  ListInfinityDudesState createState() => new ListInfinityDudesState();
}

class ListInfinityDudesState extends State<InfinityDudes>{
  Future<List<InfinityComic>> getDudes()async{
    //var now = new DateTime.now();
    //var md5D = generateMd5(now.toString()+"10a1273d791c95f3d67c35f1bff33be5cec900d9"+"9e1c26d697516578f5d28c48fb255609");
    //var url = "https://gateway.marvel.com:443/v1/public/characters?&ts=" + now.toString()+  "&apikey=9e1c26d697516578f5d28c48fb255609&hash="+md5D;


    // Base headers for Response url
    const Map<String, String> _headers = {
      "content-type": "application/json",
      "x-rapidapi-host": "covid-193.p.rapidapi.com",
      "x-rapidapi-key": "4b59f72b81mshd8b9829b9a4813ap1c9309jsn3e233b1a062e",
    };

    Uri uri = Uri.https("covid-193.p.rapidapi.com", '/statistics');
    var response = await http.get(uri, headers: _headers);

    var jsonData2 = json.decode(response.body);
    print(jsonData2);

    //print(jsonData);
    List<InfinityComic> dudes = [];

    var dataMarvel = jsonData2["response"];
    //print(dataMarvel);
    for(var dude in dataMarvel){
      //var thumb = dude["thumbnail"];
      var image = "https://www.countries-ofthe-world.com/flags-normal/flag-of-" + dude["country"] + ".png";
      //var image = dude["flag"];

      DateTime now = new DateTime.now();
      String date;

      if(now.month.toString()[0] == "0"){
        date = now.year.toString() + "-" +  now.month.toString()[1] + "-" + (now.day-1).toString();

      }else {

        date = now.year.toString() + "-" +  now.month.toString() + "-" + (now.day-1).toString();

      }
      //print(date);

      var casos = dude["cases"];
      var totales = casos["total"];
      var recuperados = casos["recovered"];
      var muertes = dude["deaths"]["total"];

      InfinityComic infinityComic = InfinityComic(dude["country"], image, totales.toString(), recuperados.toString(), muertes.toString());
      print("DUDE: " + infinityComic.title);
      dudes.add(infinityComic);
    }
    return dudes;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: FutureBuilder(
            future: getDudes(),
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.data == null){
                return Container(
                  child: Center(
                    child: Text("loading..."),
                  ),
                );
              }else{
                return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(snapshot.data[index].cover),
                        ),
                        title: Text(snapshot.data[index].title),
                        onTap: (){
                          Navigator.push(context, new MaterialPageRoute(builder: (context)=> InfinityDetail(snapshot.data[index])));
                        },
                      );
                    });
              }
            }
        ),
      ),
    );
  }

}

class InfinityComic{
  final String title;
  final String cover;
  final String casos;
  final String recuperados;
  final String muertes;
  InfinityComic(this.title, this.cover, this.casos, this.recuperados, this.muertes);
}

class InfinityDetail extends StatelessWidget{
  final InfinityComic infinityComic;
  InfinityDetail(this.infinityComic);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
        appBar: AppBar(
          title: Text(infinityComic.title),
        ),
        body: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Column(

                mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.network(
             infinityComic.cover,
            ),
            SizedBox(
              height: 70,
            ),
            Text("Número de casos totales: " + infinityComic.casos),
            SizedBox(height: 30,),
            Text("Número de recuperados: " + infinityComic.recuperados),
            SizedBox(height: 30,),
            Text("Muertes: " + infinityComic.muertes)
          ]
    )]
        )

    );
  }
}


