class ReportModel {
  final String? id;
  final String locationId;
  final String locationName;
  final String issueType;
  final String? details;
  final String createdAt;

  const ReportModel({
    this.id,
    required this.locationId,
    required this.locationName,
    required this.issueType,
    this.details,
    required this.createdAt,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id']?.toString(),
      locationId: json['locationId'] as String,
      locationName: json['locationName'] as String,
      issueType: json['issueType'] as String,
      details: json['details'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'locationId': locationId,
      'locationName': locationName,
      'issueType': issueType,
      'details': details,
      'createdAt': createdAt,
    };
  }
}
