// import 'dart:io';

// import 'package:okhttp/src/connection/real_call.dart';
// import 'package:okhttp/src/connection/real_chain.dart';
// import 'package:okhttp/src/connection/route_planner.dart';
// import 'package:okhttp/src/okhttp_client.dart';
// import 'package:okhttp/src/route.dart';

// class RealRoutePlanner implements RoutePlanner {
//   final OkHttpClient _client;
//   final InternetAddress address;
//   final RealCall _call;
//   final RealInterceptorChain _chain;

//   RealRoutePlanner(
//       {required OkHttpClient client,
//       required this.address,
//       required RealCall call,
//       required RealInterceptorChain chain})
//       : _client = client,
//         _call = call,
//         _chain = chain;

//   late final _doExtensiveHealthChecks = _chain.request.method != "GET";

//   //  var routeSelection: RouteSelector.Selection? = null
//   //  var routeSelector: RouteSelector? = null
//   Route? nextRouteToTry;

//   final List<Plan> deferredPlans = [];

//   @override
//   bool isCanceled() => _call.isCanceled;


// }
