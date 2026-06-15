import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nice/core/fp/fp.dart';
import 'package:nice/features/auth/data/auth_credentials.dart';
import 'package:nice/features/auth/data/auth_failures.dart';
import 'package:nice/features/auth/data/auth_repository.dart';
import 'package:nice/features/auth/data/auth_service.dart';
import 'package:nice/features/auth/data/email_address.dart';
import 'package:nice/features/auth/state/auth_view_model.dart';

class MockAuthService extends Mock implements AuthService {}

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthService service;
  late MockAuthRepository repository;
  late AuthViewModel viewModel;

  final email = EmailAddress('user@test.com');

  setUpAll(() {
    registerFallbackValue(EmailLinkCredentials(email: email));
  });

  setUp(() {
    service = MockAuthService();
    repository = MockAuthRepository();
    viewModel = AuthViewModel(service, repository);
  });

  group('sendOtp', () {
    test('em sucesso conclui o command e guarda as credenciais', () async {
      when(() => service.sendSignInLink(email)).thenAnswer((_) async => ok);
      when(() => repository.store(any())).thenAnswer((_) async => ok);

      await viewModel.sendOtp(email);

      expect(viewModel.sendOtp.isDone, isTrue);
      final credentials = viewModel.state.credentials;
      expect(credentials, isA<EmailLinkCredentials>());
      expect((credentials! as EmailLinkCredentials).email, email);
    });

    test('em falha marca erro e não persiste credenciais', () async {
      when(
        () => service.sendSignInLink(email),
      ).thenAnswer((_) async => const Err<Unit>(UnknownAuthFailure('boom')));

      await viewModel.sendOtp(email);

      expect(viewModel.sendOtp.isError, isTrue);
      expect(viewModel.state.credentials, isNull);
      verifyNever(() => repository.store(any()));
    });
  });
}
