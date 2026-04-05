class LocationModel {
  final String id;
  final String name;
  final String bank;
  final String type;
  final String address;
  final double latitude;
  final double longitude;
  final String distance;
  final String status;
  final String? phone;
  final String imageUrl;
  final List<String> services;
  final Map<String, String> hours;

  const LocationModel({
    required this.id,
    required this.name,
    required this.bank,
    required this.type,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
    required this.status,
    this.phone,
    required this.imageUrl,
    required this.services,
    required this.hours,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      id: json['id'] as String,
      name: json['name'] as String,
      bank: json['bank'] as String,
      type: json['type'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      distance: json['distance'] as String,
      status: json['status'] as String,
      phone: json['phone'] as String?,
      imageUrl: json['imageUrl'] as String,
      services: List<String>.from(json['services'] as List),
      hours: Map<String, String>.from(json['hours'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'bank': bank,
      'type': type,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'distance': distance,
      'status': status,
      'phone': phone,
      'imageUrl': imageUrl,
      'services': services,
      'hours': hours,
    };
  }
}
