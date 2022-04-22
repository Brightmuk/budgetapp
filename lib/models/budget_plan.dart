import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:budgetapp/models/expense.dart';

class BudgetPlan {
  final String id;
  final String title;
  final DateTime date;
  final bool reminder;
  final List<Expense> items;
  BudgetPlan({
    required this.id,
    required this.title,
    required this.date,
    required this.reminder,
    required this.items,
  });

  BudgetPlan copyWith({
    String? id,
    String? title,
    DateTime? date,
    bool? reminder,
    List<Expense>? items,
  }) {
    return BudgetPlan(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      reminder: reminder ?? this.reminder,
      items: items ?? this.items,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'reminder': reminder,
      'items': items.map((x) => x.toMap()).toList(),
    };
  }

  factory BudgetPlan.fromMap(Map<String, dynamic> map) {
    return BudgetPlan(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      reminder: map['reminder'] ?? false,
      items: List<Expense>.from(map['items']?.map((x) => Expense.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetPlan.fromJson(String source) => BudgetPlan.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BudgetPlan(id: $id, title: $title, date: $date, reminder: $reminder, items: $items)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BudgetPlan &&
      other.id == id &&
      other.title == title &&
      other.date == date &&
      other.reminder == reminder &&
      listEquals(other.items, items);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      title.hashCode ^
      date.hashCode ^
      reminder.hashCode ^
      items.hashCode;
  }
}
