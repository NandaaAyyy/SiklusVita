class CycleModel {
  final int? id;
  final DateTime startDate;
  final int length;
  final bool isPCOS;

  CycleModel({this.id, required this.startDate, required this.length, this.isPCOS = false});

  factory CycleModel.fromMap(Map<String, dynamic> map) {
    return CycleModel(
      id: map['id'] as int?,
      startDate: DateTime.parse(map['startDate']),
      length: map['length'] as int,
      isPCOS: (map['isPCOS'] ?? 0) == 1,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'startDate': startDate.toIso8601String(),
        'length': length,
        'isPCOS': isPCOS ? 1 : 0,
      };
}
