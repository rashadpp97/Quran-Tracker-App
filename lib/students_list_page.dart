import 'package:flutter/material.dart';

class StudentDetails extends StatelessWidget {
  final List<Student> students = [
    Student(
      name: 'Sathyana Weerasinghe',
      id: '5461382',
      avatarColor: Colors.pink[100],
    ),
    Student(
      name: 'Mayura Goonarathne',
      id: '2367891',
      avatarColor: Colors.grey[900],
    ),
    Student(
      name: 'Sangi Kumarasiri',
      id: '3291820',
      avatarColor: Colors.green,
    ),
    Student(
      name: 'Gayali Alahakoon',
      id: '4382909',
      avatarColor: Colors.pink[50],
    ),
    Student(
      name: 'Enuki Kiyara',
      id: '1132737',
      avatarColor: Colors.grey[400],
    ),
    Student(
      name: 'Daham Peiris',
      id: '507895',
      avatarColor: Colors.orange,
    ),
    Student(
      name: 'Sanuli Lavanya',
      id: '4263182',
      avatarColor: Colors.blue,
    ),
    Student(
      name: 'Mr. Beast',
      id: '1984200',
      avatarColor: Colors.purple[900],
    ),
  ];

   StudentDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Details of your ',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Students',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Total Students Assigned: ${students.length}',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundColor: students[index].avatarColor,
                          ),
                          SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                students[index].name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                students[index].id,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Student {
  final String name;
  final String id;
  final Color? avatarColor;

  Student({
    required this.name,
    required this.id,
    this.avatarColor,
  });
}