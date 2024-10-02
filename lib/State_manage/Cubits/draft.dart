import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import '../../Screens/test.dart';
import '../States/States.dart';

class UploadImageCubit extends Cubit<UploadImageState> {
  UploadImageCubit() : super(UploadImageInitialState());

  static UploadImageCubit get(BuildContext context) => BlocProvider.of(context);

  Future<void> uploadImageAsBase64(String imagePath,int docno) async {
    final bytes = await File(imagePath).readAsBytes();
    String base64Image = base64Encode(bytes);
    final uri = Uri.parse('http://192.168.1.88/api/medRec1/');

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'pict1': base64Image,
        'DOC_NO': docno,
      }),
    );

    if (response.statusCode == 200) {
      print('Image uploaded successfully');
    } else {
      print('Image upload failed: ${response.statusCode} - ${response.body}');
    }
  }
}

class MedOtRecCubit extends Cubit<List<MedOtRec1>> {
  MedOtRecCubit() : super([]);

  Future<void> fetchMedOtRecords() async {
    try {
      final response = await http.get(Uri.parse('http://192.168.1.88/api/medRec1/'));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final records = data.map((record) => MedOtRec1.fromJson(record)).toList();
        emit(records);
      } else {
        throw Exception('Failed to load records: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Error fetching records');
    }
  }
}
