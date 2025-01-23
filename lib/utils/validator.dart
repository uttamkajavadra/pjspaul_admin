class Validator {
  static String? validateNull(field, value) {
    if (value == null || value == '') {
      return '$field is required';
    }
    return null;
  }
}