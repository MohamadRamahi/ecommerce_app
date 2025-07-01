class SavedAddress {
  final String label;
  final String address;
  final double latitude;
  final double longitude;

  SavedAddress({
    required this.label,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() => {
    'label': label,
    'address': address,
    'latitude': latitude,
    'longitude': longitude,
  };

  factory SavedAddress.fromJson(Map<String, dynamic> json) => SavedAddress(
    label: json['label'],
    address: json['address'],
    latitude: json['latitude'],
    longitude: json['longitude'],
  );
}
