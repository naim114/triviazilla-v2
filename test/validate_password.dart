import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:triviazilla/src/services/helpers.dart';

void main() {
  group('validate password function', () {
    /**
     * Pasword should be not null/empty and have at least;
     * one uppercase letter
     * one lowercase letter
     * one numbers
     * one special characters
     */

    test('should return true for a valid password', () {
      debugPrint("should return true for a valid password");
      debugPrint("sample: Test@1234");

      // Arrange
      final passwordController = TextEditingController(text: 'Test@1234');

      // Act
      final result = validatePassword(passwordController);

      debugPrint("Result: $result");

      // Assert
      expect(result, true);
    });

    test('should return false for an empty password', () {
      debugPrint("should return false for an empty password");
      debugPrint("sample: ");

      // Arrange
      final passwordController = TextEditingController(text: '');

      // Act
      final result = validatePassword(passwordController);

      debugPrint("Result: $result");

      // Assert
      expect(result, false);
    });

    test('should return false for a password without uppercase letters', () {
      debugPrint(
          "should return false for a password without uppercase letters");
      debugPrint("sample: test@1234");

      // Arrange
      final passwordController = TextEditingController(text: 'test@1234');

      // Act
      final result = validatePassword(passwordController);

      debugPrint("Result: $result");

      // Assert
      expect(result, false);
    });

    test('should return false for a password without lowercase letters', () {
      debugPrint(
          "should return false for a password without lowercase letters");
      debugPrint("sample: TEST@1234");

      // Arrange
      final passwordController = TextEditingController(text: 'TEST@1234');

      // Act
      final result = validatePassword(passwordController);

      debugPrint("Result: $result");

      // Assert
      expect(result, false);
    });

    test('should return false for a password without numbers', () {
      debugPrint("should return false for a password without numbers");
      debugPrint("sample: Test@Password");

      // Arrange
      final passwordController = TextEditingController(text: 'Test@Password');

      // Act
      final result = validatePassword(passwordController);

      debugPrint("Result: $result");

      // Assert
      expect(result, false);
    });

    test('should return false for a password without special characters', () {
      debugPrint(
          "should return false for a password without special characters");
      debugPrint("sample: Test1234");

      // Arrange
      final passwordController = TextEditingController(text: 'Test1234');

      // Act
      final result = validatePassword(passwordController);

      debugPrint("Result: $result");

      // Assert
      expect(result, false);
    });

    test('should return false for a password with insufficient length', () {
      debugPrint("should return false for a password with insufficient length");
      debugPrint("sample: Test@12");

      // Arrange
      final passwordController = TextEditingController(text: 'Test@12');

      // Act
      final result = validatePassword(passwordController);

      debugPrint("Result: $result");

      // Assert
      expect(result, false);
    });
  });
}
