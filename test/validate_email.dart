import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triviazilla/src/services/helpers.dart';

void main() {
  group('validate email function', () {
    test('should return true for a valid email', () {
      debugPrint("should return true for a valid email");
      debugPrint("sample: test@example.com");

      // Arrange
      final emailController = TextEditingController(text: 'test@example.com');

      // Act
      final result = validateEmail(emailController);

      debugPrint("Result: $result");

      // Assert
      expect(result, true);
    });

    test('should return false for an empty email', () {
      debugPrint("should return false for a valid email");
      debugPrint("sample: ");

      // Arrange
      final emailController = TextEditingController(text: '');

      // Act
      final result = validateEmail(emailController);

      debugPrint("Result: $result");

      // Assert
      expect(result, false);
    });

    test('should return false for an invalid email', () {
      debugPrint("should return false for a valid email");
      debugPrint("sample: invalid_email");

      // Arrange
      final emailController = TextEditingController(text: 'invalid_email');

      // Act
      final result = validateEmail(emailController);

      debugPrint("Result: $result");

      // Assert
      expect(result, false);
    });
  });
}
