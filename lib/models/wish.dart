import 'dart:convert';

class Wish {
  final String id;
  final int price;
  final String name;
  final DateTime reminderDate;
  final DateTime creationDate;
  final bool reminder;
  Wish({
    required this.id,
    required this.price,
    required this.name,
    required this.reminderDate,
     required this.creationDate,
    required this.reminder,
  });

  Wish copyWith({
    String? id,
    int? price,
    String? name,
    DateTime? date,
    bool? reminder,
  }) {
    return Wish(
      id: id ?? this.id,
      price: price ?? this.price,
      name: name ?? this.name,
      reminderDate: date ?? this.reminderDate,
      creationDate: date ?? this.creationDate,
      reminder: reminder ?? this.reminder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'name': name,
      'reminderDate': reminderDate.millisecondsSinceEpoch,
      'creationDate':creationDate.millisecondsSinceEpoch,
      'reminder': reminder,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      id: map['id'] ?? '',
      creationDate: DateTime.fromMillisecondsSinceEpoch(map['creationDate']),
      price: map['price']?.toInt() ?? 0,
      name: map['name'] ?? '',
      reminderDate: DateTime.fromMillisecondsSinceEpoch(map['reminderDate']),
      reminder: map['reminder'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wish.fromJson(String source) => Wish.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Wish(id: $id, price: $price, name: $name, date: $reminderDate, creationDate:$creationDate, reminderDate: $reminder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Wish &&
        other.id == id &&
        other.price == price &&
        other.name == name &&
        other.reminderDate == reminderDate &&
        other.reminder == reminder;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        price.hashCode ^
        name.hashCode ^
        reminderDate.hashCode ^
        reminder.hashCode;
  }
}
