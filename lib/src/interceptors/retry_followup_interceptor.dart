// import 'package:okhttp/src/connection/real_chain.dart';
// import 'package:okhttp/src/interceptor.dart';
// import 'package:okhttp/src/okhttp_client.dart';
// import 'package:okhttp/src/response.dart';

// class RetryAndFollowUpInterceptor implements Interceptor {
//   final OkHttpClient _client;
//   RetryAndFollowUpInterceptor(this._client);

//   @override
//   Future<Response> intercept(Chain chain) async {
//     final realChain = chain as RealInterceptorChain;
//     var request = chain.request;
//     final call = realChain.call;
//     var followUpCount = 0;
//     // Response? priorResponse;

//     while (followUpCount < 20) {
//       if (call.isCanceled) {
//         throw Exception("Canceled");
//       }

//       Response response;
//       try {
//         response = await realChain.proceed(request);
//         if (response.statusCode == 200) {
//           return response;
//         }
//       } catch (e) {
//         print(e);
//         followUpCount++;
//       }
//     }
//     throw Exception("Too many follow-up requests: $followUpCount");
//   }
// }
