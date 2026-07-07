import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/utils/date_utils.dart';
import '../../controllers/appointment_provider.dart';
import '../../widgets/custom_card.dart';

/// ڈاکٹر اپائنٹمنٹ اسکرین
class AppointmentScreen extends StatelessWidget {
  const AppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppointmentProvider>();
    final appointments = provider.appointments;

    return Scaffold(
      appBar: AppBar(title: const Text('ڈاکٹر اپائنٹمنٹ')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, provider),
        child: const Icon(Icons.add),
      ),
      body: appointments.isEmpty
          ? const Center(child: Text('کوئی اپائنٹمنٹ محفوظ نہیں'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final a = appointments[index];
                final isPast = a.dateTime.isBefore(DateTime.now());
                return CustomCard(
                  color: isPast ? Colors.grey.shade100 : Colors.white,
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: AppTheme.lightGreen,
                        child: const Icon(Icons.local_hospital, color: AppTheme.primaryGreen),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ڈاکٹر: ${a.doctorName}', style: Theme.of(context).textTheme.titleMedium),
                            Text(a.hospital, style: Theme.of(context).textTheme.bodyMedium),
                            Text(
                              '${AppDateUtils.urduDate(a.dateTime)} - ${TimeOfDay.fromDateTime(a.dateTime).format(context)}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            if (a.notes.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text('نوٹ: ${a.notes}', style: Theme.of(context).textTheme.bodySmall),
                              ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: AppTheme.warningRed),
                        onPressed: () => provider.deleteAppointment(a.id),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  void _showAddDialog(BuildContext context, AppointmentProvider provider) {
    final doctorController = TextEditingController();
    final hospitalController = TextEditingController();
    final notesController = TextEditingController();
    DateTime? selectedDate;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('نئی اپائنٹمنٹ شامل کریں'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: doctorController, decoration: const InputDecoration(labelText: 'ڈاکٹر کا نام')),
                const SizedBox(height: 8),
                TextField(controller: hospitalController, decoration: const InputDecoration(labelText: 'ہسپتال')),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(const Duration(days: 400)),
                          );
                          if (date != null) setState(() => selectedDate = date);
                        },
                        child: Text(selectedDate == null ? 'تاریخ منتخب کریں' : AppDateUtils.dateKey(selectedDate!)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () async {
                          final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                          if (time != null) setState(() => selectedTime = time);
                        },
                        child: Text(selectedTime == null ? 'وقت منتخب کریں' : selectedTime!.format(context)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(controller: notesController, decoration: const InputDecoration(labelText: 'نوٹس (اختیاری)')),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('منسوخ')),
            ElevatedButton(
              onPressed: () {
                if (doctorController.text.isEmpty || selectedDate == null || selectedTime == null) return;
                final dt = DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime!.hour,
                  selectedTime!.minute,
                );
                provider.addAppointment(AppointmentModel(
                  id: DateTime.now().microsecondsSinceEpoch.toString(),
                  doctorName: doctorController.text,
                  hospital: hospitalController.text,
                  dateTime: dt,
                  notes: notesController.text,
                ));
                Navigator.pop(context);
              },
              child: const Text('محفوظ کریں'),
            ),
          ],
        ),
      ),
    );
  }
}
