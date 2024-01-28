final class PasswordAuthentication {
  final String userName;
  final String password;

  /// Creates a new `PasswordAuthentication` object from the given
  /// user name and password.
  ///
  /// <p> Note that the given user password is cloned before it is stored in
  /// the new `PasswordAuthentication` object.
  ///
  /// * userName the user name
  /// * password the user's password
  PasswordAuthentication(this.userName, this.password);
}
