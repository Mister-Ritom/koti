sed -i '' "s/Text('\\\$currency\$formattedAmount',/Text(hideBalance ? '****' : '\\\$currency\$formattedAmount',/g" lib/features/home/home_screen.dart
