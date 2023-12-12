enum TermType {
  termOfUse("서비스 이용약관", fileName: "term_of_use", isRequired: true),
  privacyPolicy("개인정보 처리방침 및 수집이용 동의", fileName: "privacy_policy", isRequired: true),
  servicePushAgree("서비스 알림 수신 동의", fileName: "service_push"),
  marketingConsent("마케팅 정보 수신 및 이용 동의", fileName: "marketing_consent");

  final String termName;
  final String fileName;
  final bool isRequired;
  const TermType(this.termName, {required this.fileName, this.isRequired = false});
}
