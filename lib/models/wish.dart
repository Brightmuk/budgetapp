import 'dart:convert';

class Wish {
  final String id;
  final String name;
  final DateTime date;
  final bool reminder;
  Wish({
    required this.id,
    required this.name,
    required this.date,
    required this.reminder,
  });

  Wish copyWith({
    String? id,
    String? name,
    DateTime? date,
    bool? remider,
  }) {
    return Wish(
      id: id ?? this.id,
      name: name ?? this.name,
      date: date ?? this.date,
      reminder: remider ?? this.reminder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'reminder': reminder,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      reminder: map['reminder'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wish.fromJson(String source) => Wish.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Wish(id: $id, name: $name, date: $date, remider: $reminder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Wish &&
      other.id == id &&
      other.name == name &&
      other.date == date &&
      other.reminder == reminder;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      date.hashCode ^
      reminder.hashCode;
  }
}
