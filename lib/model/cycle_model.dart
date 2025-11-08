class CycleModel {
  final int? id;
  final DateTime startDate;
  final int length;
  final bool isPCOS;

  CycleModel({this.id, required this.startDate, required this.length, this.isPCOS = false});

  factory CycleModel.fromMap(Map<String, dynamic> m) => CycleModel(
        id: m['id'] as int?,
        startDate: DateTime.parse(m['startDate']),
        length: m['length'] as int,
        isPCOS: (m['isPCOS'] ?? 0) == 1,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'startDate': startDate.toIso8601String(),
        'length': length,
        'isPCOS': isPCOS ? 1 : 0,
      };
}
