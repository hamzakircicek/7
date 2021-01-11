


import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/bottom.dart';
import 'package:flutter_app/mesaj.dart';
import 'package:toast/toast.dart';
class mesajSayfasi extends StatefulWidget {
  String docc;
  mesajSayfasi({this.docc});

  @override
  _mesajSayfasiState createState() => _mesajSayfasiState();
}
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;



class _mesajSayfasiState extends State<mesajSayfasi> {
  var karsi;
  String email;
  var uid;
  var karsiUid;
  int f;
  var userPhoto;
  var userName;



@override
  Widget build(BuildContext context) {



    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.blueGrey,
        ),
        leading:
        IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));}



        ),
      ),


      body:Container(
        child: StreamBuilder(
          stream: _firestore.collection('mesajSyf').snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot> snapshot){
             if(!snapshot.hasData){
return Center(child: CircularProgressIndicator());
            }

             return Container(
               child: Column(
                 children: snapshot.data.docs.map((e) {
               if( _auth.currentUser.uid.toString()==e['uid'] || _auth.currentUser.uid.toString()==e['karsiUid']) {
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: InkWell(
                       onTap: () {
                         Navigator.push(
                             context, MaterialPageRoute(builder: (context) =>
                             mesajSayfa(pp: e['pp'],
                               kullanici: e['kullanici'],
                               adim: e['gonderenAd'],
                               karsiUid: e['karsiUid'],
                               uid: e['uid'],
                               dc:e['docId'],)));
                       },
                       child: Container(
                         child: Card(
                           child: ListTile(
                             leading: Container(width:40,height:40,
                                 decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(40),
                                       image: DecorationImage(
                                         image: NetworkImage(e['karsiPp']==null?"https://cdn2.iconfinder.com/data/icons/flat-mini-1/128/message_failed-512.png":
                                         (e['pp'])),fit: BoxFit.cover, )
                                       )
                                 ),

                             title: Text(e['gonderenAd']==_auth.currentUser.displayName?e['kullanici']:e['gonderenAd']),
                             subtitle: Text(e['gonderenAd']==_auth.currentUser.displayName?e['kullanici']:e['gonderenAd']),
                             trailing: Icon(Icons.add),
                           ),
                         ),
                       )),
                 );
               }else{
                 return Container();
               }

                 }).toList()

               ),
  );})

      ));



  }

}
