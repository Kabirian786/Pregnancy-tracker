import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../core/constants/app_constants.dart';
import '../services/hive_service.dart';

class NoteModel {
  final String id;
  final String text;
  final DateTime date;

  NoteModel({required this.id, required this.text, required this.date});

  Map<String, dynamic> toMap() => {'id': id, 'text': text, 'date': date.toIso8601String()};

  factory NoteModel.fromMap(Map map) => NoteModel(
        id: map['id'] as String,
        text: map['text'] as String,
        date: DateTime.parse(map['date'] as String),
      );
}

/// روزانہ ڈائری / نوٹس پرووائیڈر
class NotesProvider extends ChangeNotifier {
  Box get _box => HiveService.box(AppConstants.notesBox);

  List<NoteModel> get notes {
    final raw = _box.get('list', defaultValue: []) as List;
    final list = raw.map((e) => NoteModel.fromMap(Map.from(e as Map))).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  void addNote(String text) {
    final list = notes
      ..insert(0, NoteModel(id: DateTime.now().microsecondsSinceEpoch.toString(), text: text, date: DateTime.now()));
    _box.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  void deleteNote(String id) {
    final list = notes..removeWhere((n) => n.id == id);
    _box.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }

  void updateNote(String id, String newText) {
    final list = notes;
    final idx = list.indexWhere((n) => n.id == id);
    if (idx == -1) return;
    list[idx] = NoteModel(id: id, text: newText, date: list[idx].date);
    _box.put('list', list.map((e) => e.toMap()).toList());
    notifyListeners();
  }
}
