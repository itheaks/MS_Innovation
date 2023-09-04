// import 'package:flutter/material.dart';
// import 'package:gsheets/gsheets.dart';
//
// const _credentials = r'''
// {
//   "type": "service_account",
//   "project_id": "m-s-innovation",
//   "private_key_id": "64cc0027e21e7d07ecf350347a55a39ec9f53eb9",
//   "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQD5Wfr33AnHz4uo\nmgzFaQeXK30KC3TyzMgMzx/eadTdrEzS6SauymEAEgY4NV1Vy9w1YP3Xv2FkwIxY\nMRV19nbiM+HenR8K2mB2JjyAg7mEOdEO6Xr3VLXiDReijcyPM25XOhNe+niJRT72\nBfCm/8gdfn7sjAsRGVxYMuS090VDKHPO8eq8dkXLsyTBhIGYu1Kc2aRpwiQGVKTh\n5gQd/hj76Bfk3VDxN8ESIOEPjFmo/a/85x2yZxJG83ieiO1hDcvcIk7ajP8LozhT\nhQzph4NXKYqrb2XadtrRzHdxOJR+DsQ85l8LBYwRTX1H3/7SfymRJoA4V4nleogF\nEUcg7B5XAgMBAAECggEAJeoNpBR8FDq1pJxP5tByjATbzWQykxyaKoBv+xSiflZN\nlCBJdnhlSWp0MaXDnGEUCbXGw0BhYb15WYuVFMu2Be0Xog7IApFz62Mi/fOJiNZ1\nuEu+G89wnH+bIWdoPDn4xCCbg2yYWV8DFMuQbQQlfH6YdAVTRXVSukJ6zh1vFafL\nJicMMH4Lc7h81qg9mkd5uv7OrduZTIiSfy/aawADHBoR2qAcDA+lfW8scRMguUdo\nMCkEOhIcdwj31WI06eml+WrlpiYTWNEO3vsxoJVRevcn68TRS6Ifxxcx+G3xzN+g\nTsSFWPJ1FHfh5Wa9iOxD8A02b+VDtSGQXtCEXgNJ2QKBgQD+b/es5DswcbZWPXAa\n7uPWj8nd9oSOzNOZ1Ct/tv7bLN4hVt92GguYerlx3UmE7DdRllZjHPV9M8I0eFuS\nUD5E1UEUgAzA2iu9FRBzvaNDT/tdSjvcX41jrvoC8ijPBQcZo+xKBaVyhUP0E32r\n8l7jc3YAcIkqhMcWfwec7cYLAwKBgQD64gRHDa98X8TxRUqgMgwzNUClUZr2M14U\nE7SRObHVvGi7/U6UunWDyd4f/OoGsZ9Bt1RFQXRk+s01Ffc+wJehDI+BsXfoG+2c\nlqWzqdnEWXl6McjRySCCIDPRek+oAthrAUGz4Bq17GatoCmgsuq9XEQm97m6Yw60\n8yvhD1H1HQKBgByM/+PcsG+dMvK2bi/3goV/GQ3ZLcLAZTYrwr3QEQUTIdHn56df\nANIZY1nNlQRfZU24avUwOLPV7QLqRoxCiNo8e9MLE2NImAPdqzzxmLJi9Tfgrprp\n9fmrls5h0gZ47/UGmessewZAwgFPdpim19L6D9G4zwuAXr69fmMzozd1AoGAOjq5\nOXCguWJVCJbHklTrZftHLNe6+sfDXy+PqmFUuEIJoRBS68w3OEZjStNd0f3p88vE\nQGrHxCQ9+sNFZog26UdMC5MQPIw24zBH92JFy//kZQsnDCH9bJZi0Izt7hXy+ysI\nf+JU8MKUtlnFL6o3N4oxu0WmEu+o2zDRj2QJ5rUCgYEAssorzzaVcg/oLRdaNS+f\nRbyYZLf/jx6ARsjV7eGtwQbx73QskHgMRQrdZ7A/SHqo0VMnh7oJI+A+Ra3uzeP5\nqp4bUSX7GT6Ghwiot2lmlEiV+7qcz4q4csRNuZIibzZhzlXKHx+nhQlMABij+QP7\neoAFS2sQ0we42CtuE3T5t+E=\n-----END PRIVATE KEY-----\n",
//   "client_email": "m-s-innovation@m-s-innovation.iam.gserviceaccount.com",
//   "client_id": "103383350141430022428",
//   "auth_uri": "https://accounts.google.com/o/oauth2/auth",
//   "token_uri": "https://oauth2.googleapis.com/token",
//   "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
//   "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/m-s-innovation%40m-s-innovation.iam.gserviceaccount.com",
//   "universe_domain": "googleapis.com"
// }
// ''';
// const _spreadsheetId = '1e7L3fbD22fvgt8occb9sjXuXx5aV8Yxlc88tlPyMrfA';
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Expenditure App',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: ExpenditureSection(),
//     );
//   }
// }
//
// class ExpenditureSection extends StatefulWidget {
//   @override
//   _ExpenditureSectionState createState() => _ExpenditureSectionState();
// }
//
// class _ExpenditureSectionState extends State<ExpenditureSection> {
//   final GSheets _gsheets = GSheets(_credentials);
//   Worksheet? _expenditureSheet;
//   TextEditingController _productController = TextEditingController();
//   TextEditingController _rateController = TextEditingController();
//   TextEditingController _quantityController = TextEditingController();
//   TextEditingController _commentController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _loadExpenditureSheet();
//   }
//
//   Future<void> _loadExpenditureSheet() async {
//     final ss = await _gsheets.spreadsheet(_spreadsheetId);
//     _expenditureSheet = ss.worksheetByTitle('expenditure');
//   }
//
//   Future<void> _createExpenditure() async {
//     if (_expenditureSheet == null) {
//       return;
//     }
//
//     final now = DateTime.now();
//     final amount = (double.parse(_rateController.text) * double.parse(_quantityController.text)).toString();
//
//     final rowData = [
//       now.toString(), // Date
//       _productController.text, // Product
//       _quantityController.text, // Quantity
//       _rateController.text, // Rate
//       _commentController.text, // Comment
//       amount, // Amount
//     ];
//
//     await _expenditureSheet!.values.appendRow(rowData);
//     _clearControllers();
//   }
//
//   void _clearControllers() {
//     _productController.clear();
//     _rateController.clear();
//     _quantityController.clear();
//     _commentController.clear();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Expenditure Section')),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: _productController,
//               decoration: InputDecoration(labelText: 'Product'),
//             ),
//             TextField(
//               controller: _rateController,
//               decoration: InputDecoration(labelText: 'Rate'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _quantityController,
//               decoration: InputDecoration(labelText: 'Quantity'),
//               keyboardType: TextInputType.number,
//             ),
//             TextField(
//               controller: _commentController,
//               decoration: InputDecoration(labelText: 'Comment'),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: _createExpenditure,
//               child: Text('Add Expenditure'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
