// import 'package:okhttp/src/connection/real_call.dart';
// import 'package:okhttp/src/connection/route_planner.dart';
// import 'package:okhttp/src/exchange/exchnage_codec.dart';
// import 'package:okhttp/src/expections/okhttp_exception.dart';
// import 'package:okhttp/src/interceptor.dart';
// import 'package:okhttp/src/okhttp_client.dart';
// import 'package:okhttp/src/request.dart';
// import 'package:okhttp/src/route.dart';

// class ConnectPlan implements Plan, Carrier {
//   ConnectPlan({required this.route});
//   // Configuration and state scoped to the call.
//   final OkHttpClient _client;
//   final RealCall _call;
//   final Chain _chain;
//   // final RealRoutePlanner _routePlanner;
//   final List<Route>? _routes;
//   final int _attempt;
//   final Request? _tunnelRequest;
//   final int _connectionSpecIndex;
//   final bool _isTlsFallback;

//   @override
//   void cancel() {
//     // TODO: implement cancel
//   }

//   @override
//   Future<ConnectResult> connectTcp() {
//     // TODO: implement connectTcp
//     throw UnimplementedError();
//   }

//   @override
//   Future<ConnectResult> connectTlsEtc() {
//     // TODO: implement connectTlsEtc
//     throw UnimplementedError();
//   }

//   @override
//   Future<RealConnection> handleSuccess() {
//     // TODO: implement handleSuccess
//     throw UnimplementedError();
//   }

//   @override
//   // TODO: implement isReady
//   bool get isReady => throw UnimplementedError();

//   @override
//   void noNewExchanges() {
//     // TODO: implement noNewExchanges
//   }

//   @override
//   Plan? retry() {
//     // TODO: implement retry
//     throw UnimplementedError();
//   }

//   @override
//   final Route route;

//   @override
//   void trackFailure(RealCall call, OkHttpException? e) {
//     // TODO: implement trackFailure
//   }
// }
