import 'package:flutter/material.dart';

import '../../theme/design_tokens.dart';

/// One option in a [FilterChipBar].
class FilterChipOption {
  const FilterChipOption({required this.label, this.icon});

  final String label;

  /// Optional leading glyph. The profile's tabs use one; the topic
  /// filters do not — both are fine, but within a single bar it should be
  /// all or nothing.
  final IconData? icon;
}

/// The app's horizontal filter/segment selector.
///
/// Exists because three screens had grown three different answers to the
/// same control: the Home tab used a hand-styled `FilterChip`, the profile
/// used a bare `ChoiceChip` on default theming, and the category page a
/// third variant — so the same gesture looked different depending on where
/// you were.
///
/// Material 3 filter chips as they come: 32dp, 8dp corners, `labelLarge`,
/// the selected one filled, each in a 48dp touch target. The row takes its
/// height from the chips, so a larger text size grows it instead of
/// clipping them. Chips scroll horizontally: a forum may offer five
/// filters, and they must not squeeze or wrap.
class FilterChipBar extends StatelessWidget {
  const FilterChipBar({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onSelected,
    this.padding,
  });

  final List<FilterChipOption> options;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  /// Defaults to the standard inset. Callers embedding the bar inside an
  /// already-padded region can tighten it.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    // Start-aligned even in a column that centres its children: a row
    // narrower than the screen would otherwise shrink to its chips.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: DesignTokens.spacingL,
              vertical: DesignTokens.spacingS,
            ),
        child: Row(
          children: [
            for (var index = 0; index < options.length; index++) ...[
              if (index > 0) const SizedBox(width: DesignTokens.spacingS),
              _chip(options[index], index == selectedIndex, index),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(FilterChipOption option, bool isSelected, int index) {
    return FilterChip(
      selected: isSelected,
      avatar: option.icon == null
          ? null
          : Icon(option.icon, size: DesignTokens.iconSizeSMedium),
      // Material draws the tick *over* the avatar slot, so a chip with an
      // icon shows selection by its fill alone.
      showCheckmark: option.icon == null,
      label: Text(option.label),
      onSelected: (_) {
        if (isSelected) return;
        onSelected(index);
      },
    );
  }
}
