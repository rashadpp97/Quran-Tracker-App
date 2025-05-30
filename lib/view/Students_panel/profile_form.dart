import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Add this import
import 'package:quran_progress_tracker_app/view/Students_panel/login_page.dart';
import 'package:quran_progress_tracker_app/view/Students_panel/std_performanse_page.dart';


class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  _ProfileFormPageState createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _usernameController = TextEditingController();
  String _selectedClass = 'Class Name'; // Default selected class
  final _centerController = TextEditingController();
  final _fatherController = TextEditingController();
  final _guardiancontactController = TextEditingController();
  final _addressController = TextEditingController();
  
  // Add this to track loading state
  bool _isLoading = false;

  // List of available classes
  final List<String> _classes = [
    'Class Name',
    'حلقة ابو بكر الصديق',
    'حلقة عمر بن الخطاب',
    'حلقة عثمان بن عفان',
    'حلقة علي بن ابي طالب',
  ];

  @override
  void dispose() {
    _usernameController.dispose();
    _centerController.dispose();
    _fatherController.dispose();
    _guardiancontactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> signUp() async {
    // Validate input fields
    if (_usernameController.text.isEmpty ||
        _selectedClass == 'Class Name' ||
        _centerController.text.isEmpty ||
        _fatherController.text.isEmpty ||
        _guardiancontactController.text.isEmpty ||
        _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Generate a unique ID for the student
      final String studentId = FirebaseFirestore.instance.collection('students').doc().id;
      
      // Create a map of student data
      final studentData = {
        'id': studentId,
        'name': _usernameController.text.trim(),
        'class': _selectedClass,
        'center': _centerController.text.trim(),
        'fatherName': _fatherController.text.trim(),
        'guardianContact': _guardiancontactController.text.trim(),
        'address': _addressController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      // Save to Firestore
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .set(studentData);

      if (context.mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile created successfully!")),
        );
        
        // Navigate to Login Screen
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (_) => StudentsPerformancePage(
                  name: '', 
                  className: '', 
                  image: '',    
                    )));
                    // builder: (_) => LoginScreen(
                    //   studentName: _usernameController.text,
                    //   className: _selectedClass,
                    //   image: '',
                    // )));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Registration failed: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 95, 132, 233), // Light blue
              Color.fromARGB(255, 31, 66, 194), // Slightly darker blue
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background bubbles
            Positioned(
              top: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Positioned(
              bottom: 50,
              right: -20,
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
              ),
            ),

            // Main content
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        RichText(
                          text: const TextSpan(
                            children: [
                              TextSpan(
                                text: 'Enter your ',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 188, 199, 207),
                                ),
                              ),
                              TextSpan(
                                text: 'Details',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w500,
                                  color: Color.fromARGB(255, 211, 230, 248),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),
                        _buildInputField(
                          controller: _usernameController,
                          hintText: 'User Name',
                          prefixIcon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        _buildClassDropdown(),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _centerController,
                          hintText: 'Center',
                          prefixIcon: Icons.home,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _fatherController,
                          hintText: 'Father Name',
                          prefixIcon: Icons.person_2,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _guardiancontactController,
                          hintText: "Guardian's Contact",
                          prefixIcon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        const SizedBox(height: 16),
                        _buildInputField(
                          controller: _addressController,
                          hintText: "Home Address",
                          prefixIcon: Icons.home_outlined,
                        ),
                        const SizedBox(height: 30),
                        _buildCreateProfileButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            
            // Show loading indicator when processing
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildClassDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Icon(
            Icons.school,
            color: Colors.black,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedClass,
                icon: const Icon(Icons.arrow_drop_down),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.black),
                isExpanded: true,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedClass = newValue!;
                  });
                },
                items: _classes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                hint: const Text(
                  'Select Class',
                  style: TextStyle(color: Colors.black54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          prefixIcon: Icon(
            prefixIcon,
            color: Colors.black,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCreateProfileButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : signUp, // Call signUp method instead of navigation
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 9, 138, 243),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: _isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Create Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}