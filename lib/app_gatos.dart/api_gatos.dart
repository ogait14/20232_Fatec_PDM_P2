import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Album fotos de gatos',
      home: CatPhotoScreen(),
    );
  }
}

class CatPhotoScreen extends StatefulWidget {
  @override
  _CatPhotoScreenState createState() => _CatPhotoScreenState();
}

class _CatPhotoScreenState extends State<CatPhotoScreen> {
  List<String> catPhotos = [];

  Future<void> fetchCatPhotos() async {
    final response = await http.get(
      Uri.parse('https://api.thecatapi.com/v1/images/search?limit=5'),
      headers: {'x-api-key': 'live_Jd4lS8bEDrGwfXXI9YvDEJFDWijbxobM9lUQ21kWl372E9C0mggVMPgvscTRaYcg'},
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        catPhotos = List<String>.from(data.map((cat) => cat['url'] as String));
      });
    } else {
      throw Exception('Falha no carregamento das fotos');
    }
  }

  Future<void> fetchCatPhotosMultipleTimes(int times) async {
    for (int i = 0; i < times; i++) {
      await fetchCatPhotos();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCatPhotos();
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gatos - Album de fotografias'),
      ),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color.fromARGB(255, 136, 172, 189),
            width: 25.0,
          ),
        ),
        child: catPhotos.isEmpty
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: catPhotos.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    constraints: BoxConstraints(
                    ),
                    child: Image.network(
                      catPhotos[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          fetchCatPhotosMultipleTimes(5);
        },
        child: Icon(Icons.add_a_photo_rounded),
      ),
    );
  }
}
