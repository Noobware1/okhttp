// import 'dart:io';

// import 'package:okhttp/src/request.dart';

// class _RealCache {
//   final int maxSize;

//   _RealCache(String directory, this.maxSize) : file = File(directory);
//   final File file;

//   void initialize() {
//     if (!file.existsSync()) {
//       file.createSync(recursive: true);
//     }
//   }
// }

// class Cache {
//   final String directory;
//   final int maxSize;

//   Cache(this.directory, this.maxSize);

//   // read and write statistics, all guarded by 'this'.
//   int _writeSuccessCount = 0;
//   int _writeAbortCount = 0;
//   int _networkCount = 0;
//   int _hitCount = 0;
//   int _requestCount = 0;

//   bool get isClosed => false;

//   late final _cache = _RealCache(directory, maxSize);

//   _get(Request request) {
//     final key = request.url;
//   }

// //  internal fun get(request: Request): Response? {
// //     val key = key(request.url)
// //     val snapshot: DiskLruCache.Snapshot =
// //       try {
// //         cache[key] ?: return null
// //       } catch (_: IOException) {
// //         return null // Give up because the cache cannot be read.
// //       }

// //     val entry: Entry =
// //       try {
// //         Entry(snapshot.getSource(ENTRY_METADATA))
// //       } catch (_: IOException) {
// //         snapshot.closeQuietly()
// //         return null
// //       }

// //     val response = entry.response(snapshot)
// //     if (!entry.matches(request, response)) {
// //       response.body.closeQuietly()
// //       return null
// //     }

// //     return response
// //   }

// //   internal fun put(response: Response): CacheRequest? {
// //     val requestMethod = response.request.method

// //     if (HttpMethod.invalidatesCache(response.request.method)) {
// //       try {
// //         remove(response.request)
// //       } catch (_: IOException) {
// //         // The cache cannot be written.
// //       }
// //       return null
// //     }

// //     if (requestMethod != "GET") {
// //       // Don't cache non-GET responses. We're technically allowed to cache HEAD requests and some
// //       // POST requests, but the complexity of doing so is high and the benefit is low.
// //       return null
// //     }

// //     if (response.hasVaryAll()) {
// //       return null
// //     }

// //     val entry = Entry(response)
// //     var editor: DiskLruCache.Editor? = null
// //     try {
// //       editor = cache.edit(key(response.request.url)) ?: return null
// //       entry.writeTo(editor)
// //       return RealCacheRequest(editor)
// //     } catch (_: IOException) {
// //       abortQuietly(editor)
// //       return null
// //     }
// //   }
// }
