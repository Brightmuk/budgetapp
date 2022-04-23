import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:budgetapp/models/expense.dart';

class BudgetPlan {
  final String id;
  final int total;
  final String title;
  final DateTime date;
  final bool reminder;
  final List<Expense> expenses;
  BudgetPlan({
    required this.id,
    required this.total,
    required this.title,
    required this.date,
    required this.reminder,
    required this.expenses,
  });



  BudgetPlan copyWith({
    String? id,
    int? total,
    String? title,
    DateTime? date,
    bool? reminder,
    List<Expense>? items,
  }) {
    return BudgetPlan(
      id: id ?? this.id,
      total: total ?? this.total,
      title: title ?? this.title,
      date: date ?? this.date,
      reminder: reminder ?? this.reminder,
      expenses: items ?? this.expenses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'total': total,
      'title': title,
      'date': date.millisecondsSinceEpoch,
      'reminder': reminder,
      'expenses': expenses.map((ex) => ex.toMap()).toList(),
    };
  }

  factory BudgetPlan.fromMap(Map<String, dynamic> map) {
    return BudgetPlan(
      id: map['id'] ?? '',
      total: map['total']?.toInt() ?? 0,
      title: map['title'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      reminder: map['reminder'] ?? false,
      expenses: List<Expense>.from(map['expenses']?.map((x) => Expense.fromMap(x))),
    );
  }

  String toJson() => json.encode(toMap());

  factory BudgetPlan.fromJson(String source) => BudgetPlan.fromMap(json.decode(source));

  @override
  String toString() {
    return 'BudgetPlan(id: $id, total: $total, title: $title, date: $date, reminder: $reminder, items: $expenses)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is BudgetPlan &&
      other.id == id &&
      other.total == total &&
      other.title == title &&
      other.date == date &&
      other.reminder == reminder &&
      listEquals(other.expenses, expenses);
  }

  @override
  int get hashCode {
    return id.hashCode ^
      total.hashCode ^
      title.hashCode ^
      date.hashCode ^
      reminder.hashCode ^
      expenses.hashCode;
  }
}
