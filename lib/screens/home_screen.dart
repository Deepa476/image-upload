import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:supabaseuupload/service/storage_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StorageService _storageService = StorageService();

  String selectedCategory = "fruits";
  String itemName = "";
  String englishWord = "";
  String gujaratiWord = "";
  PlatformFile? normalImage;
  PlatformFile? signImage;
  String? normalImageUrl;
  String? signImageUrl;

  Future<void> _pickNormalImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      setState(() {
        normalImage = result.files.first;
      });
    }
  }

  Future<void> _pickSignImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );
    if (result != null) {
      setState(() {
        signImage = result.files.first;
      });
    }
  }

  Future<void> _uploadImages() async {
    if (itemName.isEmpty || englishWord.isEmpty || gujaratiWord.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter all details before uploading!")),
      );
      return;
    }

    if (normalImage == null || signImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select both images!")),
      );
      return;
    }

    // Upload images
    normalImageUrl = await _storageService.uploadImage(
      selectedCategory,
      normalImage!.name,
      normalImage!.bytes!,
    );

    signImageUrl = await _storageService.uploadImage(
      selectedCategory,
      signImage!.name,
      signImage!.bytes!,
    );

    // Save details to Firestore
    await _storageService.saveToFirestore(
      category: selectedCategory,
      itemName: itemName.toLowerCase(),
      englishWord: englishWord,
      gujaratiWord: gujaratiWord,
      normalImageUrl: normalImageUrl,
      signImageUrl: signImageUrl,
    );

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Images uploaded successfully!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload & Save Images')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              onChanged: (newValue) {
                setState(() {
                  selectedCategory = newValue!;
                });
              },
              items: ["fruits", "animals", "words"].map((category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category.toUpperCase()),
                );
              }).toList(),
            ),

            const SizedBox(height: 10),

            TextField(
              decoration: const InputDecoration(
                labelText: "Enter item name (e.g., Apple)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  itemName = value;
                });
              },
            ),

            const SizedBox(height: 10),

            TextField(
              decoration: const InputDecoration(
                labelText: "Enter English word (e.g., Apple)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  englishWord = value;
                });
              },
            ),

            const SizedBox(height: 10),

            TextField(
              decoration: const InputDecoration(
                labelText: "Enter Gujarati word (e.g., સફરજન)",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  gujaratiWord = value;
                });
              },
            ),

            const SizedBox(height: 10),

            // Pick Normal Image
            Center(
              child: ElevatedButton(
                onPressed: _pickNormalImage,
                child: Text(normalImage == null ? "Pick Normal Image" : "Normal Image Selected"),
              ),
            ),

            if (normalImage != null)
              Text("Selected: ${normalImage!.name}", style: const TextStyle(fontSize: 12)),

            const SizedBox(height: 10),

            // Pick Sign Image
            Center(
              child: ElevatedButton(
                onPressed: _pickSignImage,
                child: Text(signImage == null ? "Pick Sign Image" : "Sign Image Selected"),
              ),
            ),

            if (signImage != null)
              Text("Selected: ${signImage!.name}", style: const TextStyle(fontSize: 12)),

            const SizedBox(height: 10),

            Center(
              child: ElevatedButton(
                onPressed: _uploadImages,
                child: const Text("Upload Both Images"),
              ),
            ),

            const SizedBox(height: 20),

            if (normalImageUrl != null)
              Text("Normal Image URL: $normalImageUrl", style: const TextStyle(fontSize: 14)),

            if (signImageUrl != null)
              Text("Sign Image URL: $signImageUrl", style: const TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
