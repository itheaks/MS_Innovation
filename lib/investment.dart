import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

const _investmentCredentials = r'''
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

const _investmentSpreadsheetId = 'XXX';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Investment App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: InvestmentSection(),
    );
  }
}

class InvestmentSection extends StatefulWidget {
  @override
  _InvestmentSectionState createState() => _InvestmentSectionState();
}

class _InvestmentSectionState extends State<InvestmentSection> {
  final GSheets _gsheets = GSheets(_investmentCredentials);
  Worksheet? _investmentSheet;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _amountController = TextEditingController();
  List<List<String>> _investmentData = [];

  @override
  void initState() {
    super.initState();
    _loadInvestmentSheet();
  }

  Future<void> _loadInvestmentSheet() async {
    final ss = await _gsheets.spreadsheet(_investmentSpreadsheetId);
    _investmentSheet = ss.worksheetByTitle('investment');
    await _refreshInvestmentData();
  }

  Future<void> _refreshInvestmentData() async {
    if (_investmentSheet == null) {
      return;
    }

    final values = await _investmentSheet!.values.allRows();
    setState(() {
      _investmentData = values;
    });
  }

  Future<void> _createInvestment() async {
    if (_investmentSheet == null) {
      return;
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final rowData = [
      formattedDate,
      _nameController.text,
      _amountController.text,
    ];

    await _investmentSheet!.values.appendRow(rowData);
    _clearControllers();
    await _refreshInvestmentData();
  }

  Future<void> _updateInvestment(String date) async {
    if (_investmentSheet == null) {
      return;
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final updatedRowData = [
      formattedDate, // Format the date here
      _nameController.text,
      _amountController.text,
    ];

    final rowIndex = _investmentData.indexWhere((rowData) => rowData[0] == date);

    if (rowIndex != -1) {
      _investmentData[rowIndex] = updatedRowData;

      // Update only the specific row without clearing the entire sheet
      await _investmentSheet!.values.insertRow(rowIndex + 2, updatedRowData); // Add 2 to account for header and 0-based index

      _clearControllers();
      await _refreshInvestmentData();
    }
  }

  Future<void> _deleteInvestment(String date) async {
    if (_investmentSheet == null) {
      return;
    }

    _investmentData.removeWhere((rowData) => rowData[0] == date);

    await _investmentSheet!.clear();
    await _investmentSheet!.values.appendRow(['Date', 'Name', 'Amount']);
    for (final rowData in _investmentData) {
      await _investmentSheet!.values.appendRow(rowData);
    }

    _clearControllers();
    await _refreshInvestmentData();
  }

  void _clearControllers() {
    _nameController.clear();
    _amountController.clear();
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
      // Handle the error (e.g., display an error message to the user)
    }
  }

  double _calculateTotalAmount() {
    double totalAmount = 0.0;
    for (final rowData in _investmentData) {
      if (rowData.length > 2) {
        totalAmount += double.tryParse(rowData[2]) ?? 0.0;
      }
    }
    return totalAmount;
  }

  @override
  Widget build(BuildContext context) {
    final totalAmount = _calculateTotalAmount();
    return Scaffold(
      appBar: AppBar(title: Text('Investment Tracker')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Investment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
                  return;
                }
                _createInvestment();
              },
              child: Text('Add Investment'),
            ),
            SizedBox(height: 16.0),
            Text(
              'Investment List',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            // Investment List
            Expanded(
              child: ListView.builder(
                itemCount: _investmentData.length,
                itemBuilder: (context, index) {
                  final rowData = _investmentData[index];
                  return Card(
                    elevation: 3.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        rowData[1], // Name
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date: ${rowData[0]}'), // Formatted Date
                          Text('Amount: \$${rowData[2]}'), // Amount
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              // Set the controllers with the current data
                              _nameController.text = rowData[1];
                              _amountController.text = rowData[2];
                              // Show a dialog to edit the investment
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text('Edit Investment'),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _nameController,
                                          decoration: InputDecoration(labelText: 'Name'),
                                        ),
                                        TextField(
                                          controller: _amountController,
                                          decoration: InputDecoration(labelText: 'Amount'),
                                          keyboardType: TextInputType.number,
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
                                          if (_nameController.text.isEmpty || _amountController.text.isEmpty) {
                                            return;
                                          }
                                          _updateInvestment(rowData[0]);
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
                            onPressed: () => _deleteInvestment(rowData[0]), // Pass the date to delete
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Text(
              'Total Amount: \$${totalAmount.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
