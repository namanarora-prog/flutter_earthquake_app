import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import  'package:intl/intl.dart';

void main() async{
  Map data=await get_info();
  List features=data['features'];
  runApp(MaterialApp(
    title: "Quake",
    home: Scaffold(
      appBar: AppBar(
        backgroundColor:Colors.blue,
        title: Text("Quake",style: TextStyle(
          fontFamily: 'norwester'
        ),
        ),
      ),
      body:  Center(
        child: ListView.separated(padding:EdgeInsets.only(top: 10.0), separatorBuilder: (context,index){return Divider(color: Colors.blue,);},
            itemCount: features.length,
            itemBuilder:(BuildContext context,int pos){
              var format = new DateFormat.yMMMMd("en_US").add_jm();
              var date=format.format(DateTime.fromMillisecondsSinceEpoch(features[pos]['properties']['time'],isUtc: true));
              return ListTile(

                title: Text("$date",style: TextStyle(
                 fontFamily: 'norwester',
                     fontSize:30.0,
                  color: Colors.red,
                 ),),
                subtitle: Text("${features[pos]['properties']['title']}",
                style: TextStyle(
                  fontSize: 24.0,
                  fontStyle: FontStyle.italic,
                ),
                ),
                leading: CircleAvatar(
                  child: Text("${features[pos]['properties']['mag']}",
                  style: TextStyle(fontSize: 24.0),
                  ),
                radius: 35.0,
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                onTap:(){ alert_show(context,"${features[pos]['properties']['title']}");},
              );
            }
        ),
      )
    ),
  ));
}

void alert_show(BuildContext context,String message){
  var alert=AlertDialog(
    title: Text("Quake"),
    content: Text(message),
    actions: <Widget>[
      FlatButton(
        child: Text("Ok"),
        onPressed: (){Navigator.pop(context);},
      )
    ],
  );
 showDialog(context: context,child: alert);
}

Future<Map> get_info() async{
  String infoUrl="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson";

  http.Response rs=await http.get(infoUrl);

  return json.decode(rs.body);
}