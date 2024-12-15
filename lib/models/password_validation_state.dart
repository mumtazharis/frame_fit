class PasswordValidationState {
  final bool hasMinLength;
  final bool hasUppercase;
  final bool hasLowercase;
  final bool hasDigits;
  final bool hasSpecialChar;

  const PasswordValidationState({
    this.hasMinLength = false,
    this.hasUppercase = false,
    this.hasLowercase = false,
    this.hasDigits = false,
    this.hasSpecialChar = false,
  });

  PasswordValidationState copyWith({
    bool? hasMinLength,
    bool? hasUppercase,
    bool? hasLowercase,
    bool? hasDigits,
    bool? hasSpecialChar,
  }) {
    return PasswordValidationState(
      hasMinLength: hasMinLength ?? this.hasMinLength,
      hasUppercase: hasUppercase ?? this.hasUppercase,
      hasLowercase: hasLowercase ?? this.hasLowercase,
      hasDigits: hasDigits ?? this.hasDigits,
      hasSpecialChar: hasSpecialChar ?? this.hasSpecialChar,
    );
  }

  bool get isPasswordValid => 
    hasMinLength && 
    hasUppercase && 
    hasLowercase && 
    hasDigits && 
    hasSpecialChar;
}