import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

const _investmentCredentials = r'''
{
  "type": "service_account",
  "project_id": "m-s-innovation",
  "private_key_id": "64cc0027e21e7d07ecf350347a55a39ec9f53eb9",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQD5Wfr33AnHz4uo\nmgzFaQeXK30KC3TyzMgMzx/eadTdrEzS6SauymEAEgY4NV1Vy9w1YP3Xv2FkwIxY\nMRV19nbiM+HenR8K2mB2JjyAg7mEOdEO6Xr3VLXiDReijcyPM25XOhNe+niJRT72\nBfCm/8gdfn7sjAsRGVxYMuS090VDKHPO8eq8dkXLsyTBhIGYu1Kc2aRpwiQGVKTh\n5gQd/hj76Bfk3VDxN8ESIOEPjFmo/a/85x2yZxJG83ieiO1hDcvcIk7ajP8LozhT\nhQzph4NXKYqrb2XadtrRzHdxOJR+DsQ85l8LBYwRTX1H3/7SfymRJoA4V4nleogF\nEUcg7B5XAgMBAAECggEAJeoNpBR8FDq1pJxP5tByjATbzWQykxyaKoBv+xSiflZN\nlCBJdnhlSWp0MaXDnGEUCbXGw0BhYb15WYuVFMu2Be0Xog7IApFz62Mi/fOJiNZ1\nuEu+G89wnH+bIWdoPDn4xCCbg2yYWV8DFMuQbQQlfH6YdAVTRXVSukJ6zh1vFafL\nJicMMH4Lc7h81qg9mkd5uv7OrduZTIiSfy/aawADHBoR2qAcDA+lfW8scRMguUdo\nMCkEOhIcdwj31WI06eml+WrlpiYTWNEO3vsxoJVRevcn68TRS6Ifxxcx+G3xzN+g\nTsSFWPJ1FHfh5Wa9iOxD8A02b+VDtSGQXtCEXgNJ2QKBgQD+b/es5DswcbZWPXAa\n7uPWj8nd9oSOzNOZ1Ct/tv7bLN4hVt92GguYerlx3UmE7DdRllZjHPV9M8I0eFuS\nUD5E1UEUgAzA2iu9FRBzvaNDT/tdSjvcX41jrvoC8ijPBQcZo+xKBaVyhUP0E32r\n8l7jc3YAcIkqhMcWfwec7cYLAwKBgQD64gRHDa98X8TxRUqgMgwzNUClUZr2M14U\nE7SRObHVvGi7/U6UunWDyd4f/OoGsZ9Bt1RFQXRk+s01Ffc+wJehDI+BsXfoG+2c\nlqWzqdnEWXl6McjRySCCIDPRek+oAthrAUGz4Bq17GatoCmgsuq9XEQm97m6Yw60\n8yvhD1H1HQKBgByM/+PcsG+dMvK2bi/3goV/GQ3ZLcLAZTYrwr3QEQUTIdHn56df\nANIZY1nNlQRfZU24avUwOLPV7QLqRoxCiNo8e9MLE2NImAPdqzzxmLJi9Tfgrprp\n9fmrls5h0gZ47/UGmessewZAwgFPdpim19L6D9G4zwuAXr69fmMzozd1AoGAOjq5\nOXCguWJVCJbHklTrZftHLNe6+sfDXy+PqmFUuEIJoRBS68w3OEZjStNd0f3p88vE\nQGrHxCQ9+sNFZog26UdMC5MQPIw24zBH92JFy//kZQsnDCH9bJZi0Izt7hXy+ysI\nf+JU8MKUtlnFL6o3N4oxu0WmEu+o2zDRj2QJ5rUCgYEAssorzzaVcg/oLRdaNS+f\nRbyYZLf/jx6ARsjV7eGtwQbx73QskHgMRQrdZ7A/SHqo0VMnh7oJI+A+Ra3uzeP5\nqp4bUSX7GT6Ghwiot2lmlEiV+7qcz4q4csRNuZIibzZhzlXKHx+nhQlMABij+QP7\neoAFS2sQ0we42CtuE3T5t+E=\n-----END PRIVATE KEY-----\n",
  "client_email": "m-s-innovation@m-s-innovation.iam.gserviceaccount.com",
  "client_id": "103383350141430022428",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/m-s-innovation%40m-s-innovation.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';

const _investmentSpreadsheetId = '1e7L3fbD22fvgt8occb9sjXuXx5aV8Yxlc88tlPyMrfA';

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
