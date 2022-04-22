import 'dart:convert';

class Expense {
  final String name;
  final int index;
  final int quantity;
  final int price;
  
  Expense({
    required this.name,
    required this.index,
    required this.quantity,
    required this.price,
  });



  Expense copyWith({
    String? name,
    int? index,
    int? quantity,
    int? price,
  }) {
    return Expense(
      name: name ?? this.name,
      index: index ?? this.index,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'index': index,
      'quantity': quantity,
      'price': price,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      name: map['name'] ?? '',
      index: map['index']?.toInt() ?? 0,
      quantity: map['quantity']?.toInt() ?? 0,
      price: map['price']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Expense.fromJson(String source) => Expense.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Expense(name: $name, index: $index, quantity: $quantity, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Expense &&
      other.name == name &&
      other.index == index &&
      other.quantity == quantity &&
      other.price == price;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      index.hashCode ^
      quantity.hashCode ^
      price.hashCode;
  }
}
