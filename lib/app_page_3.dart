import 'package:flutter/material.dart';

import 'app_page_2.dart';
import 'app_page_4.dart';

void main() {
  runApp(const StudentsNameListPage());
}

class StudentsNameListPage extends StatelessWidget {
  const StudentsNameListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentDetailsScreen(),
    );
  }
}

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({super.key});

  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen> {
  final List<Map<String, String>> students = [
    {"name": "Salman Faris", "image": "assets/Salman.png"},
    {"name": "Basheer Ahmed", "image": "assets/Basheer.png"},
    {
      "name": "Ihthisham Ibrahim",
      "image": "assets/Ihthisham.png"
    },
    {"name": "Muad Anwar", "image": "assets/Muad.png"},
    {"name": "Adil Saleem", "image": "assets/Adhil.png"},
    {"name": "Nehan", "image": "assets/Nehan.png"},
    {"name": "Misbaah", "image": "assets/Misbaah.png"},
    {"name": "Hadi Hassan", "image": "assets/Hadi Hassan.png"},
    {
      "name": "Fouzan Sidhique",
      "image": "assets/Fouzan Sidhique.png"
    },
    {"name": "Raihan", "image": "assets/Raihan.png"},
     {"name": "Adnan", "image": "assets/Adnan.png"},
    {"name": "Ajsal", "image": "assets/Ajsal.png"},
    {
      "name": "Ajwad",
      "image": "assets/Ajwad.png"
    },
    {"name": "Amlah", "image": "assets/Amlah.png"},
    {"name": "Arshad", "image": "assets/Arshad.png"},
    {"name": "Azim ck", "image": "assets/Azim_ck.png"},
    {"name": "Faheem c", "image": "assets/Faheem_c.png"},
    {"name": "Faris", "image": "assets/Faris.png"},
    {
      "name": "Hafeez",
      "image": "assets/Hafeez.png"
    },
    {"name": "Hanoon", "image": "assets/Hanoon.png"},
    {"name": "Ibrahim", "image": "assets/Ibrahim.png"},
    {"name": "Sulthan",  "image": "assets/Sulthan.png"},
    {
      "name": "Thwalha",
      "image": "assets/Thwalha.png"
    },
    {"name": "Yahya", "image": "assets/Yahya.png"},
    {"name": "Zayan", "image": "assets/Zayan.png"},
  ];

  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredStudents = students
        .where((student) =>
  student["name"]!.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios, // iOS-style back button icon
              color: Colors.black, // Set the color of the icon
            ),
            onPressed: () {
              // Navigate to StudentDetailsApp
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainOptionPage(),
                ),
              );
            }),
        title: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: "List of ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: " Soq Students",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Background with Image
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/qaf picture.jpg'), // Update with the correct image path
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value; // Update the search query
                });
              },
              decoration: InputDecoration(
                hintText: "Search Students...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Total Students: ${filteredStudents.length}",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          const SizedBox(height: 10),
          // Student List
          Expanded(
            child: ListView.separated(
              itemCount: filteredStudents.length,
              separatorBuilder: (context, index) => const Divider(height: 12),
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage(student["image"]!),
                  ),
                  title: Text(
                    student["name"]!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // subtitle: Text(
                  //   student["id"]!,
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     color: Colors.grey[600],
                  //   ),
                  // ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          studentName: student["name"]!,
                          // studentId: student["id"]!, 
                          className: student['className']??"", image: student['image']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
