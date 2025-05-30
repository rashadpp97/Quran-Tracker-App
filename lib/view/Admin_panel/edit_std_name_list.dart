import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../second_page.dart';
import '../Students_panel/login_page.dart';


class StudentsNameListControlPage extends StatelessWidget {
  const StudentsNameListControlPage({super.key});

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
  List<Map<String, String>> students = [];
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Load students from SharedPreferences
  Future<void> _loadStudents() async {
    final prefs = await SharedPreferences.getInstance();
    final studentsJson = prefs.getString('students');
    if (studentsJson != null) {
      final List<dynamic> decoded = json.decode(studentsJson);
      setState(() {
        students = decoded.map((item) => Map<String, String>.from(item)).toList();
      });
    } else {
      // Initial student list if no saved data
      setState(() {
        students = [
          {"name": "Salman Faris", "image": "assets/Salman.png"},
          {"name": "Basheer Ahmed", "image": "assets/Basheer.png"},
          {"name": "Ihthisham Ibrahim", "image": "assets/Ihthisham.png"},
          {"name": "Muad Anwar", "image": "assets/Muad.png"},
          {"name": "Adil Saleem", "image": "assets/Adhil.png"},
          {"name": "Nehan", "image": "assets/Nehan.png"},
          {"name": "Misbaah", "image": "assets/Misbaah.png"},
          {"name": "Hadi Hassan", "image": "assets/Hadi Hassan.png"},
          {"name": "Fouzan Sidhique", "image": "assets/Fouzan Sidhique.png"},
          {"name": "Raihan", "image": "assets/Raihan.png"},
          {"name": "Adnan", "image": "assets/Adnan.png"},
          {"name": "Ajsal", "image": "assets/Ajsal.png"},
          {"name": "Ajwad", "image": "assets/Ajwad.png"},
          {"name": "Amlah", "image": "assets/Amlah.png"},
          {"name": "Arshad", "image": "assets/Arshad.png"},
          {"name": "Azim ck", "image": "assets/Azim_ck.png"},
          {"name": "Faheem c", "image": "assets/Faheem_c.png"},
          {"name": "Faris", "image": "assets/Faris.png"},
          {"name": "Hafeez", "image": "assets/Hafeez.png"},
          {"name": "Hanoon", "image": "assets/Hanoon.png"},
          {"name": "Ibrahim", "image": "assets/Ibrahim.png"},
          {"name": "Sulthan", "image": "assets/Sulthan.png"},
          {"name": "Thwalha", "image": "assets/Thwalha.png"},
          {"name": "Yahya", "image": "assets/Yahya.png"},
          {"name": "Zayan", "image": "assets/Zayan.png"},
        ];
      });
      _saveStudents(); // Save initial list
    }
  }

