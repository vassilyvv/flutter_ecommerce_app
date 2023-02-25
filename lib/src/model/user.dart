class User {
  String? email;
  String? phoneNumber;
  String? firstName;
  String? lastName;
  String? accessToken;
  String? refreshToken;

  int? id;

  bool? isEmailConfirmed;
  String? emailCandidate;
  bool? isPhoneNumberConfirmed;
  String? phoneNumberCandidate;
  bool? isMFAEnabled;

  User(
    this.email,
    this.phoneNumber,
    this.firstName,
    this.lastName,
    this.accessToken,
    this.refreshToken,
    this.id,
    this.isEmailConfirmed,
    this.emailCandidate,
    this.isPhoneNumberConfirmed,
    this.phoneNumberCandidate,
    this.isMFAEnabled
  );
}
