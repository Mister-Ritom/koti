sed -i '' 's/return Container(/return GestureDetector(\n                onTap: () => context.push('"'"'\/transaction\/\${t.uuid}'"'"'),\n                behavior: HitTestBehavior.opaque,\n                child: Container(/g' lib/features/transactions/pages/all_transactions_screen.dart
sed -i '' 's/onTap: () => context.push('"'"'\/transaction\/\${t.uuid}'"'"'),//g' lib/features/transactions/pages/all_transactions_screen.dart
sed -i '' 's/child: ListTile(/child: IgnorePointer(\n                  child: ListTile(/g' lib/features/transactions/pages/all_transactions_screen.dart
