class PhoneVerificationCodeSentEvent {
  const PhoneVerificationCodeSentEvent(this.verificationId, this.forceResendingToken);
  final String verificationId;
  final int? forceResendingToken;
}
