import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

const _revenueCredentials = r'''
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

const _revenueSpreadsheetId = '1e7L3fbD22fvgt8occb9sjXuXx5aV8Yxlc88tlPyMrfA';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Revenue Tracker',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: RevenueSection(),
    );
  }
}

class RevenueSection extends StatefulWidget {
  @override
  _RevenueSectionState createState() => _RevenueSectionState();
}

class _RevenueSectionState extends State<RevenueSection> {
  final GSheets _gsheets = GSheets(_revenueCredentials);
  Worksheet? _revenueSheet;
  TextEditingController _nameController = TextEditingController();
  TextEditingController _productController = TextEditingController();
  TextEditingController _colourController = TextEditingController();
  TextEditingController _gramsController = TextEditingController();
  TextEditingController _orderDateController = TextEditingController();
  TextEditingController _deliveryDateController = TextEditingController();
  TextEditingController _costController = TextEditingController();
  TextEditingController _deliveryChargesController = TextEditingController();
  TextEditingController _discountController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _contactNumberController = TextEditingController();
  List<List<String>> _revenueData = [];
  bool _isAddingRevenue = false;

  @override
  void initState() {
    super.initState();
    _loadRevenueSheet();
  }

  Future<void> _loadRevenueSheet() async {
    final ss = await _gsheets.spreadsheet(_revenueSpreadsheetId);
    _revenueSheet = ss.worksheetByTitle('revenue');
    await _refreshRevenueData();
  }

  Future<void> _refreshRevenueData() async {
    if (_revenueSheet == null) {
      return;
    }

    final values = await _revenueSheet!.values.allRows();
    setState(() {
      _revenueData = values;
    });
  }

  Future<void> _createRevenue() async {
    if (_revenueSheet == null) {
      return;
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final rowData = [
      formattedDate,
      _nameController.text,
      _productController.text,
      _colourController.text,
      _gramsController.text,
      _orderDateController.text,
      _deliveryDateController.text,
      _costController.text,
      _deliveryChargesController.text,
      _discountController.text,
      _priceController.text,
      _contactNumberController.text,
    ];

    // Check if any required field is empty
    if (rowData.any((value) => value.isEmpty)) {
      // Display an error message or handle it as needed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }
    await _revenueSheet!.values.appendRow(rowData);
    _clearControllers();
    await _refreshRevenueData();
  }

  Future<void> _updateRevenue(String date) async {
    if (_revenueSheet == null) {
      return;
    }

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

    final updatedRowData = [
      formattedDate, // Format the date here
      _nameController.text,
      _productController.text,
      _colourController.text,
      _gramsController.text,
      _orderDateController.text,
      _deliveryDateController.text,
      _costController.text,
      _deliveryChargesController.text,
      _discountController.text,
      _priceController.text,
      _contactNumberController.text,
    ];

    // Check if any required field is empty
    if (updatedRowData.any((value) => value.isEmpty)) {
      // Display an error message or handle it as needed
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please fill in all required fields.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
      return;
    }

    final rowIndex = _revenueData.indexWhere((rowData) => rowData[0] == date);

    if (rowIndex != -1) {
      _revenueData[rowIndex] = updatedRowData;

      // Update only the specific row without clearing the entire sheet
      await _revenueSheet!.values.insertRow(rowIndex + 2,
          updatedRowData); // Add 2 to account for header and 0-based index

      _clearControllers();
      await _refreshRevenueData();
    }
  }

  Future<void> _deleteRevenue(String date) async {
    if (_revenueSheet == null) {
      return;
    }

    _revenueData.removeWhere((rowData) => rowData[0] == date);

    await _revenueSheet!.clear();
    await _revenueSheet!.values.appendRow([
      'Date',
      'Name',
      'Product',
      'Colour',
      'Grams',
      'Order Date',
      'Delivery Date',
      'Cost',
      'Delivery Charges',
      'Discount',
      'Price',
      'Contact Number'
    ]);

    for (final rowData in _revenueData) {
      await _revenueSheet!.values.appendRow(rowData);
    }

    _clearControllers();
    await _refreshRevenueData();
  }

  void _clearControllers() {
    _nameController.clear();
    _productController.clear();
    _colourController.clear();
    _gramsController.clear();
    _orderDateController.clear();
    _deliveryDateController.clear();
    _costController.clear();
    _deliveryChargesController.clear();
    _discountController.clear();
    _priceController.clear();
    _contactNumberController.clear();
  }

  void _openExcelSheet() async {
    const excelURL = 'https://docs.google.com/spreadsheets/d/your-spreadsheet-id/edit?usp=sharing';
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

  void _toggleAddingRevenue() {
    setState(() {
      _isAddingRevenue = !_isAddingRevenue;
      if (!_isAddingRevenue) {
        _clearControllers();
      }
    });
  }

  Widget _buildAddRevenueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add Revenue Entry',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Name'),
        ),
        TextField(
          controller: _productController,
          decoration: InputDecoration(labelText: 'Product'),
        ),
        TextField(
          controller: _colourController,
          decoration: InputDecoration(labelText: 'Colour'),
        ),
        TextField(
          controller: _gramsController,
          decoration: InputDecoration(labelText: 'Grams'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _orderDateController,
          decoration: InputDecoration(labelText: 'Order Date'),
          keyboardType: TextInputType.datetime,
        ),
        TextField(
          controller: _deliveryDateController,
          decoration: InputDecoration(labelText: 'Delivery Date'),
          keyboardType: TextInputType.datetime,
        ),
        TextField(
          controller: _costController,
          decoration: InputDecoration(labelText: 'Cost'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _deliveryChargesController,
          decoration: InputDecoration(labelText: 'Delivery Charges'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _discountController,
          decoration: InputDecoration(labelText: 'Discount'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _priceController,
          decoration: InputDecoration(labelText: 'Price'),
          keyboardType: TextInputType.number,
        ),
        TextField(
          controller: _contactNumberController,
          decoration: InputDecoration(labelText: 'Contact Number'),
          keyboardType: TextInputType.phone,
        ),
        SizedBox(height: 16.0),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text
                .isEmpty /* Check other field emptiness */) {
              return;
            }
            _createRevenue();
            _toggleAddingRevenue();
          },
          child: Text('Add Revenue Entry'),
        ),
        SizedBox(height: 16.0),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Revenue Tracker')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: _toggleAddingRevenue,
              child: Text(
                  _isAddingRevenue ? 'Cancel Adding' : 'Add Revenue Entry'),
            ),
            if (_isAddingRevenue) ...[
              // Section for adding a new revenue entry
              Text(
                'Add Revenue Entry',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _productController,
                decoration: InputDecoration(labelText: 'Product'),
              ),
              TextField(
                controller: _colourController,
                decoration: InputDecoration(labelText: 'Colour'),
              ),
              TextField(
                controller: _gramsController,
                decoration: InputDecoration(labelText: 'Grams'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _orderDateController,
                decoration: InputDecoration(labelText: 'Order Date'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _deliveryDateController,
                decoration: InputDecoration(labelText: 'Delivery Date'),
                keyboardType: TextInputType.datetime,
              ),
              TextField(
                controller: _costController,
                decoration: InputDecoration(labelText: 'Cost'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _deliveryChargesController,
                decoration: InputDecoration(labelText: 'Delivery Charges'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _discountController,
                decoration: InputDecoration(labelText: 'Discount'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text
                      .isEmpty /* Check other field emptiness */) {
                    return;
                  }
                  _createRevenue();
                  _toggleAddingRevenue();
                },
                child: Text('Add Revenue Entry'),
              ),
              SizedBox(height: 16.0),
            ] else
              ...[
                // Section for displaying revenue entries
                Text(
                  'Revenue Entries',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                // Revenue Entries List
                Expanded(
                  child: ListView.builder(
                    itemCount: _revenueData.length,
                    itemBuilder: (context, index) {
                      final rowData = _revenueData[index];
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
                              Text('Product: ${rowData[2]}'), // Product
                              Text('Colour: ${rowData[3]}'), // Colour
                              Text('Grams: ${rowData[4]}'), // Grams
                              // Add other fields similarly
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
                                  _productController.text = rowData[2];
                                  _colourController.text = rowData[3];
                                  _gramsController.text = rowData[4];
                                  _orderDateController.text = rowData[5];
                                  _deliveryDateController.text = rowData[6];
                                  _costController.text = rowData[7];
                                  _deliveryChargesController.text = rowData[8];
                                  _discountController.text = rowData[9];
                                  _priceController.text = rowData[10];
                                  _contactNumberController.text = rowData[11];
                                  // Show a dialog to edit the revenue entry
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text('Edit Revenue Entry'),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Add your TextFields for each field here
                                            // Example:
                                            TextField(
                                              controller: _nameController,
                                              decoration: InputDecoration(
                                                  labelText: 'Name'),
                                            ),
                                            // ... Repeat the above TextField for other fields
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
                                              if (_nameController.text
                                                  .isEmpty /* Check other field emptiness */) {
                                                return;
                                              }
                                              _updateRevenue(rowData[0]);
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
                                onPressed: () =>
                                    _deleteRevenue(
                                        rowData[0]), // Pass the date to delete
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Display total revenue amount here
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    const excelURL = 'https://docs.google.com/spreadsheets/d/1e7L3fbD22fvgt8occb9sjXuXx5aV8Yxlc88tlPyMrfA/edit?usp=sharing';
                    launch(excelURL);
                  },
                  child: Text('Open Excel Sheet'),
                ),
              ],
          ],
        ),
      ),
    );
  }
}

