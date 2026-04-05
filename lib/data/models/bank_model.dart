class BankModel {
  final String id;
  final String name;
  final String fullName;
  final String colorHex;
  final String? logoUrl;
  final String website;

  const BankModel({
    required this.id,
    required this.name,
    required this.fullName,
    required this.colorHex,
    this.logoUrl,
    required this.website,
  });

  factory BankModel.fromJson(Map<String, dynamic> json) {
    return BankModel(
      id: json['id'] as String,
      name: json['name'] as String,
      fullName: json['fullName'] as String,
      colorHex: json['colorHex'] as String,
      logoUrl: json['logoUrl'] as String?,
      website: json['website'] as String,
    );
  }

  /// A static "All Banks" sentinel for use in the filter UI.
  static BankModel get allBanks => const BankModel(
    id: 'all',
    name: 'All Banks',
    fullName: 'All Banks',
    colorHex: '#455A64',
    website: '',
  );
}
