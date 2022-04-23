import 'dart:convert';

class Wish {
  final String id;
  final int price;
  final String name;
  final DateTime date;
  final bool reminder;
  Wish({
    required this.id,
    required this.price,
    required this.name,
    required this.date,
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
      date: date ?? this.date,
      reminder: reminder ?? this.reminder,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'price': price,
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'reminder': reminder,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      id: map['id'] ?? '',
      price: map['price']?.toInt() ?? 0,
      name: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      reminder: map['reminder'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wish.fromJson(String source) => Wish.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Wish(id: $id, price: $price, name: $name, date: $date, reminder: $reminder)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Wish &&
      other.id == id &&
      other.price == price &&
      other.name == name &&
      other.date == date &&
      other.reminder == reminder;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      price.hashCode ^
      name.hashCode ^
      date.hashCode ^
      reminder.hashCode;
  }
}
