class HttpMethod {
  static bool invalidatesCache(String method) {
    return method == "POST" ||
        method == "PATCH" ||
        method == "PUT" ||
        method == "DELETE" ||
        method == "MOVE";
  }

  static bool requiresRequestBody(String method) {
    return method == "POST" ||
        method == "PUT" ||
        method == "PATCH" ||
        method == "PROPPATCH" || // WebDAV
        method == "REPORT";
  }

  static bool permitsRequestBody(String method) =>
      !(method == "GET" || method == "HEAD");

  static bool redirectsWithBody(String method) => method == "PROPFIND";

  static bool redirectsToGet(String method) => method != "PROPFIND";
}
