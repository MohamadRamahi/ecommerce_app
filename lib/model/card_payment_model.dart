class CardModel {
  final String type;
  final String number;
  final String expiryDate;
  final String securityCode;

  final bool isDefault;

  CardModel({
    required this.type,
    required this.number,
    required this.expiryDate,
    required this.securityCode,
    this.isDefault = false,
  });

  Map<String, dynamic> toJson() => {
    "type": type,
    "number": number,
    "expiryDate": expiryDate,
    'securityCode':securityCode,
    "isDefault": isDefault,
  };

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      type: json["type"],
      number: json["number"],
      expiryDate: json["expiryDate"],
      securityCode: json["expiryDate"],
      isDefault: json["isDefault"] ?? false,
    );
  }
}
