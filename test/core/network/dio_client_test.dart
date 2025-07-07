import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_pokemon_clean_arc/core/network/dio_client.dart';
import 'package:flutter_pokemon_clean_arc/core/constants/api_constants.dart';

void main() {
  group('DioClient', () {
    late DioClient dioClient;

    setUp(() {
      dioClient = DioClient();
    });

    test('should have correct base URL', () {
      expect(dioClient.dio.options.baseUrl, equals(ApiConstants.baseUrl));
    });

    test('should have correct timeout settings', () {
      expect(dioClient.dio.options.connectTimeout,
          equals(ApiConstants.connectTimeout));
      expect(dioClient.dio.options.receiveTimeout,
          equals(ApiConstants.receiveTimeout));
    });

    test('should have correct headers', () {
      expect(dioClient.dio.options.headers['Content-Type'],
          equals('application/json'));
      expect(
          dioClient.dio.options.headers['Accept'], equals('application/json'));
    });
  });
}
