import 'dart:io';

import 'package:okhttp/src/public_suffix/idn.dart';
import 'package:okhttp/src/utils/list_extensions.dart';

class PublicSuffixDataBase {
  static const EXCEPTION_MARKER = '!';

  var _listRead = false;

  ///
  /// Returns the effective top-level domain plus one (eTLD+1) by referencing the public suffix list.
  /// Returns null if the domain is a public suffix or a private address.
  ///
  /// Here are some examples:
  ///
  /// ```dart
  /// assert("google.com", getEffectiveTldPlusOne("google.com"));
  /// assert("google.com", getEffectiveTldPlusOne("www.google.com"));
  /// assert(getEffectiveTldPlusOne("com") == null);
  /// assert(getEffectiveTldPlusOne("localhost") == null);
  /// assert(getEffectiveTldPlusOne("mymacbook") == null);
  /// ```
  ///
  /// @param domain A canonicalized domain. An International Domain Name (IDN) should be punycode
  ///     encoded.
  ///
  String getEffectiveTldPlusOne(String domain) {
    final uincodeDomain = IDNAConverter.urlDecode(domain);

    return '';
  }

  // List<String> splitDomain(String domain) {
  //   final domainLabels = domain.split('.');

  //   if (domainLabels.last == "") {
  //     // allow for domain name trailing dot
  //     return domainLabels.dropLast(1);
  //   }

  //   return domainLabels;
  // }

  // List<String> findMatchingRule(List<String> domainLabels) {
  //   if (!_listRead) {
  //     _listRead = true;
  //   }
  //   return [];
  // }

  ///
  /// Reads the public suffix list treating the operation as uninterruptible. We always want to read
  /// the list otherwise we'll be left in a bad state. If the thread was interrupted prior to this
  /// operation, it will be re-interrupted after the list is read.
  ///
  // readTheListUninterruptibly() {
  //   var interrupted = false;
  //   try {
  //     while (true) {
  //       try {
  //         readTheList();
  //         return;
  //       } catch (e) {
  //         interrupted = true;
  //       } catch (e) {
  //         print("Failed to read public suffix list");
  //       }
  //     }
  //   } finally {}
}

//   check(::publicSuffixListBytes.isInitialized) {
//     // May have failed with an IOException
//     "Unable to load $PUBLIC_SUFFIX_RESOURCE resource from the classpath."
//   }

//   // Break apart the domain into UTF-8 labels, i.e. foo.bar.com turns into [foo, bar, com].
//   val domainLabelsUtf8Bytes = Array(domainLabels.size) { i -> domainLabels[i].toByteArray() }

//   // Start by looking for exact matches. We start at the leftmost label. For example, foo.bar.com
//   // will look like: [foo, bar, com], [bar, com], [com]. The longest matching rule wins.
//   var exactMatch: String? = null
//   for (i in domainLabelsUtf8Bytes.indices) {
//     val rule = publicSuffixListBytes.binarySearch(domainLabelsUtf8Bytes, i)
//     if (rule != null) {
//       exactMatch = rule
//       break
//     }
//   }

//   // In theory, wildcard rules are not restricted to having the wildcard in the leftmost position.
//   // In practice, wildcards are always in the leftmost position. For now, this implementation
//   // cheats and does not attempt every possible permutation. Instead, it only considers wildcards
//   // in the leftmost position. We assert this fact when we generate the public suffix file. If
//   // this assertion ever fails we'll need to refactor this implementation.
//   var wildcardMatch: String? = null
//   if (domainLabelsUtf8Bytes.size > 1) {
//     val labelsWithWildcard = domainLabelsUtf8Bytes.clone()
//     for (labelIndex in 0 until labelsWithWildcard.size - 1) {
//       labelsWithWildcard[labelIndex] = WILDCARD_LABEL
//       val rule = publicSuffixListBytes.binarySearch(labelsWithWildcard, labelIndex)
//       if (rule != null) {
//         wildcardMatch = rule
//         break
//       }
//     }
//   }

//   // Exception rules only apply to wildcard rules, so only try it if we matched a wildcard.
//   var exception: String? = null
//   if (wildcardMatch != null) {
//     for (labelIndex in 0 until domainLabelsUtf8Bytes.size - 1) {
//       val rule = publicSuffixExceptionListBytes.binarySearch(
//           domainLabelsUtf8Bytes, labelIndex)
//       if (rule != null) {
//         exception = rule
//         break
//       }
//     }
//   }

//   if (exception != null) {
//     // Signal we've identified an exception rule.
//     exception = "!$exception"
//     return exception.split('.')
//   } else if (exactMatch == null && wildcardMatch == null) {
//     return PREVAILING_RULE
//   }

//   val exactRuleLabels = exactMatch?.split('.') ?: listOf()
//   val wildcardRuleLabels = wildcardMatch?.split('.') ?: listOf()

//   return if (exactRuleLabels.size > wildcardRuleLabels.size) {
//     exactRuleLabels
//   } else {
//     wildcardRuleLabels
//   }
// }