  // Save students to SharedPreferences
  Future<void> _saveStudents() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('students', json.encode(students));
  }

  Future<void> _addNewStudent(Map<String, String> studentData, File imageFile) async {
    try {
      // Get the application documents directory
      final directory = await getApplicationDocumentsDirectory();
      
      // Create a unique filename using timestamp
      final String fileName = 'student_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String filePath = '${directory.path}/$fileName';
      
      // Copy the image file to the app's directory
      await imageFile.copy(filePath);
      
      // Update the student data with the saved image path
      studentData['image'] = filePath;
      
      setState(() {
        students.add(studentData);
      });
      
      // Save the updated students list
      await _saveStudents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student added successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving student: $e')),
      );
    }
  }

  // Edit existing student
  Future<void> _editStudent(int index, Map<String, String> updatedData, File? newImageFile) async {
    try {
      // Make a copy of the student to edit
      Map<String, String> updatedStudent = Map<String, String>.from(students[index]);
      
      // Update the name
      updatedStudent['name'] = updatedData['name']!;
      
      // Update image if a new one was provided
      if (newImageFile != null) {
        final directory = await getApplicationDocumentsDirectory();
        final String fileName = 'student_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final String filePath = '${directory.path}/$fileName';
        
        await newImageFile.copy(filePath);
        updatedStudent['image'] = filePath;
        
        // Delete the old image file if it's not an asset image
        if (!students[index]['image']!.startsWith('assets/')) {
          try {
            final oldImageFile = File(students[index]['image']!);
            if (await oldImageFile.exists()) {
              await oldImageFile.delete();
            }
          } catch (e) {
            // Ignore errors when deleting old file
            print('Error deleting old image: $e');
          }
        }
      }
      
      setState(() {
        students[index] = updatedStudent;
      });
      
      await _saveStudents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating student: $e')),
      );
    }
  }

  // Delete student
  Future<void> _deleteStudent(int index) async {
    try {
      // If the image is not an asset, delete the file
      if (!students[index]['image']!.startsWith('assets/')) {
        try {
          final imageFile = File(students[index]['image']!);
          if (await imageFile.exists()) {
            await imageFile.delete();
          }
        } catch (e) {
          // Ignore errors when deleting file
          print('Error deleting image file: $e');
        }
      }
      
      setState(() {
        students.removeAt(index);
      });
      
      await _saveStudents();
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Student deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting student: $e')),
      );
    }
  }

  // Show the edit dialog
  void _showEditDialog(int index, Map<String, String> student) {
    final nameController = TextEditingController(text: student['name']);
    File? newImageFile;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Student'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StatefulBuilder(
                builder: (context, setState) => GestureDetector(
                  onTap: () async {
                    final picker = ImagePicker();
                    final pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                      imageQuality: 85,
                      maxWidth: 1000,
                    );
                    
                    if (pickedFile != null) {
                      setState(() {
                        newImageFile = File(pickedFile.path);
                      });
                    }
                  },
                  child: Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[200],
                    ),
                    child: newImageFile != null
                        ? ClipOval(
                            child: Image.file(
                              newImageFile!,
                              fit: BoxFit.cover,
                            ),
                          )
                        : ClipOval(
                            child: student["image"]!.startsWith('assets/')
                                ? Image(
                                    image: AssetImage(student["image"]!),
                                    fit: BoxFit.cover,
                                  )
                                : Image.file(
                                    File(student["image"]!),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedData = {
                'name': nameController.text.trim(),
              };
              
              if (nameController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Student name cannot be empty')),
                );
                return;
              }
              
              Navigator.pop(context);
              _editStudent(index, updatedData, newImageFile);
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteConfirmation(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Student'),
        content: Text('Are you sure you want to delete ${students[index]['name']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteStudent(index);
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredStudents = students
        .where((student) =>
            student["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainOptionPage()),
            );
          },
        ),
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
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddStudentScreen(onStudentAdded: _addNewStudent),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 150,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/qaf picture.jpg'),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
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
          Expanded(
            child: ListView.separated(
              itemCount: filteredStudents.length,
              separatorBuilder: (context, index) => const Divider(height: 12),
              itemBuilder: (context, index) {
                final student = filteredStudents[index];
                // Find the original index in the students list
                final originalIndex = students.indexWhere((s) => s["name"] == student["name"] && s["image"] == student["image"]);
                
                return ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundImage: student["image"]!.startsWith('assets/')
                        ? AssetImage(student["image"]!) as ImageProvider
                        : FileImage(File(student["image"]!)),
                  ),
                  title: Text(
                    student["name"]!,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => Container(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                leading: Icon(Icons.edit, color: Colors.blue),
                                title: Text('Edit'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _showEditDialog(originalIndex, student);
                                },
                              ),
                              ListTile(
                                leading: Icon(Icons.delete, color: Colors.red),
                                title: Text('Delete'),
                                onTap: () {
                                  Navigator.pop(context);
                                  _showDeleteConfirmation(originalIndex);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LoginScreen(
                          studentName: student["name"]!,
                          className: student['className'] ?? "",
                          image: student['image']!,
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

  ImageProvider _getStudentImage(String imagePath) {
    if (imagePath.startsWith('assets/')) {
      return AssetImage(imagePath);
    } else {
      return FileImage(File(imagePath));
    }
  }
}

class AddStudentScreen extends StatefulWidget {
  final Function(Map<String, String>, File) onStudentAdded;

  const AddStudentScreen({super.key, required this.onStudentAdded});

  @override
  _AddStudentScreenState createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _idController = TextEditingController();
  File? _imageFile;
  XFile? _webImage;
  final _picker = ImagePicker();
  bool _isSubmitting = false;

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1000,
      );
      if (pickedFile != null) {
        setState(() {
          if (kIsWeb) {
            _webImage = pickedFile;
          } else {
            _imageFile = File(pickedFile.path);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Widget _getImageWidget() {
    if (kIsWeb && _webImage != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          _webImage!.path,
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        ),
      );
    } else if (!kIsWeb && _imageFile != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.file(
          _imageFile!,
          fit: BoxFit.cover,
          height: 200,
          width: double.infinity,
        ),
      );
    }
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.add_a_photo, size: 50),
        SizedBox(height: 8),
        Text('Tap to select photo'),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_imageFile == null && !kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a photo')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final newStudent = {
        "name": _nameController.text,
        "image": "placeholder", // Will be updated with actual path
      };

      if (!kIsWeb && _imageFile != null) {
        await widget.onStudentAdded(newStudent, _imageFile!);
        Navigator.pop(context);
      } else if (kIsWeb && _webImage != null) {
        // Handle web image upload if needed
        // For web, you might need to implement a different approach
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Web image upload not implemented')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding student: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Student'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _getImageWidget(), // Use the image widget getter here
                ),
              ),

              SizedBox(height: 16),
             
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Student Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter student name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text('Add Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _idController.dispose();
    super.dispose();
  }
}