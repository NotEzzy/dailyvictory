import 'package:flutter_test/flutter_test.dart';
import 'package:dailyvictory/utils/helpers.dart';

void main() {
  group('Helpers', () {
    test('formatDate formats date correctly', () {
      final date = DateTime(2024, 3, 15);
      expect(Helpers.formatDate(date), 'Mar 15, 2024');
    });

    test('formatTime formats time correctly', () {
      final time = DateTime(2024, 3, 15, 14, 30);
      expect(Helpers.formatTime(time), '2:30 PM');
    });

    test('formatDateTime formats date and time correctly', () {
      final dateTime = DateTime(2024, 3, 15, 14, 30);
      expect(Helpers.formatDateTime(dateTime), 'Mar 15, 2024 2:30 PM');
    });

    test('getRelativeTime returns correct relative time', () {
      final now = DateTime.now();
      expect(Helpers.getRelativeTime(now), 'Just now');
      
      final oneHourAgo = now.subtract(const Duration(hours: 1));
      expect(Helpers.getRelativeTime(oneHourAgo), '1h ago');
      
      final oneDayAgo = now.subtract(const Duration(days: 1));
      expect(Helpers.getRelativeTime(oneDayAgo), '1d ago');
    });

    test('isValidEmail validates email correctly', () {
      expect(Helpers.isValidEmail('test@example.com'), true);
      expect(Helpers.isValidEmail('invalid-email'), false);
      expect(Helpers.isValidEmail('test@.com'), false);
    });

    test('isValidPassword validates password correctly', () {
      expect(Helpers.isValidPassword('password123'), true);
      expect(Helpers.isValidPassword('short'), false);
      expect(Helpers.isValidPassword(''), false);
    });

    test('truncateText truncates text correctly', () {
      expect(Helpers.truncateText('Hello World', 5), 'Hello...');
      expect(Helpers.truncateText('Short', 10), 'Short');
    });

    test('formatFileSize formats file size correctly', () {
      expect(Helpers.formatFileSize(500), '500 B');
      expect(Helpers.formatFileSize(1500), '1.5 KB');
      expect(Helpers.formatFileSize(1500000), '1.5 MB');
      expect(Helpers.formatFileSize(1500000000), '1.5 GB');
    });

    test('getInitials returns correct initials', () {
      expect(Helpers.getInitials('John Doe'), 'JD');
      expect(Helpers.getInitials('John'), 'J');
      expect(Helpers.getInitials(''), '');
    });
  });
} 