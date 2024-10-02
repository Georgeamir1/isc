import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../State_manage/Cubits/draft.dart';
import '../State_manage/States/States.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  File? _image;
  final TextEditingController _docNoController = TextEditingController();

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage(BuildContext context) async {
    if (_image != null) {
      final imagePath = _image!.path;
      int? docNo = int.tryParse(_docNoController.text);

      if (docNo != null) {
        await context.read<UploadImageCubit>().uploadImageAsBase64(imagePath,docNo);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please enter a valid DOC_NO')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No image selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UploadImageCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Image Upload'),
          centerTitle: true,
        ),
        body: BlocConsumer<UploadImageCubit, UploadImageState>(
          listener: (context, state) {
            if (state is UploadImageSuccessState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Image uploaded successfully!')),
              );
            } else if (state is UploadImageErrorState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Upload failed: ${state.error}')),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (state is UploadImageLoadingState)
                      CircularProgressIndicator(),
                    if (_image == null)
                      Text('No image selected.', style: TextStyle(fontSize: 18, color: Colors.grey)),
                    if (_image != null)
                      Column(
                        children: [
                          Image.file(_image!, height: 200, width: 200, fit: BoxFit.cover),
                          SizedBox(height: 20),
                          Text('Uploaded Image', style: TextStyle(fontSize: 20)),
                        ],
                      ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _docNoController,
                      decoration: InputDecoration(
                        labelText: 'Enter DOC_NO',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: _pickImage,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('Pick Image from Camera', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () => _uploadImage(context),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30), backgroundColor: Colors.greenAccent,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      ),
                      child: Text('Upload Image', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
class MedOtRec1 {
  final int docNo;
  final List<String?> images;

  MedOtRec1({required this.docNo, required this.images});

  factory MedOtRec1.fromJson(Map<String, dynamic> json) {
    return MedOtRec1(
      docNo: json['DOC_NO'],
      images: [
        json['pict1'],
        json['pict2'],
        json['pict3'],
        json['pict4'],
      ],
    );
  }
}

class MedOtRecordPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MedOtRecCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('Medical Records'),
        ),
        body: BlocConsumer<MedOtRecCubit, List<MedOtRec1>>(
          listener: (context, state) {
            // You can show a Snackbar or any message if needed
          },
          builder: (context, records) {
            return Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    context.read<MedOtRecCubit>().fetchMedOtRecords();
                  },
                  child: Text('Fetch Records'),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: records.length,
                    itemBuilder: (context, index) {
                      final record = records[index];
                      return Card(
                        child: Column(
                          children: [
                            Text('DOC_NO: ${record.docNo}'),
                            if (record.images.isNotEmpty)
                              ...record.images.map((image) {
                                if (image != null && image.isNotEmpty) {
                                  final decodedImage = base64Decode(image);

                                  return GestureDetector(
                                    onTap: () {
                                      // Show the expanded image in a dialog
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: Image.memory(decodedImage),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.of(context).pop(),
                                              child: Text('Close'),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Container(
                                      margin: EdgeInsets.all(8.0),
                                      width: 100, // Width of the small preview
                                      height: 100, // Height of the small preview
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: MemoryImage(decodedImage),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  );
                                } else {
                                  return SizedBox.shrink();
                                }
                              }).toList(),
                          ],
                        ),
                      );
                    },
                  ),
                ),             ],
            );
          },
        ),
      ),
    );
  }
}


