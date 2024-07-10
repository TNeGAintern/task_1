import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String? selectedProject;
  String? projectDescription;
  String? fileName;

  final Map<String, String> projectDescriptions = {
    'E-paarvai': 'PROJECT DESCRIPTION: e-Paarvai Eye Cataract Detection Project is to develop an advanced, accurate, and accessible system for detecting cataracts at an early stage.',
    'Crop Detection': 'PROJECT DESCRIPTION: The Crop Detection Project aims to leverage advanced machine learning and computer vision techniques to accurately identify and classify different types of crops in agricultural fields.',
    'Pest Detection': 'PROJECT DESCRIPTION: The Pest Detection Project aims to develop and implement a comprehensive system for early detection and management of pests.',
  };

  void _onProjectChanged(String? value) {
    setState(() {
      selectedProject = value;
      projectDescription = projectDescriptions[value];
    });
  }

  void _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      setState(() {
        fileName = result.files.single.name;
      });
    }
  }

  void _onSubmit() {
    if (selectedProject != null && fileName != null) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Submission Successful'),
            content: Text('Project: $selectedProject\nFile: $fileName'),
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
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Please select a project and upload a valid file.'),
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
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'),
        backgroundColor: Color.fromARGB(255, 137, 184, 207),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown for selecting project
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: selectedProject,
                hint: Text('Select a project'),
                items: projectDescriptions.keys.map((String project) {
                  return DropdownMenuItem<String>(
                    value: project,
                    child: Text(project),
                  );
                }).toList(),
                onChanged: _onProjectChanged,
                decoration: InputDecoration(
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Project description text
            if (projectDescription != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  projectDescription!,
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            SizedBox(height: 16.0),
            // Button to pick file
            Container(
              width: 420, // Adjust this value as needed
              child: ElevatedButton(
                onPressed: _pickFile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 137, 184, 207),
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Upload Model File',
                  style: TextStyle(fontSize: 19, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            // Display selected file name
            if (fileName != null)
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Selected file: $fileName',
                  style: TextStyle(fontSize: 16.0),
                ),
              ),
            SizedBox(height: 16.0),
            // Predict button
            ElevatedButton(
              onPressed: () {
                if (selectedProject != null) {
                  Navigator.pushNamed(
                    context,
                    '/upload_image',
                    arguments: selectedProject, // Pass selected project name
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 137, 184, 207),
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Predict',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
