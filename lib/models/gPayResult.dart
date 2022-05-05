import 'dart:convert';

class GPayResult {
  final String email;
  final String cardDetail;
  final String token;

  GPayResult({
    required this.email,
    required this.cardDetail,
    required this.token,
  });



  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'cardDetail': cardDetail,
      'token': token,
    };
  }

  factory GPayResult.fromMap(Map<String, dynamic> map) {
    return GPayResult( 
      email: map['email'] ?? '',
      cardDetail: map['paymentMethodData']['description'] ?? '',
      token: map['tokenizationData']['token'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory GPayResult.fromJson(String source) => GPayResult.fromMap(json.decode(source));


}
