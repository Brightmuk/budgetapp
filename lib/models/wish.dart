import 'dart:convert';

class Wish {
  final String id;
  final String name;
  final DateTime date;
  final bool remider;
  Wish({
    required this.id,
    required this.name,
    required this.date,
    required this.remider,
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
      remider: remider ?? this.remider,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date.millisecondsSinceEpoch,
      'remider': remider,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      date: DateTime.fromMillisecondsSinceEpoch(map['date']),
      remider: map['remider'] ?? false,
    );
  }

  String toJson() => json.encode(toMap());

  factory Wish.fromJson(String source) => Wish.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Wish(id: $id, name: $name, date: $date, remider: $remider)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Wish &&
      other.id == id &&
      other.name == name &&
      other.date == date &&
      other.remider == remider;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      name.hashCode ^
      date.hashCode ^
      remider.hashCode;
  }
}
