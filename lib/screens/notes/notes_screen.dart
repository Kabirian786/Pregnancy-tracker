import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../controllers/notes_provider.dart';
import '../../widgets/custom_card.dart';

/// روزانہ ڈائری / نوٹس اسکرین - علامات، احساسات اور سوالات کے لیے
class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotesProvider>();
    final notes = provider.notes;

    return Scaffold(
      appBar: AppBar(title: const Text('ڈائری / نوٹس')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, provider),
        child: const Icon(Icons.add),
      ),
      body: notes.isEmpty
          ? const Center(child: Text('کوئی نوٹ محفوظ نہیں - نیا نوٹ شامل کریں'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                return CustomCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(AppDateUtils.urduDate(note.date),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(color: AppTheme.primaryGreen, fontWeight: FontWeight.bold)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit, size: 18),
                            onPressed: () => _showEditDialog(context, provider, note),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline, size: 18, color: AppTheme.warningRed),
                            onPressed: () => provider.deleteNote(note.id),
                          ),
                        ],
                      ),
                      Text(note.text, style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showAddDialog(BuildContext context, NotesProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نیا نوٹ'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'آج کی علامات، احساسات یا سوالات لکھیں...'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('منسوخ')),
          ElevatedButton(
            onPressed: () {
              if (controller.text.trim().isNotEmpty) {
                provider.addNote(controller.text.trim());
              }
              Navigator.pop(context);
            },
            child: const Text('محفوظ کریں'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, NotesProvider provider, NoteModel note) {
    final controller = TextEditingController(text: note.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('نوٹ میں ترمیم کریں'),
        content: TextField(controller: controller, maxLines: 5),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('منسوخ')),
          ElevatedButton(
            onPressed: () {
              provider.updateNote(note.id, controller.text.trim());
              Navigator.pop(context);
            },
            child: const Text('محفوظ کریں'),
          ),
        ],
      ),
    );
  }
}