void main(List<String> args) {
  final PublicSuffixDataBase publicSuffixDataBase = PublicSuffixDataBase();
  print(publicSuffixDataBase.getEffectiveTldPlusOne("google.com"));
}
//   String getEffectiveTldPlusOne(String domain) {
//     return '';
//     // We use UTF-8 in the list so we need to convert to Unicode.
//     // val unicodeDomain = IDN.toUnicode(domain)
//     // val domainLabels = splitDomain(unicodeDomain)

//     // val rule = findMatchingRule(domainLabels)
//     // if (domainLabels.size == rule.size && rule[0][0] != EXCEPTION_MARKER) {
//     //   return null // The domain is a public suffix.
//     // }

//     // val firstLabelOffset = if (rule[0][0] == EXCEPTION_MARKER) {
//     //   // Exception rules hold the effective TLD plus one.
//     //   domainLabels.size - rule.size
//     // } else {
//     //   // Otherwise the rule is for a public suffix, so we must take one more label.
//     //   domainLabels.size - (rule.size + 1)
//     // }

//     // return splitDomain(domain).asSequence().drop(firstLabelOffset).joinToString(".")
//   }

//   // private fun splitDomain(domain: String): List<String> {
//   //   val domainLabels = domain.split('.')

//   //   if (domainLabels.last() == "") {
//   //     // allow for domain name trailing dot
//   //     return domainLabels.dropLast(1)
//   //   }

//   //   return domainLabels
//   // }
//   toUinicode(String input, int flag) {
//     int p = 0, q = 0;

//     final StringBuffer out = StringBuffer();

//     //     if (isRootLabel(input)) {
//     //         return ".";
//     //     }

//     while (p < input.length) {
//       q = _searchDots(input, p);
//       out.write(toUnicodeInternal(input.substring(p, q), flag));
//       if (q != (input.length)) {
//         // has more labels, or keep the trailing dot as at present
//         out.write('.');
//       }
//       p = q + 1;
//     }

//     return out.toString();
//   }

//   // toUnicode operation; should only apply to a single label
//   static String _toUnicodeInternal(String label, int flag) {
//     final caseFlags = [];
//     StringBuffer dest;

//     // step 1
//     // find out if all the codepoints in input are ASCII
//     bool isASCII = isAllASCII(label);

//     if (!isASCII) {
//       // step 2
//       // perform the nameprep operation; flag ALLOW_UNASSIGNED is used here
//       try {
//         // UCharacterIterator iter = UCharacterIterator.getInstance(label);
//         // dest = namePrep.prepare(iter, flag);
//       } catch (e) {
//         // toUnicode never fails; if any step fails, return the input string
//         return label;
//       }
//     } else {
//       dest = StringBuffer(label);
//     }

//     // // step 3
//     // // verify ACE Prefix
//     // if(startsWithACEPrefix(dest)) {

//     //     // step 4
//     //     // Remove the ACE Prefix
//     //     String temp = dest.substring(ACE_PREFIX_LENGTH, dest.length());

//     //     try {
//     //         // step 5
//     //         // Decode using punycode
//     //         StringBuffer decodeOut = Punycode.decode(new StringBuffer(temp), null);

//     //         // step 6
//     //         // Apply toASCII
//     //         String toASCIIOut = toASCII(decodeOut.toString(), flag);

//     //         // step 7
//     //         // verify
//     //         if (toASCIIOut.equalsIgnoreCase(dest.toString())) {
//     //             // step 8
//     //             // return output of step 5
//     //             return decodeOut.toString();
//     //         }
//     //     } catch (Exception ignored) {
//     //         // no-op
//     //     }

//     // just return the input
//     return label;
//   }

//   // to check if a string only contains US-ASCII code point
//   static bool isAllASCII(String input) {
//     bool isASCII = true;
//     for (int i = 0; i < input.length; i++) {
//       int c = input.codeUnitAt(i);
//       if (c > 0x7F) {
//         isASCII = false;
//         break;
//       }
//     }
//     return isASCII;
//   }

//   // search dots in a string and return the index of that character;
//   // or if there is no dots, return the length of input string
//   // dots might be: \u002E (full stop), \u3002 (ideographic full stop), \uFF0E (fullwidth full stop),
//   // and \uFF61 (halfwidth ideographic full stop).
//   static int _searchDots(String s, int start) {
//     int i;
//     for (i = start; i < s.length; i++) {
//       if (_isLabelSeparator(s[i])) {
//         break;
//       }
//     }

//     return i;
//   }

//   // to check if a character is a label separator, i.e. a dot character.
//   static bool _isLabelSeparator(String c) {
//     return (c == '.' || c == '\u3002' || c == '\uFF0E' || c == '\uFF61');
//   }
// }

// void main(List<String> args) {
//   final domain = Uri.parse(
//           'https://github.com/square/okhttp/blob/e09a018ebf8dfca07e53d927bdd6d1f563c75e1a/okhttp/src/main/kotlin/okhttp3/Cookie.kt')
//       .host;
// }
