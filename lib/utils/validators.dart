class PasswordValidator {
  static const int minLength = 8;

  static List<String> unmetRequirements(String password) {
    final unmet = <String>[];
    if (password.length < minLength) unmet.add('Min $minLength characters');
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      unmet.add('Add an uppercase letter');
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      unmet.add('Add a lowercase letter');
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) unmet.add('Add a number');
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      unmet.add('Add a special character');
    }
    return unmet;
  }

  static String? validate(String password) {
    if (password.isEmpty) return 'Password is required';
    if (password.length < minLength) {
      return 'Min $minLength characters';
    }
    if (!RegExp(r'[A-Z]').hasMatch(password)) {
      return 'Add an uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(password)) {
      return 'Add a lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(password)) {
      return 'Add a number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      return 'Add a special character';
    }
    return null; // valid
  }

  static int strengthScore(String password) {
    int score = 0;
    if (password.length >= minLength) score++;
    if (RegExp(r'[A-Z]').hasMatch(password)) score++;
    if (RegExp(r'[a-z]').hasMatch(password)) score++;
    if (RegExp(r'[0-9]').hasMatch(password)) score++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) score++;
    return score;
  }
}