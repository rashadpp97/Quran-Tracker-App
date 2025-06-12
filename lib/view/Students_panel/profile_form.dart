import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quran_progress_tracker_app/view/Students_panel/std_performanse_page.dart';

class ProfileFormPage extends StatefulWidget {
  const ProfileFormPage({super.key});

  @override
  State<ProfileFormPage> createState() => _ProfileFormPageState();
}

class _ProfileFormPageState extends State<ProfileFormPage> {
  final _usernameController = TextEditingController();
  String _selectedClass = 'Class Name';
  final _centerController = TextEditingController();
  final _fatherController = TextEditingController();
  final _guardianContactController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;

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
    _guardianContactController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _createProfile() async {
    // Enhanced validation
    if (_usernameController.text.trim().isEmpty ||
        _selectedClass == 'Class Name' ||
        _centerController.text.trim().isEmpty ||
        _fatherController.text.trim().isEmpty ||
        _guardianContactController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check Firestore connection first
      print("Attempting to connect to Firestore...");
      
      // Test Firestore connection
      await FirebaseFirestore.instance.collection('test').doc('connection').get();
      print("Firestore connection successful");

      final studentId = FirebaseFirestore.instance.collection('students').doc().id;
      print("Generated student ID: $studentId");

      final studentData = {
        'id': studentId,
        'name': _usernameController.text.trim(),
        'class': _selectedClass,
        'center': _centerController.text.trim(),
        'fatherName': _fatherController.text.trim(),
        'guardianContact': _guardianContactController.text.trim(),
        'address': _addressController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      };

      print("Student data prepared: $studentData");

      // Create document with detailed error handling
      await FirebaseFirestore.instance
          .collection('students')
          .doc(studentId)
          .set(studentData);

      print("Document created successfully");

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile created successfully!"),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => StudentsPerformancePage(
              name: _usernameController.text.trim(),
              className: _selectedClass,
              image: '',
            ),
          ),
        );
      }
    } on FirebaseException catch (e) {
      // Specific Firebase errors
      print("Firebase Error: ${e.code} - ${e.message}");
      String errorMessage = "Registration failed: ";
      
      switch (e.code) {
        case 'permission-denied':
          errorMessage += "Permission denied. Check Firestore security rules.";
          break;
        case 'unavailable':
          errorMessage += "Service unavailable. Check internet connection.";
          break;
        case 'deadline-exceeded':
          errorMessage += "Request timeout. Please try again.";
          break;
        case 'unauthenticated':
          errorMessage += "Authentication required.";
          break;
        default:
          errorMessage += "${e.message}";
      }
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      // General errors
      print("General Error: $e");
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Registration failed: $e"),
            backgroundColor: Colors.black,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
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
              Color.fromARGB(255, 95, 132, 233),
              Color.fromARGB(255, 31, 66, 194),
            ],
          ),
        ),
        child: Stack(
          children: [
            _buildBackgroundBubbles(),
            SafeArea(child: _buildFormContent()),
            if (_isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Colors.white),
                      SizedBox(height: 16),
                      Text(
                        "Creating profile...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackgroundBubbles() {
    return Stack(
      children: [
        Positioned(
          top: -50,
          left: -50,
          child: _buildBubble(200),
        ),
        Positioned(
          bottom: 50,
          right: -20,
          child: _buildBubble(150),
        ),
      ],
    );
  }

  Widget _buildBubble(double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildFormContent() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Enter your ',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 188, 199, 207)),
                  ),
                  TextSpan(
                    text: 'Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 211, 230, 248)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            _buildInputField(_usernameController, 'User Name', Icons.person_outline),
            const SizedBox(height: 16),
            _buildClassDropdown(),
            const SizedBox(height: 16),
            _buildInputField(_centerController, 'Center', Icons.home),
            const SizedBox(height: 16),
            _buildInputField(_fatherController, 'Father Name', Icons.person_2),
            const SizedBox(height: 16),
            _buildInputField(_guardianContactController, "Guardian's Contact", Icons.phone, TextInputType.phone),
            const SizedBox(height: 16),
            _buildInputField(_addressController, 'Home Address', Icons.home_outlined),
            const SizedBox(height: 30),
            _buildCreateProfileButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    TextEditingController controller,
    String hintText,
    IconData icon, [
    TextInputType inputType = TextInputType.text,
  ]) {
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
        keyboardType: inputType,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black54),
          prefixIcon: Icon(icon, color: Colors.black),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
        ),
      ),
    );
  }

  Widget _buildClassDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedClass,
          icon: const Icon(Icons.arrow_drop_down),
          isExpanded: true,
          onChanged: (String? newValue) {
            setState(() {
              _selectedClass = newValue!;
            });
          },
          items: _classes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCreateProfileButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _createProfile,
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
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Create Profile',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}