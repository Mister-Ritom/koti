sed -i '' 's/final formattedDate = DateFormat('"'"'EEEE, MMMM d, yyyy • h:mm a'"'"').format(tx.date);/final formattedDate = DateFormat('"'"'EEEE, MMMM d, yyyy • h:mm a'"'"').format(tx.date);\n          final note = tx.notes ?? "";/g' lib/features/transactions/pages/transaction_detail_screen.dart

sed -i '' 's/tx.description/((tx.merchant != null \&\& tx.merchant!.isNotEmpty) ? tx.merchant! : (tx.description.isNotEmpty ? tx.description : '"'"'Transaction'"'"'))/g' lib/features/transactions/pages/transaction_detail_screen.dart

# Add the note row right after the Status row
sed -i '' '/_buildDetailRow(context, '"'"'Status'"'"', '"'"'Completed'"'"', icon: Icons.check_circle, iconColor: Colors.green),/a\
              if (note.isNotEmpty) ...[\
                const Divider(height: 32),\
                _buildDetailRow(context, '"'"'Note'"'"', note, icon: Icons.sticky_note_2_outlined, iconColor: Colors.grey),\
              ],
' lib/features/transactions/pages/transaction_detail_screen.dart
