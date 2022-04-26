import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:budgetapp/models/expense.dart';

class BudgetPlan {
  final String id;
  final int total;
  final String title;
  final DateTime reminderDate;
  final DateTime creationDate; 
  final bool reminder;
  final List<Expense> expenses;

  BudgetPlan({
    required this.id,
    required this.total,
    required this.title,
    required this.reminderDate,
    required this.reminder,
    required this.creationDate,
    required this.expenses,
  });



  BudgetPlan copyWith({
    String? id,
    int? total,
    String? title,
    DateTime? date,
    DateTime? creationDate,
    bool? reminder,
    List<Expense>? items,
  }) {
    return BudgetPlan(
      id: id ?? this.id,
      creationDate: creationDate??this.creationDate,
      total: total ?? this.total,
      title: title ?? this.title,
      reminderDate: date ?? this.reminderDate,
      reminder: reminder ?? this.reminder,
      expenses: items ?? this.expenses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'title': title,
      'reminderDate': reminderDate.millisecondsSinceEpoch,
      'creationDate': creationDate.millisecondsSinceEpoch,
      'reminder': reminder,
      'expenses': expenses.map((ex) => ex.toMap()).toList(),
    };
  }

  factory BudgetPlan.fromMap(Map<String, dynamic> map) {
    return BudgetPlan(
      id: map['id'] ?? '',
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      total: map['total']?.toInt() ?? 0,
      title: map['title'] ?? '',
      reminderDate: DateTime.fromMillisecondsSinceEpoch(map['reminderDate']),
      reminder: map['reminder'] ?? false,
      expenses: List<Expense>.from(map['expenses']?.map((x) => Expense.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetPlan.fromJson(String source) => BudgetPlan.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BudgetPlan(id: $id, total: $total, title: $title, reminderDate: $reminderDate, reminder: $reminder, items: $expenses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BudgetPlan &&
      other.id == id &&
      other.total == total &&
      other.title == title &&
      other.reminderDate == reminderDate &&
      other.reminder == reminder &&
      listEquals(other.expenses, expenses);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      total.hashCode ^
      title.hashCode ^
      reminderDate.hashCode ^
      reminder.hashCode ^
      expenses.hashCode;
  }
}
