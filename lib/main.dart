import 'dart:convert';
import 'package:flutter/material.dart';
import 'student.dart';

void main() {
  runApp(const StateApp());
}

class StateApp extends StatelessWidget {
  const StateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student State & JSON',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFF8F1E7),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF8B6F47),
        ),
      ),
      home: const StudentPage(),
    );
  }
}

class StudentPage extends StatefulWidget {
  const StudentPage({super.key});

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  final List<Student> students = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController courseController = TextEditingController();

  int nextId = 1;

  void addStudent() {
    if (nameController.text.trim().isEmpty ||
        courseController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter student name and course'),
        ),
      );
      return;
    }

    Student student = Student(
      id: nextId,
      name: nameController.text.trim(),
      course: courseController.text.trim(),
    );

    // Student object → JSON
    Map<String, dynamic> data = student.toJson();
    String jsonData = jsonEncode(data);

    // JSON → Student object
    Map<String, dynamic> decodedData = jsonDecode(jsonData);
    Student newStudent = Student.fromJson(decodedData);

    print('JSON Data: $jsonData');

    setState(() {
      students.add(newStudent);
      nextId++;
    });

    nameController.clear();
    courseController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${newStudent.name} added successfully'),
      ),
    );
  }

  void removeStudent(int index) {
    String name = students[index].name;

    setState(() {
      students.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name removed'),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    courseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF8B6F47),
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          'Student State & JSON',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.school),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Input Card
            Card(
              elevation: 3,
              color: const Color(0xFFFFFBF5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Add New Student',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B5135),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Student Name',
                        prefixIcon: const Icon(Icons.person),
                        filled: true,
                        fillColor: const Color(0xFFF5EBDD),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    TextField(
                      controller: courseController,
                      decoration: InputDecoration(
                        labelText: 'Course',
                        prefixIcon: const Icon(Icons.menu_book),
                        filled: true,
                        fillColor: const Color(0xFFF5EBDD),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: addStudent,
                        icon: const Icon(Icons.add),
                        label: const Text(
                          'Add Student',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 22),

            // Student List Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Student List',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF5C4630),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8DCCB),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.people,
                        size: 18,
                        color: Color(0xFF8B6F47),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${students.length}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6B5135),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Student List
            Expanded(
              child: students.isEmpty
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 65,
                            color: Color(0xFFB89B76),
                          ),
                          SizedBox(height: 15),
                          Text(
                            'No students added yet',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF6D6D6D),
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Add a student using the form above',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: students.length,
                      itemBuilder: (context, index) {
                        final student = students[index];

                        return Card(
                          color: const Color(0xFFFFFBF5),
                          elevation: 2,
                          margin: const EdgeInsets.only(bottom: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: const Color(0xFF8B6F47),
                              child: Text(
                                '${student.id}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              student.name,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                const Icon(
                                  Icons.school,
                                  size: 16,
                                  color: Color(0xFF8B6F47),
                                ),
                                const SizedBox(width: 5),
                                Text(student.course),
                              ],
                            ),
                            trailing: IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(
                                Icons.delete_outline,
                                color: Colors.redAccent,
                              ),
                              onPressed: () => removeStudent(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}