import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CsvToList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CsvToListState();
  }
}

class CsvToListState extends State<CsvToList> {
  late List<List<dynamic>> guestData;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  List<PlatformFile>? _paths;
  final String? _extension = 'csv';
  final FileType _pickingType = FileType.custom;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    guestData = List<List<dynamic>>.empty(growable: true);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text("CSV To List")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                color: Colors.green,
                height: 30,
                child: TextButton(
                  child: const Text(
                    "CSV To List",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: _openFileExplorer,
                ),
              ),
            ),
            ListView.builder(
                shrinkWrap: true,
                itemCount: guestData.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(guestData[index][0]),
                          Text(guestData[index][1]),
                          Text(guestData[index][2].toString()),
                          Text(guestData[index][3]),
                        ],
                      ),
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }

  openFile(filepath) async {
    File f = new File(filepath);
    print("CSV to List");
    final input = f.openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();
    print(fields);
    setState(() {
      guestData = fields;
    });
  }

  void _openFileExplorer() async {
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        allowMultiple: false,
        allowedExtensions: (_extension?.isNotEmpty ?? false)
            ? _extension?.replaceAll(' ', '').split(',')
            : null,
      ))
          ?.files;
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    } catch (ex) {
      print(ex);
    }
    if (!mounted) return;
    setState(() {
      openFile(_paths![0].path);
      print(_paths);
      print("File path ${_paths![0]}");
      print(_paths!.first.extension);
    });
  }
}
