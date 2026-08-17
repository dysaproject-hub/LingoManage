enum EducationLevel {
  paud,
  sd,
  smp,
  sma,
  d1,
  d2,
  d3,
  s1,
  s2,
  s3,
  other,
}

extension EducationLevelExtension on EducationLevel {
  String get label {
    switch (this) {
      case EducationLevel.paud:
        return 'PAUD / TK';
      case EducationLevel.sd:
        return 'SD / Sederajat';
      case EducationLevel.smp:
        return 'SMP / Sederajat';
      case EducationLevel.sma:
        return 'SMA / SMK / Sederajat';
      case EducationLevel.d1:
        return 'Diploma 1 (D1)';
      case EducationLevel.d2:
        return 'Diploma 2 (D2)';
      case EducationLevel.d3:
        return 'Diploma 3 (D3)';
      case EducationLevel.s1:
        return 'Sarjana (S1) / D4';
      case EducationLevel.s2:
        return 'Magister (S2)';
      case EducationLevel.s3:
        return 'Doktor (S3)';
      case EducationLevel.other:
        return 'Other';
    }
  }

  String get objek {
    switch (this) {
      case EducationLevel.paud:
        return 'PAUD / TK';
      case EducationLevel.sd:
        return 'SD / Sederajat';
      case EducationLevel.smp:
        return 'SMP / Sederajat';
      case EducationLevel.sma:
        return 'SMA / SMK / Sederajat';
      case EducationLevel.d1:
        return 'Diploma 1 (D1)';
      case EducationLevel.d2:
        return 'Diploma 2 (D2)';
      case EducationLevel.d3:
        return 'Diploma 3 (D3)';
      case EducationLevel.s1:
        return 'Sarjana (S1) / D4';
      case EducationLevel.s2:
        return 'Magister (S2)';
      case EducationLevel.s3:
        return 'Doktor (S3)';
      case EducationLevel.other:
        return 'Other';
    }
  }

  static EducationLevel fromLabel(String? label) {
    if (label == null || label.isEmpty) return EducationLevel.other;

    return EducationLevel.values.firstWhere(
      (e) => e.label.toLowerCase() == label.toLowerCase().trim(),
      orElse: () => EducationLevel.other,
    );
  }
}