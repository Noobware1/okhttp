// import 'package:collection/collection.dart';
// import 'package:ok_http/src/headers.dart';

// extension HeadersCommon on Headers {
//   String commonName(int index) {
//     return namesAndValues.getOrNull(index) ?? (throw Exception("name[$index]"));
//   }

//   String commonValue(int index) {
//     return namesAndValues.getOrNull(index * 2 + 1) ??
//         (throw Exception("value[$index]"));
//   }

//   List<String> commonValues(String name) {
//     List<String> result = [];
//     for (var i = 0; i < length; i++) {
//       if (name.toLowerCase() == commonName(i).toLowerCase()) {
//         result.add(commonValue(i));
//       }
//     }
//     return result;
//   }

//   Iterator<MapEntry<String, String>> commonIterator() {
//     final list = <MapEntry<String, String>>[];
//     for (var i = 0; i < length; i++) {
//       final entry = elementAt(i);
//       list.add(MapEntry(entry.key, entry.value));
//     }
//     return list.iterator;
//   }

//   bool commonEquals(Object? other) {
//     return other is Headers && IterableEquality().equals(namesAndValues, other);
//   }

//   int commonHashCode() => namesAndValues.hashCode;

//   String commonToString() {
//     final StringBuffer sb = StringBuffer();
//     for (var i = 0; i < length; i++) {
//       final key = elementAt(i).key;
//       final value = elementAt(i).value;
//       sb.write(key);
//       sb.write(": ");
//       sb.write(value);
//       sb.write("\n");
//     }
//     return sb.toString();
//   }

//   String? commonHeadersGet(List<String> namesAndValues, String name) {
//     for (var i = namesAndValues.length - 2; i >= 0; i -= 2) {
//       if (name.toLowerCase() == namesAndValues[i].toLowerCase()) {
//         return namesAndValues[i + 1];
//       }
//     }
//     return null;
//   }

//   String headersCheckName(String name) {
//     if (name.isEmpty) {
//       throw Exception("name is empty");
//     }
//     for (var i = 0; i < name.length; i++) {
//       final c = name[i];
//       if (!(c.contains('\u0021') && c.contains('\u007e'))) {
//         throw Exception(
//             "Unexpected char 0x${c.codeUnitAt(0).toRadixString(16)} at $i in header name: $name");
//       }
//     }
//     return name;
//   }

//   void headersCheckValue(String value, String name) {
//     for (var i = 0; i < value.length; i++) {
//       final c = value[i];
//       if (!(c.contains('\t') && c.contains('\u0020') && c.contains('\u007e'))) {
//         throw Exception(
//             "Unexpected char 0x${c.codeUnitAt(0).toRadixString(16)} at $i in $name value  \": $value");
//       }
//     }
//   }

//   String _charCode(int code) {
//     final str = code.toRadixString(16);
//     if (str.length < 2) {
//       return "0$str";
//     } else {
//       return str;
//     }
//   }

//   Headers commonHeadersOf(List<String> inputNamesAndValues) {
//     try {
//       assert(inputNamesAndValues.length % 2 == 0);
//       // Make a defensive copy and clean it up.
//       final namesAndValues = inputNamesAndValues;
//       for (var i = 0; i < namesAndValues.length; i++) {
//         namesAndValues[i] = inputNamesAndValues[i].trim();
//       }

//       // Check for malformed headers.
//       for (var i = 0; i < namesAndValues.length; i++) {
//         final name = namesAndValues[i];
//         final value = namesAndValues[i + 1];
//         headersCheckName(name);
//         headersCheckValue(value, name);
//       }

//       return Headers(namesAndValues);
//     } on AssertionError {
//       throw Exception("Expected alternating header names and values");
//     }
//   }
// }

// extension CommonListForHeaders on Map<String, String> {
//   Headers commonToHeaders() {
//     final namesAndValues = <String>[];
//     for (var i = 0; i < length; i++) {
//       final name = keys.elementAt(i).trim();
//       final value = values.elementAt(i).trim();
//       namesAndValues.add(name);
//       namesAndValues.add(value);
//     }
//     return Headers(namesAndValues);
//   }
// }

// extension<E> on List<E> {
//   E? getOrNull(int index) {
//     if (index < 0 || index >= length) {
//       return null;
//     }
//     return this[index];
//   }
// }



// // internal fun Headers.commonToString(): String {
// //   return buildString {
// //     for (i in 0 until size) {
// //       val name = name(i)
// //       val value = value(i)
// //       append(name)
// //       append(": ")
// //       append(if (isSensitiveHeader(name)) "██" else value)
// //       append("\n")
// //     }
// //   }
// // }

