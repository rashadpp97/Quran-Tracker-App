import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Teachers_panel/edit_daily_report.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  String? selectedClass;
  List<String> classList = [
    'حلقة ابو بكر الصديق',
    'حلقة عمر بن الخطاب',
    'حلقة عثمان بن عفان',
    'حلقة علي بن ابي طالب',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'Student Information',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.indigo, Colors.indigo],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showEditClassesDialog(),
            tooltip: 'Edit Classes',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Section with Class Dropdown
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.teal.shade700],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.school,
                  size: 40,
                  color: Colors.white,
                ),
                SizedBox(height: 10),
                Text(
                  'Select Class to View Students',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedClass,
                    hint: Text(
                      'Select Class',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.class_, color: Colors.teal),
                    ),
                    items: classList.map((cls) {
                      return DropdownMenuItem(
                        value: cls,
                        child: Text(
                          cls,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedClass = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),

          // Students List Section
          Expanded(
            child: selectedClass == null
                ? _buildEmptyState()
                : FutureBuilder<QuerySnapshot>(
                    future: FirebaseFirestore.instance
                        .collection('students')
                        .where('class', isEqualTo: selectedClass)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return _buildLoadingState();
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return _buildNoStudentsState();
                      }

                      return _buildStudentsList(snapshot.data!.docs);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // Dialog to edit class names
  void _showEditClassesDialog() {
    List<String> tempClassList = List.from(classList);
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Edit Classes'),
              content: Container(
                width: double.maxFinite,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: tempClassList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              title: TextFormField(
                                initialValue: tempClassList[index],
                                onChanged: (value) {
                                  tempClassList[index] = value;
                                },
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Class name',
                                ),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setStateDialog(() {
                                    tempClassList.removeAt(index);
                                  });
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton.icon(
                      onPressed: () {
                        setStateDialog(() {
                          tempClassList.add('New Class');
                        });
                      },
                      icon: Icon(Icons.add),
                      label: Text('Add Class'),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      classList = tempClassList.where((c) => c.isNotEmpty).toList();
                      if (selectedClass != null && !classList.contains(selectedClass)) {
                        selectedClass = null;
                      }
                    });
                    Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Show edit student dialog
  void _showEditStudentDialog(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    
    // Controllers for editing
    final nameController = TextEditingController(text: data['name'] ?? '');
    final centerController = TextEditingController(text: data['center'] ?? '');
    final fatherNameController = TextEditingController(text: data['fatherName'] ?? '');
    final guardianContactController = TextEditingController(text: data['guardianContact'] ?? '');
    final addressController = TextEditingController(text: data['address'] ?? '');
    String selectedStudentClass = data['class'] ?? selectedClass ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: Text('Edit Student Information'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Student Name',
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: classList.contains(selectedStudentClass) ? selectedStudentClass : null,
                      decoration: InputDecoration(
                        labelText: 'Class',
                        prefixIcon: Icon(Icons.class_),
                        border: OutlineInputBorder(),
                      ),
                      items: classList.map((cls) {
                        return DropdownMenuItem(
                          value: cls,
                          child: Text(cls),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setStateDialog(() {
                          selectedStudentClass = value ?? '';
                        });
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: centerController,
                      decoration: InputDecoration(
                        labelText: 'Center',
                        prefixIcon: Icon(Icons.business),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: fatherNameController,
                      decoration: InputDecoration(
                        labelText: 'Father\'s Name',
                        prefixIcon: Icon(Icons.family_restroom),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: guardianContactController,
                      decoration: InputDecoration(
                        labelText: 'Guardian Contact',
                        prefixIcon: Icon(Icons.phone),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: addressController,
                      decoration: InputDecoration(
                        labelText: 'Address',
                        prefixIcon: Icon(Icons.home),
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await FirebaseFirestore.instance
                          .collection('students')
                          .doc(doc.id)
                          .update({
                        'name': nameController.text.trim(),
                        'class': selectedStudentClass,
                        'center': centerController.text.trim(),
                        'fatherName': fatherNameController.text.trim(),
                        'guardianContact': guardianContactController.text.trim(),
                        'address': addressController.text.trim(),
                      });
                      
                      Navigator.pop(context);
                      setState(() {}); // Refresh the list
                      
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Student information updated successfully'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error updating student: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'Please select a class',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Choose a class from the dropdown above\nto view student information',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
          ),
          SizedBox(height: 20),
          Text(
            'Loading students...',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNoStudentsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          SizedBox(height: 20),
          Text(
            'No students found',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'There are no students in $selectedClass',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStudentsList(List<QueryDocumentSnapshot> docs) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: docs.length,
      itemBuilder: (context, index) {
        final data = docs[index].data() as Map<String, dynamic>;

        return Container(
          margin: EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 15,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Student Header with Edit Button
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DailyReportControlPage(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [Colors.indigo, Colors.teal.shade300],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: Icon(
                                Icons.person,
                                color: Colors.white,
                                size: 25,
                              ),
                            ),
                            SizedBox(width: 15),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    data['name'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.indigo.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      data['class'] ?? '',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.indigo,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Edit Button
                    IconButton(
                      onPressed: () => _showEditStudentDialog(docs[index]),
                      icon: Icon(
                        Icons.edit,
                        color: Colors.indigo,
                        size: 20,
                      ),
                      tooltip: 'Edit Student',
                    ),
                  ],
                ),

                SizedBox(height: 20),

                // Student Details
                _buildInfoRow(Icons.business, 'Center',
                    data['center'] ?? 'Not specified'),
                SizedBox(height: 12),
                _buildInfoRow(Icons.family_restroom, 'Father\'s Name',
                    data['fatherName'] ?? 'Not specified'),
                SizedBox(height: 12),
                _buildInfoRow(Icons.phone, 'Guardian Contact',
                    data['guardianContact'] ?? 'Not specified'),
                SizedBox(height: 12),
                _buildInfoRow(
                    Icons.home, 'Address', data['address'] ?? 'Not specified'),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}