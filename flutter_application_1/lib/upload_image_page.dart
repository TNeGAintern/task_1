import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUploadPage extends StatefulWidget {
  @override
  _ImageUploadPageState createState() => _ImageUploadPageState();
}

class _ImageUploadPageState extends State<ImageUploadPage> {
  Uint8List? _uploadedImage;
  bool _isImageSubmitted = false;
  bool _showSubmitButton = true;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        final imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _uploadedImage = imageBytes;
          _isImageSubmitted = false;
          _showSubmitButton = true;
        });
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Image Source', style: TextStyle(color: Color.fromARGB(255, 110, 183, 220))),
        contentPadding: EdgeInsets.all(16),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _pickImage(ImageSource.camera);
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
              _pickImage(ImageSource.gallery);
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

  void _submitImage() {
    setState(() {
      _isImageSubmitted = true;
      _showSubmitButton = false;
    });
  }

  void _deleteImage() {
    setState(() {
      _uploadedImage = null;
      _isImageSubmitted = false;
      _showSubmitButton = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Upload'),
        backgroundColor: Color.fromARGB(255, 110, 183, 220),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Upload Image',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),

              GestureDetector(
                onTap: _showImageSourceDialog,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color.fromARGB(255, 110, 183, 220), width: 2),
                  ),
                  child: _uploadedImage != null
                      ? Image.memory(
                          _uploadedImage!,
                          width: 150,
                          height: 150,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.camera_alt,
                          color: Colors.grey[800],
                          size: 60,
                        ),
                ),
              ),
              SizedBox(height: 20),
              if (_uploadedImage != null && _showSubmitButton)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: _submitImage,
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
                      onPressed: _deleteImage,
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
              if (_isImageSubmitted && _uploadedImage != null) ...[
                Text(
                  'Info about the picture',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color.fromARGB(255, 137, 184, 207), width: 2),
                  ),
                  child: Image.memory(
                    _uploadedImage!,
                    width: 300,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}



// import 'dart:typed_data';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class ImageUploadPage extends StatefulWidget {
//   @override
//   _ImageUploadPageState createState() => _ImageUploadPageState();
// }

// class _ImageUploadPageState extends State<ImageUploadPage> {
//   Uint8List? _uploadedImage;
//   bool _isImageSubmitted = false;
//   bool _showSubmitButton = true;
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _pickImage(ImageSource source) async {
//     try {
//       final XFile? pickedFile = await _picker.pickImage(source: source);
//       if (pickedFile != null) {
//         final imageBytes = await pickedFile.readAsBytes();
//         setState(() {
//           _uploadedImage = imageBytes;
//           _isImageSubmitted = false;
//           _showSubmitButton = true;
//         });
//       }
//     } catch (e) {
//       print("Error picking image: $e");
//     }
//   }

//   void _showImageSourceDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Select Image Source'),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _pickImage(ImageSource.camera);
//             },
//             child: Row(
//               children: <Widget>[
//                 Icon(Icons.camera_alt, color: Colors.blue),
//                 SizedBox(width: 8),
//                 Text('Take a Photo', style: TextStyle(color: Colors.blue)),
//               ],
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _pickImage(ImageSource.gallery);
//             },
//             child: Row(
//               children: <Widget>[
//                 Icon(Icons.image, color: Colors.blue),
//                 SizedBox(width: 8),
//                 Text('Pick from Gallery', style: TextStyle(color: Colors.blue)),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _submitImage() {
//     setState(() {
//       _isImageSubmitted = true;
//       _showSubmitButton = false;
//     });
//   }

//   void _deleteImage() {
//     setState(() {
//       _uploadedImage = null;
//       _isImageSubmitted = false;
//       _showSubmitButton = true;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Image Upload'),
//         backgroundColor: Colors.blueAccent,
//       ),
//       body: Center(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'Upload Image',
//                 style: TextStyle(
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//               SizedBox(height: 16),

//               GestureDetector(
//                 onTap: _showImageSourceDialog,
//                 child: Container(
//                   width: 150,
//                   height: 150,
//                   decoration: BoxDecoration(
//                     color: Colors.grey[200],
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.blueAccent, width: 2),
//                   ),
//                   child: _uploadedImage != null
//                       ? Image.memory(
//                           _uploadedImage!,
//                           width: 150,
//                           height: 150,
//                           fit: BoxFit.cover,
//                         )
//                       : Icon(
//                           Icons.camera_alt,
//                           color: Colors.grey[800],
//                           size: 60,
//                         ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               if (_uploadedImage != null && _showSubmitButton)
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton(
//                       onPressed: _submitImage,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.blueAccent,
//                         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         'Submit',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                     SizedBox(width: 20),
//                     ElevatedButton(
//                       onPressed: _deleteImage,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.red,
//                         padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         'Delete',
//                         style: TextStyle(fontSize: 16, color: Colors.white),
//                       ),
//                     ),
//                   ],
//                 ),
//               SizedBox(height: 20),
//               if (_isImageSubmitted && _uploadedImage != null) ...[
//                 Text(
//                   'Info about the picture',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 SizedBox(height: 20),
//                 Container(
//                   width: 300,
//                   height: 300,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(12),
//                     border: Border.all(color: Colors.blueAccent, width: 2),
//                   ),
//                   child: Image.memory(
//                     _uploadedImage!,
//                     width: 300,
//                     height: 300,
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
