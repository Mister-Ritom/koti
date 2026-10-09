/// Pure-Dart Levenshtein distance — zero dependencies.
/// Returns the minimum number of single-character edits (insert, delete, substitute)
/// required to change [a] into [b].
class FuzzyMatcher {
  static int levenshtein(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    // Use two rows instead of a full matrix to save memory.
    List<int> prev = List.generate(b.length + 1, (i) => i);
    List<int> curr = List.filled(b.length + 1, 0);

    for (int i = 1; i <= a.length; i++) {
      curr[0] = i;
      for (int j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;
        curr[j] = [
          prev[j] + 1,      // deletion
          curr[j - 1] + 1,  // insertion
          prev[j - 1] + cost // substitution
        ].reduce((a, b) => a < b ? a : b);
      }
      final temp = prev;
      prev = curr;
      curr = temp;
    }
    return prev[b.length];
  }

  /// Returns the maximum edit distance we'll tolerate for a word of [length].
  ///   len ≤ 3  → exact only (0)
  ///   len 4–6  → 1 typo
  ///   len 7+   → 2 typos
  static int threshold(int length) {
    if (length <= 3) return 0;
    if (length <= 6) return 1;
    return 2;
  }

  /// Finds the best fuzzy match for [input] in [keys].
  /// Returns the matched key, or null if nothing is close enough.
  static String? bestMatch(String input, Iterable<String> keys) {
    if (input.length <= 2) return null; // too short for fuzzy

    final maxDist = threshold(input.length);
    if (maxDist == 0) return null; // exact-only range, skip fuzzy

    String? best;
    int bestDist = maxDist + 1;

    for (final key in keys) {
      // Quick length-difference pre-check to skip obviously impossible matches.
      if ((key.length - input.length).abs() > maxDist) continue;

      final dist = levenshtein(input, key);
      if (dist < bestDist) {
        bestDist = dist;
        best = key;
      }
    }
    return best;
  }
}
