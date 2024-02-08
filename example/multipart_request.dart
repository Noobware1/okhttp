import 'package:okhttp/okhttp.dart';
import 'package:okhttp/request.dart';

void main() {
  // Replace these with your actual values
  const apiUrl = "https://httpbin.org/post";
// val filePath = "/path/to/your/file.txt"

  final client = OkHttpClient();

  // Create a multipart request body with form parameters and a file
  final requestBody = MultipartBody.Builder()
      .setType(MultipartBody.FORM)
      .addFormDataPart("param1", "value1")
      .addFormDataPart("param2", "value2")
      .build();

  // Create the request with the multipart body
  final request = Request.Builder().url(apiUrl).post(requestBody).build();

  // Execute the request
  try {
    client.newCall(request).execute().then((response) {
      if (response.isSuccessful) {
        print("Request successful: ${response.body.string}");
      } else {
        print("Request failed: ${response.statusCode} - ${response.message}");
      }
    });
  } catch (e, s) {
    print(e);
    print(s);
  }
}
