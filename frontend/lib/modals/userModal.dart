// lib/models/user.dart
import 'enums.dart';
import 'doctorModal.dart';
import 'patientModal.dart';

class User {
  final int? id;
  final String? address;
  final DateTime? birthdate;
  final String? username;
  final String? name;
  final String? password;
  final String? phoneNumber;
  final String? role;
  final bool? disabled;
  final Doctor? doctor;  // May be null if the user is not a doctor
  final Patient? patient; // May be null if the user is not a patient

  User({
    this.id,
    this.address,
    this.birthdate,
    this.username,
    this.name,
    this.password,
    this.phoneNumber,
    this.role,
    this.disabled,
    this.doctor,
    this.patient,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      // Note: Check for field name differences here ('adress' vs 'address')
      address: json['adress'] as String?,
      birthdate: json['birthdate'] != null
          ? DateTime.parse(json['birthdate'])
          : null,
      username: json['username'] as String?,
      name: json['name'] as String?,
      password: json['password'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      role: json['role'] as String?,
      disabled: json['disabled'] as bool? ?? false,
      doctor: json['doctor'] != null
          ? Doctor.fromJson(json['doctor'])
          : null,
      patient: json['patient'] != null
          ? Patient.fromJson(json['patient'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      // Note: Sending 'adress' as key, matching the backend naming.
      'adress': address,
      'birthdate': birthdate?.toIso8601String(),
      'username': username,
      'name': name,
      'password': password,
      'phoneNumber': phoneNumber,
      'role': role,
      'disabled': disabled,
      'doctor': doctor?.toJson(),
      'patient': patient?.toJson(),
    };
  }
}
