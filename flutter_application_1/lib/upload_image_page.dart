import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  List<Uint8List?> _uploadedImages = [null, null];
  bool _isImageSubmitted = false;
  bool _showSubmitButton = true;
  final ImagePicker _picker = ImagePicker();
  List<String?> _grayscaleImageUrls = [null, null];
  String? _projectName;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as String?;
    setState(() {
      _projectName = args;
    });
  }

  Future<void> _pickImage(int index, ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _uploadedImages[index] = imageBytes;
          _isImageSubmitted = false;
          _showSubmitButton = true;
          _grayscaleImageUrls[index] = null;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> _uploadImages() async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:4000/upload'),
    );

    // Add the project name to the request
    if (_projectName != null) {
      request.fields['project_name'] = _projectName!;
    }

    // Add images to the request
    if (_projectName == 'E-paarvai') {
      for (int i = 0; i < _uploadedImages.length; i++) {
        if (_uploadedImages[i] != null) {
          request.files.add(http.MultipartFile.fromBytes(
            'image${i + 1}',
            _uploadedImages[i]!,
            filename: 'image${i + 1}.jpg',
          ));
        }
      }
    } else {
      // For single image projects
      if (_uploadedImages[0] != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image1',
          _uploadedImages[0]!,
          filename: 'image1.jpg',
        ));
      }
    }

    try {
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        setState(() {
          _isImageSubmitted = true;
          _showSubmitButton = false;
          if (_projectName == 'E-paarvai') {
            _grayscaleImageUrls = [
              'http://localhost:4000/image/${responseJson['filenames'][0]}',
              'http://localhost:4000/image/${responseJson['filenames'][1]}'
            ];
          } else {
            _grayscaleImageUrls = [
              'http://localhost:4000/image/${responseJson['filenames'][0]}'
            ];
          }
        });
        print('Grayscale image URLs: $_grayscaleImageUrls');
      } else {
        print('Upload failed: ${responseJson['error']}');
      }
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  void _showImageSourceDialog(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source', style: TextStyle(color: Color.fromARGB(255, 110, 183, 220))),
        contentPadding: EdgeInsets.all(16),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(index, ImageSource.camera);
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.camera_alt, color: Color.fromARGB(255, 110, 183, 220)),
                SizedBox(width: 8),
                Text('Take a Photo', style: TextStyle(color: Color.fromARGB(255, 73, 175, 226))),
              ],
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(index, ImageSource.gallery);
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.image, color: Color.fromARGB(255, 110, 183, 220)),
                SizedBox(width: 8),
                Text('Pick from Gallery', style: TextStyle(color: Color.fromARGB(255, 73, 175, 226))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEpaarvai = _projectName == 'E-paarvai';
    final isSingleImageProject = _projectName == 'Crop Detection' || _projectName == 'Pest Detection';

    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        backgroundColor: Color.fromARGB(255, 110, 183, 220),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                if (_projectName != null)
                  Text(
                    'Selected Project: $_projectName',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                SizedBox(height: 16),
                if (isEpaarvai) ...[
                  Text('Upload Left Eye Image'),
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(0),
                    child: _buildImageUploadContainer(0),
                  ),
                  SizedBox(height: 16),
                  Text('Upload Right Eye Image'),
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(1),
                    child: _buildImageUploadContainer(1),
                  ),
                ] else if (isSingleImageProject) ...[
                  Text('Upload Image'),
                  GestureDetector(
                    onTap: () => _showImageSourceDialog(0),
                    child: _buildImageUploadContainer(0),
                  ),
                ],
                SizedBox(height: 20),
                if (_uploadedImages.any((image) => image != null) && _showSubmitButton)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: _uploadImages,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 134, 196, 227),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Submit',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _uploadedImages = [null, null];
                            _isImageSubmitted = false;
                            _showSubmitButton = true;
                            _grayscaleImageUrls = [null, null];
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 203, 107, 100),
                          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                SizedBox(height: 20),
                if (_isImageSubmitted) ...[
                  Text(
                    'Info about the picture',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20),
                  if (isEpaarvai) ...[
                    if (_grayscaleImageUrls[0] != null) ...[
                      Text('Left Eye Image'),
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color.fromARGB(255, 137, 184, 207), width: 2),
                        ),
                        child: Image.network(
                          _grayscaleImageUrls[0]!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                    SizedBox(height: 16),
                    if (_grayscaleImageUrls[1] != null) ...[
                      Text('Right Eye Image'),
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color.fromARGB(255, 137, 184, 207), width: 2),
                        ),
                        child: Image.network(
                          _grayscaleImageUrls[1]!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ] else if (isSingleImageProject) ...[
                    if (_grayscaleImageUrls[0] != null) ...[
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Color.fromARGB(255, 137, 184, 207), width: 2),
                        ),
                        child: Image.network(
                          _grayscaleImageUrls[0]!,
                          width: 300,
                          height: 300,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageUploadContainer(int index) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color.fromARGB(255, 110, 183, 220), width: 2),
      ),
      child: _uploadedImages[index] != null
          ? Image.memory(
              _uploadedImages[index]!,
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            )
          : Icon(
              Icons.camera_alt,
              color: Colors.grey[800],
              size: 60,
            ),
    );
  }
}
