import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('E2EE Logic Test', () {
    const password = 'test-password';
    final data = utf8.encode('Hello World, this is a secret message!');

    encrypt.Key deriveKey(String password) {
      final passwordBytes = utf8.encode(password);
      final hash = sha256.convert(passwordBytes);
      return encrypt.Key(Uint8List.fromList(hash.bytes));
    }

    List<int> encryptData(List<int> data, String password) {
      final key = deriveKey(password);
      final iv = encrypt.IV.fromSecureRandom(12);
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm, padding: null));
      
      final encrypted = encrypter.encryptBytes(data, iv: iv);
      
      final result = Uint8List(iv.bytes.length + encrypted.bytes.length);
      result.setAll(0, iv.bytes);
      result.setAll(iv.bytes.length, encrypted.bytes);
      return result;
    }

    List<int> decryptData(List<int> encryptedData, String password) {
      final key = deriveKey(password);
      final iv = encrypt.IV(Uint8List.fromList(encryptedData.sublist(0, 12)));
      final ciphertext = Uint8List.fromList(encryptedData.sublist(12));
      
      final encrypter = encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.gcm, padding: null));
      return encrypter.decryptBytes(encrypt.Encrypted(ciphertext), iv: iv);
    }

    test('should encrypt and decrypt correctly', () {
      final encrypted = encryptData(data, password);
      expect(encrypted, isNot(equals(data)));
      expect(encrypted.length, equals(data.length + 12));

      final decrypted = decryptData(encrypted, password);
      expect(decrypted, equals(data));
      expect(utf8.decode(decrypted), 'Hello World, this is a secret message!');
    });

    test('should return different data with wrong password', () {
      final encrypted = encryptData(data, password);
      final decryptedWithWrongPass = decryptData(encrypted, 'wrong-password');
      expect(decryptedWithWrongPass, isNot(equals(data)));
    });
  });
}
