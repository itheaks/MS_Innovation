import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

const _detailCredentials = r'''
{
  "type": "service_account",
  "project_id": "m-s-innovation",
  "private_key_id": "XXX",
  "private_key": "XXX"
  "client_email": "m-s-innovation@m-s-innovation.iam.gserviceaccount.com",
  "client_id": "103383350141430022428",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/m-s-innovation%40m-s-innovation.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

const _detailSpreadsheetId = 'XXX';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Detail App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DetailSection(),
    );
  }
}

class DetailSection extends StatefulWidget {
  @override
  _DetailSectionState createState() => _DetailSectionState();
}

class _DetailSectionState extends State<DetailSection> {
  final GSheets _gsheets = GSheets(_detailCredentials);
  Worksheet? _detailSheet;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _printingTimeController = TextEditingController();
  TextEditingController _colorController = TextEditingController();
  TextEditingController _gramController = TextEditingController();
  bool _isSuccessful = false;
  List<List<String>> _detailData = [];

  @override
  void initState() {
    super.initState();
    _loadDetailSheet();
  }

  Future<void> _loadDetailSheet() async {
    final ss = await _gsheets.spreadsheet(_detailSpreadsheetId);
    _detailSheet = ss.worksheetByTitle('detail');
    await _refreshDetailData();
  }

  Future<void> _refreshDetailData() async {
    if (_detailSheet == null) {
      return;
    }

    final values = await _detailSheet!.values.allRows();
    setState(() {
      _detailData = values;
    });
  }

  Future<void> _createDetail() async {
    if (_detailSheet == null) {
      return;
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final rowData = [
      formattedDate,
      _nameController.text,
      _printingTimeController.text,
      _colorController.text,
      _gramController.text,
      _isSuccessful ? 'Yes' : 'No',
    ];

    await _detailSheet!.values.appendRow(rowData);
    _clearControllers();
    await _refreshDetailData();
  }

  Future<void> _updateDetail(String date) async {
    if (_detailSheet == null) {
      return;
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final updatedRowData = [
      formattedDate,
      _nameController.text,
      _printingTimeController.text,
      _colorController.text,
      _gramController.text,
      _isSuccessful ? 'Yes' : 'No',
    ];

    final rowIndex = _detailData.indexWhere((rowData) => rowData[0] == date);

    if (rowIndex != -1) {
      _detailData[rowIndex] = updatedRowData;

      await _detailSheet!.values.insertRow(rowIndex + 2, updatedRowData);

      _clearControllers();
      await _refreshDetailData();
    }
  }

  Future<void> _deleteDetail(String date) async {
    if (_detailSheet == null) {
      return;
    }

    _detailData.removeWhere((rowData) => rowData[0] == date);

    await _detailSheet!.clear();
    await _detailSheet!.values.appendRow(['Date', 'Name', 'Printing Time', 'Color', 'Gram', 'Successful']);
    for (final rowData in _detailData) {
      await _detailSheet!.values.appendRow(rowData);
    }

    _clearControllers();
    await _refreshDetailData();
  }

  void _clearControllers() {
    _nameController.clear();
    _printingTimeController.clear();
    _colorController.clear();
    _gramController.clear();
    setState(() {
      _isSuccessful = false;
    });
  }

  void _openExcelSheet() async {
    const excelURL = 'https://docs.google.com/spreadsheets/d/1e7L3fbD22fvgt8occb9sjXuXx5aV8Yxlc88tlPyMrfA/edit?usp=sharing';
    try {
      if (await canLaunch(excelURL)) {
        await launch(excelURL);
      } else {
        throw 'Could not launch $excelURL';
      }
    } catch (e) {
      print('Error opening Excel sheet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(title: Text('Detail Tracker')),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Detail',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _printingTimeController,
              decoration: InputDecoration(labelText: 'Printing Time'),
            ),
            TextField(
              controller: _colorController,
              decoration: InputDecoration(labelText: 'Color'),
            ),
            TextField(
              controller: _gramController,
              decoration: InputDecoration(labelText: 'Gram'),
            ),
            Row(
              children: [
                Text('Successful: '),
                Checkbox(
                  value: _isSuccessful,
                  onChanged: (value) {
                    setState(() {
                      _isSuccessful = value ?? false;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty) {
                  return;
                }
                _createDetail();
              },
              child: Text('Add Detail'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Detail List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _detailData.length,
                itemBuilder: (context, index) {
                  final rowData = _detailData[index];
                  final isSuccessful = rowData[5] == 'Yes';
                  return Card(
                    elevation: 3.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    color: isSuccessful ? Colors.green : Colors.yellow,
                    child: ListTile(
                      title: Text(
                        rowData[1], // Name
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${rowData[0]}'), // Formatted Date
                          Text('Printing Time: ${rowData[2]}'),
                          Text('Color: ${rowData[3]}'),
                          Text('Gram: ${rowData[4]}'),
                          Text('Successful: ${rowData[5]}'),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              _nameController.text = rowData[1];
                              _printingTimeController.text = rowData[2];
                              _colorController.text = rowData[3];
                              _gramController.text = rowData[4];
                              setState(() {
                                _isSuccessful = rowData[5] == 'Yes';
                              });
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Edit Detail'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _nameController,
                                          decoration: InputDecoration(labelText: 'Name'),
                                        ),
                                        TextField(
                                          controller: _printingTimeController,
                                          decoration: InputDecoration(labelText: 'Printing Time'),
                                        ),
                                        TextField(
                                          controller: _colorController,
                                          decoration: InputDecoration(labelText: 'Color'),
                                        ),
                                        TextField(
                                          controller: _gramController,
                                          decoration: InputDecoration(labelText: 'Gram'),
                                        ),
                                        Row(
                                          children: [
                                            Text('Successful: '),
                                            Checkbox(
                                              value: _isSuccessful,
                                              onChanged: (value) {
                                                setState(() {
                                                  _isSuccessful = value ?? false;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          if (_nameController.text.isEmpty) {
                                            return;
                                          }
                                          _updateDetail(rowData[0]);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text('Save'),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () => _deleteDetail(rowData[0]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                const excelURL = 'https://docs.google.com/spreadsheets/d/1e7L3fbD22fvgt8occb9sjXuXx5aV8Yxlc88tlPyMrfA/edit?usp=sharing';
                launch(excelURL);
              },
              child: Text('Open Excel Sheet'),
            ),
          ],
        ),
      ),
    );
  }
}
