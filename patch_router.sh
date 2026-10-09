sed -i '' 's/import '"'"'..\/..\/features\/transactions\/pages\/transaction_detail_screen.dart'"'"';/import '"'"'..\/..\/features\/transactions\/pages\/transaction_detail_screen.dart'"'"';\nimport '"'"'..\/..\/features\/transactions\/pages\/all_transactions_screen.dart'"'"';/g' lib/core/routing/app_router.dart

sed -i '' 's/GoRoute(/GoRoute(\n      path: '"'"'\/all-transactions'"'"',\n      builder: (context, state) => const AllTransactionsScreen(),\n    ),\n    GoRoute(/g' lib/core/routing/app_router.dart
