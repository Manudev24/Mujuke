import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../music_item_found.dart';

class SearchPageA extends StatefulWidget {
  const SearchPageA({Key? key}) : super(key: key);

  @override
  _SearchPageAState createState() => _SearchPageAState();
}

class _SearchPageAState extends State<SearchPageA> {
  List<Map<String, dynamic>> _musicDataList = [];

  Future<void> getMusicData(query) async {
    final response = await http
        .get(Uri.parse('http://192.168.1.2:8000/songs/name/${query}'));
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

  Future<void> sendMusicData(Map<String, dynamic> musicData) async {
    final response = await http.post(
      Uri.parse('http://192.168.1.2:8000/songs'),
      headers: <String, String>{'Content-Type': 'application/json'},
      body: jsonEncode(musicData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to send music data');
    }
  }

  void showConfirmationDialog(Map<String, dynamic> musicData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Confirmar'),
          content: Text('¿Desea agregar esta canción a su lista?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () async {
                final currentUser = FirebaseAuth.instance.currentUser;
                if (currentUser != null) {
                  await sendMusicData({
                    'musicId': musicData['_id'],
                    'nombre': musicData['nombre'],
                    'artistas': musicData['artistas'],
                    'userName': currentUser.displayName,
                    'userImg': currentUser.photoURL,
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Canción agregada')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Debe iniciar sesión')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: Text('Aceptar'),
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
                Text(
                  'Buscar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    getMusicData(value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Buscar canción',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _musicDataList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final musicData = _musicDataList[index];
                    return GestureDetector(
                      onTap: () {
                        showConfirmationDialog(musicData);
                      },
                      child: MusicItem(
                        text1: musicData['nombre'],
                        text2: musicData['artistas'],
                        image1:
                            ('http://192.168.1.2:8000/recursos/Media/Images/${musicData['_id']}.jpeg'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