// // internal fun commonHeadersGet(namesAndValues: Array<String>, name: String): String? {
// //   for (i in namesAndValues.size - 2 downTo 0 step 2) {
// //     if (name.equals(namesAndValues[i], ignoreCase = true)) {
// //       return namesAndValues[i + 1]
// //     }
// //   }
// //   return null
// // }

// // internal fun Headers.Builder.commonAdd(name: String, value: String) = apply {
// //   headersCheckName(name)
// //   headersCheckValue(value, name)
// //   commonAddLenient(name, value)
// // }

// // internal fun Headers.Builder.commonAddAll(headers: Headers) = apply {
// //   for (i in 0 until headers.size) {
// //     commonAddLenient(headers.name(i), headers.value(i))
// //   }
// // }

// // internal fun Headers.Builder.commonAddLenient(name: String, value: String) = apply {
// //   namesAndValues.add(name)
// //   namesAndValues.add(value.trim())
// // }

// // internal fun Headers.Builder.commonRemoveAll(name: String) = apply {
// //   var i = 0
// //   while (i < namesAndValues.size) {
// //     if (name.equals(namesAndValues[i], ignoreCase = true)) {
// //       namesAndValues.removeAt(i) // name
// //       namesAndValues.removeAt(i) // value
// //       i -= 2
// //     }
// //     i += 2
// //   }
// // }

// // /**
// //  * Set a field with the specified value. If the field is not found, it is added. If the field is
// //  * found, the existing values are replaced.
// //  */
// // internal fun Headers.Builder.commonSet(name: String, value: String) = apply {
// //   headersCheckName(name)
// //   headersCheckValue(value, name)
// //   removeAll(name)
// //   commonAddLenient(name, value)
// // }

// // /** Equivalent to `build().get(name)`, but potentially faster. */
// // internal fun Headers.Builder.commonGet(name: String): String? {
// //   for (i in namesAndValues.size - 2 downTo 0 step 2) {
// //     if (name.equals(namesAndValues[i], ignoreCase = true)) {
// //       return namesAndValues[i + 1]
// //     }
// //   }
// //   return null
// // }

// // internal fun Headers.Builder.commonBuild(): Headers = Headers(namesAndValues.toTypedArray())

// // internal fun headersCheckName(name: String) {
// //   require(name.isNotEmpty()) { "name is empty" }
// //   for (i in name.indices) {
// //     val c = name[i]
// //     require(c in '\u0021'..'\u007e') {
// //       "Unexpected char 0x${c.charCode()} at $i in header name: $name"
// //     }
// //   }
// // }

// // internal fun headersCheckValue(value: String, name: String) {
// //   for (i in value.indices) {
// //     val c = value[i]
// //     require(c == '\t' || c in '\u0020'..'\u007e') {
// //       "Unexpected char 0x${c.charCode()} at $i in $name value" +
// //         (if (isSensitiveHeader(name)) "" else ": $value")
// //     }
// //   }
// // }

// // private fun Char.charCode() = code.toString(16).let {
// //   if (it.length < 2) {
// //     "0$it"
// //   } else {
// //     it
// //   }
// // }

// // internal fun commonHeadersOf(vararg inputNamesAndValues: String): Headers {
// //   require(inputNamesAndValues.size % 2 == 0) { "Expected alternating header names and values" }

// //   // Make a defensive copy and clean it up.
// //   val namesAndValues: Array<String> = arrayOf(*inputNamesAndValues)
// //   for (i in namesAndValues.indices) {
// //     require(namesAndValues[i] != null) { "Headers cannot be null" }
// //     namesAndValues[i] = inputNamesAndValues[i].trim()
// //   }

// //   // Check for malformed headers.
// //   for (i in namesAndValues.indices step 2) {
// //     val name = namesAndValues[i]
// //     val value = namesAndValues[i + 1]
// //     headersCheckName(name)
// //     headersCheckValue(value, name)
// //   }

// //   return Headers(namesAndValues)
// // }

// // internal fun Map<String, String>.commonToHeaders(): Headers {
// //   // Make a defensive copy and clean it up.
// //   val namesAndValues = arrayOfNulls<String>(size * 2)
// //   var i = 0
// //   for ((k, v) in this) {
// //     val name = k.trim()
// //     val value = v.trim()
// //     headersCheckName(name)
// //     headersCheckValue(value, name)
// //     namesAndValues[i] = name
// //     namesAndValues[i + 1] = value
// //     i += 2
// //   }

// //   return Headers(namesAndValues as Array<String>)
// // }
