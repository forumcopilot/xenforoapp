class PasskeyValidationResult {
  final bool isDisabled;
  final int? errorCode;

  const PasskeyValidationResult._({required this.isDisabled, this.errorCode});

  const PasskeyValidationResult.enabled() : this._(isDisabled: false);

  const PasskeyValidationResult.disabled(int code)
      : this._(isDisabled: true, errorCode: code);
}
