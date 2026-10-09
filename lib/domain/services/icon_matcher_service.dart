import 'package:flutter/widgets.dart';

import 'icon_matching/brand_dictionary.dart';
import 'icon_matching/generic_dictionary.dart';
import 'icon_matching/synonym_groups.dart';
import 'icon_matching/fuzzy_matcher.dart';

/// Three-layer intelligent icon matching engine.
///
/// Priority order:
///   1. Exact brand match          ("netflix" → Netflix logo)
///   2. Exact generic match        ("coffee" → mug icon)
///   3. Contains brand match       ("uber eats order" → UberEats logo)
///   4. Exact synonym group match  ("parents" → family icon)
///   5. Fuzzy brand match          ("netflx" → Netflix logo)
///   6. Fuzzy generic match        ("grocry" → grocery → cart icon)
///   7. Fuzzy synonym match        ("restarant" → restaurant → food icon)
///   8. null (graceful fallback to default icon in UI)
class IconMatcherService {

  /// Returns the best-matching icon for [input], or null if no match.
  /// Called on every keystroke — must be fast.
  static IconData? getBestIconForMerchant(String input) {
    if (input.trim().isEmpty) return null;

    final normalized = input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9\s]'), '');
    final tokens = normalized.split(RegExp(r'\s+'));

    // ── Layer 1a: Exact brand match (per token) ───────────────
    for (final token in tokens) {
      final icon = BrandDictionary.brands[token];
      if (icon != null) return icon;
    }

    // ── Layer 1b: Exact generic match (per token) ─────────────
    for (final token in tokens) {
      final icon = GenericDictionary.keywords[token];
      if (icon != null) return icon;
    }

    // ── Layer 2: Contains brand match (joined string) ─────────
    final joined = normalized.replaceAll(' ', '');
    for (final entry in BrandDictionary.brands.entries) {
      if (joined.contains(entry.key) && entry.key.length >= 3) {
        return entry.value;
      }
    }

    // ── Layer 3: Exact synonym match (per token) ──────────────
    for (final token in tokens) {
      final icon = SynonymGroups.exactMatch(token);
      if (icon != null) return icon;
    }
    // Also try joined for compound synonym keys like "uber eats" → "ubereats"
    final synonymJoined = SynonymGroups.exactMatch(joined);
    if (synonymJoined != null) return synonymJoined;

    // ── Layer 4: Fuzzy brand match ────────────────────────────
    for (final token in tokens) {
      final match = FuzzyMatcher.bestMatch(token, BrandDictionary.brands.keys);
      if (match != null) return BrandDictionary.brands[match];
    }

    // ── Layer 5: Fuzzy generic match ──────────────────────────
    for (final token in tokens) {
      final match = FuzzyMatcher.bestMatch(token, GenericDictionary.keywords.keys);
      if (match != null) return GenericDictionary.keywords[match];
    }

    // ── Layer 6: Fuzzy synonym match ──────────────────────────
    for (final token in tokens) {
      final match = FuzzyMatcher.bestMatch(token, SynonymGroups.allKeys);
      if (match != null) return SynonymGroups.exactMatch(match);
    }

    return null;
  }
}
