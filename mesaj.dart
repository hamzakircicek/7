import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_app/mesajSayfa.dart';
import 'package:toast/toast.dart';
class mesajSayfa extends StatefulWidget {
  String kullanici;
  String adim;
   String karsiUid;
   String uid;
   String dc;
   var pp;
   var karsiPp;

  mesajSayfa({this.kullanici,this.adim,this.karsiUid, this.uid,this.dc,this.pp,this.karsiPp});
  @override
  _mesajSayfaState createState() => _mesajSayfaState();
}
String e;
bool ben=false;
FirebaseFirestore _firestore=FirebaseFirestore.instance;
FirebaseAuth _auth=FirebaseAuth.instance;

class _mesajSayfaState extends State<mesajSayfa> {
  String email=_auth.currentUser.email;
  String r;
  var karsiP;

  TextEditingController txt=new TextEditingController();
@override
  void initState() {
    r=widget.dc;
    karsiP=widget.karsiPp;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            )
        ),
        body: ListView(
            children:[ Column(
                children:[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: Center(
                      child: Text(_auth.currentUser.displayName==widget.kullanici?widget.adim:widget.kullanici),
                    ),
                  ),

                  StreamBuilder(

                    stream: _firestore.collection('mesaj').doc(r).collection('ic').snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
                      if(snapshot.data==null){return CircularProgressIndicator();}

                      return Container(
                        height: 420,
                        child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Column(

                              children: snapshot.data.docs.map((doc) {

                                return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  height: 40,

                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: doc['uid']==_auth.currentUser.uid ? Colors.green : Colors.blueGrey
                                  ),
                                  child: Center(
                                    child: Text(
                                      doc['icerik'], style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              );}

                              ).toList(),
                            )
                        ),
                      );
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(

                          width: 250,

                          child: TextField(

                            controller: txt,

                          )
                      ),
                      SizedBox(width: 10,),
                      IconButton(icon: Icon(Icons.send), onPressed: () {

                       mesajj(karsiP,_auth.currentUser.photoURL,widget.dc,_auth.currentUser.email,ben, _auth.currentUser.uid,
                            _auth.currentUser.uid==widget.karsiUid?widget.uid:widget.karsiUid, txt.text,
                           _auth.currentUser.displayName==widget.kullanici?widget.adim:widget.kullanici,_auth.currentUser.displayName);


                        mesajjSyf(karsiP,_auth.currentUser.photoURL,_auth.currentUser.displayName,_auth.currentUser.displayName==widget.kullanici?widget.adim:widget.kullanici,
                         widget.dc,_auth.currentUser.uid,_auth.currentUser.uid==widget.karsiUid?widget.uid:widget.karsiUid,);
                        setState(() {

                          txt.text="";

                        });

                      })
                    ],
                  ),


                ]
            ),
            ]
        )
    );
  }
  void mesajj(karsiPp,pp,String docId,String gonderenEmail,bool onayDurumu,String uid,String karsiUid,String icerik,String kullanici,String gonderenAd) async{
    try{

      Map<String, dynamic> aktar= Map();
      aktar['karsiPp']=karsiPp;
      aktar['pp']=pp;
      aktar['docId']=docId;
      aktar['gonderenEmail']=gonderenEmail;
      aktar['onayDurumu']=onayDurumu;
      aktar['uid']=uid;
      aktar['karsiUid']=karsiUid;
      aktar['icerik']=icerik;
      aktar['kullanici']=kullanici;
      aktar['gonderenAd']=gonderenAd;
      await _firestore.collection('mesaj').doc(r).collection('ic').doc().set(aktar, SetOptions(merge: true));

    }catch(e){
      debugPrint(e);
    }
  }
  void mesajjSyf(karsiPp,pp,String gonderenAd,String kullanici,String docId,String uid,String karsiUid) async{
    try{

      Map<String, dynamic> aktar= Map();
      aktar['karsiPp']=karsiPp;
      aktar['pp']=pp;
      aktar['gonderenAd']=gonderenAd;
      aktar['kullanici']=kullanici;
      aktar['docId']=docId;
      aktar['uid']=uid;
      aktar['karsiUid']=karsiUid;

      await _firestore.collection('mesajSyf').doc(r).set(aktar, SetOptions(merge: false));

    }catch(e){
      debugPrint(e);
    }
  }

}
