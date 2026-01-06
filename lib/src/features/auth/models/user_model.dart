enum UserRole {
  elderly,
  caregiver,
  hospitalStaff,
  volunteer,
}

class User {
  final String id;
  final String name;
  final String email;
  final UserRole role;
  final String? uniqueId; // For Elderly: ELD-XXX
  final List<String> linkedElderlyIds; // For Caregivers
  final bool isActive; // Account Status for Admin Control
  final String conditions;
  final String medicines;
  final String medicineTiming;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.uniqueId,
    this.linkedElderlyIds = const [],
    this.isActive = true,
    this.conditions = '',
    this.medicines = '',
    this.medicineTiming = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'uniqueId': uniqueId,
      'linkedElderlyIds': linkedElderlyIds,
      'isActive': isActive,
      'conditions': conditions,
      'medicines': medicines,
      'medicineTiming': medicineTiming,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.name == map['role'],
        orElse: () => UserRole.elderly,
      ),
      uniqueId: map['uniqueId'],
      linkedElderlyIds: List<String>.from(map['linkedElderlyIds'] ?? []),
      isActive: map['isActive'] ?? true,
      conditions: map['conditions'] ?? 'Not specified',
      medicines: map['medicines'] ?? 'None',
      medicineTiming: map['medicineTiming'] ?? 'As prescribed',
    );
  }
}
