import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StorageService {
  final SupabaseClient supabase = Supabase.instance.client;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<String?> uploadImage(String category, String fileName, Uint8List fileBytes) async {
    try {
      String filePath = '$category/$fileName';

      await supabase.storage.from('learningmodule').uploadBinary(
            filePath,
            fileBytes,
          );

      return supabase.storage.from('learningmodule').getPublicUrl(filePath);
    } catch (e) {
      print('Error uploading file: $e');
      return null;
    }
  }

  Future<void> saveToFirestore({
    required String category,
    required String itemName,
    required String englishWord,
    required String gujaratiWord,
    required String? normalImageUrl,
    required String? signImageUrl,
  }) async {
    try {
      await firestore
          .collection('learning_module')
          .doc(category)
          .collection(itemName)
          .doc("data")
          .set({
        'english_word': englishWord,
        'gujarati_word': gujaratiWord,
        'image': normalImageUrl,
        'image2': signImageUrl,
      });
    } catch (e) {
      print('Error saving to Firestore: $e');
    }
  }
}
