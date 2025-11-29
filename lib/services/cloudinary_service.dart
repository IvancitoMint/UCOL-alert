import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class CloudinaryService {
  final String cloudName = "dilwitdws";
  final String uploadPreset = "flutter_unsigned"; // unsigned preset

  Future<String?> uploadImage({
    required File file,
    Function(double progress)? onProgress,
  }) async {
    final url = Uri.parse(
      "https://api.cloudinary.com/v1_1/$cloudName/image/upload",
    );

    final request = http.MultipartRequest("POST", url)
      ..fields["upload_preset"] = uploadPreset
      ..files.add(await http.MultipartFile.fromPath(
        "file",
        file.path,
      ));

    // Listener del progreso
    final streamed = await request.send();

    final total = streamed.contentLength ?? 0;
    int bytesReceived = 0;

    streamed.stream.listen(
      (chunk) {
        bytesReceived += chunk.length;
        if (onProgress != null && total > 0) {
          onProgress(bytesReceived / total);
        }
      },
      onDone: () async {},
      onError: (e) {},
      cancelOnError: false,
    );

    final response = await http.Response.fromStream(streamed);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["secure_url"]; //url final
    } else {
      print("Error Cloudinary: ${response.body}");
      return null;
    }
  }
}
