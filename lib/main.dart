import 'package:flutter/material.dart';
import 'package:msinnovation/detail.dart';
import 'package:msinnovation/revenue.dart';
import 'expenditure.dart';
import 'investment.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      home: BottomNavigationApp(),
    );
  }
}

class BottomNavigationApp extends StatefulWidget {
  @override
  _BottomNavigationAppState createState() => _BottomNavigationAppState();
}

class _BottomNavigationAppState extends State<BottomNavigationApp> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    DetailSection(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'MS Innovation',
          style: TextStyle(
            color: Colors.white, // Customize text color
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.blue.shade800, Colors.blue.shade500], // Add gradient colors
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 5,
                offset: Offset(0, 3), // Customize shadow offset
              ),
            ],
          ),
        ),
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: Colors.blue, // Customize the selected item color
        unselectedItemColor: Colors.grey, // Customize the unselected item color
        backgroundColor: Colors.transparent, // Make background transparent
        elevation: 0, // Remove default shadow
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.details),
            label: 'Details',
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BoxButton(
            title: 'REVENUE',
            icon: Icons.attach_money,
            page: RevenueSection(),
            gradientColors: [Colors.green.shade400, Colors.green.shade700], // Add gradient colors
            shadowOffset: Offset(0, 5), // Adjust shadow offset
            backgroundImage: 'assets/revenue_background.jpg',
          ),
          SizedBox(height: 50),
          BoxButton(
            title: 'EXPENDITURE',
            icon: Icons.money_off,
            page: ExpenditureSection(),
            gradientColors: [Colors.red.shade400, Colors.red.shade700], // Add gradient colors
            shadowOffset: Offset(0, 5), // Adjust shadow offset
            backgroundImage: 'assets/expenditure_background.jpg',
          ),
          SizedBox(height: 50),
          BoxButton(
            title: 'INVESTMENT',
            icon: Icons.business_center,
            page: InvestmentSection(),
            gradientColors: [Colors.orange.shade400, Colors.orange.shade700], // Add gradient colors
            shadowOffset: Offset(0, 5), // Adjust shadow offset
            backgroundImage: 'assets/investment_background.jpg',
          ),
        ],
      ),
    );
  }
}

class BoxButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget page;
  final List<Color> gradientColors;
  final Offset shadowOffset;
  final String backgroundImage;

  BoxButton({
    required this.title,
    required this.icon,
    required this.page,
    required this.gradientColors,
    required this.shadowOffset,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Container(
        width: 200,
        height: 150,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10,
              offset: shadowOffset,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Stack(
            children: [
              Image.asset(
                backgroundImage,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 40,
                      color: Colors.white,
                    ),
                    SizedBox(height: 10),
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
