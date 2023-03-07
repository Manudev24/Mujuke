import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rocola_movil/auth_service.dart';

import '../music_item.dart';

class HomePageA extends StatefulWidget {
  const HomePageA({Key? key}) : super(key: key);

  @override
  _HomePageAState createState() => _HomePageAState();
}

class _HomePageAState extends State<HomePageA> {
  late Future<Map<String, dynamic>> currentData;
  List<Map<String, dynamic>> _musicDataList = [];
  final _duration = Duration(seconds: 5);

  @override
  void initState() {
    super.initState();
    currentData = getCurrentData();
    getMusicData();
    Timer.periodic(_duration, (timer) {
      getMusicData();
      getCurrentData().then((value) => setState(() {
            currentData = Future.value(value);
          }));
    });
  }

  Future<Map<String, dynamic>> getCurrentData() async {
    final response =
        await http.get(Uri.parse('http://192.168.1.2:8000/current'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load current data');
    }
  }

  Future<void> getMusicData() async {
    final response = await http.get(Uri.parse('http://192.168.1.2:8000/songs'));
    if (response.statusCode == 200) {
      if (jsonDecode(response.body) != null) {
        setState(() {
          _musicDataList =
              List<Map<String, dynamic>>.from(jsonDecode(response.body));
        });
      } else {
        setState(() {
          _musicDataList = List<Map<String, dynamic>>.from([]);
        });
      }
    } else {
      throw Exception('Failed to load music data');
    }
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("¿Está seguro de que desea cerrar sesión?"),
          actions: <Widget>[
            TextButton(
              child: Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Aceptar"),
              onPressed: () {
                AuthService().signOut();
                Navigator.of(context).pop();
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Inicio',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      child: Image(
                        image: AssetImage('assets/signout.png'),
                        width: 25,
                      ),
                      onTap: () {
                        _showLogoutDialog(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                FutureBuilder<Map<String, dynamic>>(
                  future: currentData,
                  builder: (BuildContext context,
                      AsyncSnapshot<Map<String, dynamic>> snapshot) {
                    if (snapshot.hasData) {
                      return Row(
                        children: [
                          Image(
                            image: NetworkImage(
                                'http://192.168.1.2:8000/recursos/Media/Images/${snapshot.data!['musicId']}.jpeg'),
                            width: 80,
                            height: 80,
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot.data!['nombre'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text(snapshot.data!['artista']),
                            ],
                          )
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text('Error loading current data');
                    } else {
                      return CircularProgressIndicator();
                    }
                  },
                ),
                SizedBox(height: 20),
                Text(
                  'Siguientes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _musicDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final musicData = _musicDataList[index];
                    return MusicItem(
                      image1:
                          'http://192.168.1.2:8000/recursos/Media/Images/${musicData['musicId']}.jpeg',
                      image2: musicData['UserImg'],
                      text1: musicData['nombre'],
                      text2: musicData['artistas'],
                      text3: musicData['userName'],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
