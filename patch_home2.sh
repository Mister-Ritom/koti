sed -i '' 's/itemCount: transactions.length,/itemCount: transactions.length > 5 ? 5 : transactions.length,/g' lib/features/home/home_screen.dart
