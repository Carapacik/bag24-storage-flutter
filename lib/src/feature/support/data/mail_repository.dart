import 'package:bag24/src/feature/initialization/model/environment.dart';
import 'package:enough_mail/enough_mail.dart';

abstract interface class IMailRepository() {
  Future<void> sendMessage({required String subject, required String text});
}

final class const MailRepository({
  required final Environment environment,
  required final String mailSupportEmail,
  required final String mailClientEmail,
  required final String mailClientPassword,
}) implements IMailRepository {
  @override
  Future<void> sendMessage({required String subject, required String text}) async {
    final String recipient = mailSupportEmail;
    final String email = mailClientEmail;
    final String password = mailClientPassword;
    final ClientConfig? config = await Discover.discover(email);
    if (config == null) {
      throw Exception('Client config is null');
    }
    final account = MailAccount.fromDiscoveredSettings(
      name: 'mobile_app',
      email: email,
      password: password,
      config: config,
      userName: 'mobile_app',
    );

    final mailClient = MailClient(account, isLogEnabled: true);
    try {
      await mailClient.connect();
      final builder = MessageBuilder.prepareMultipartAlternativeMessage(htmlText: text, plainText: text)
        ..from = [MailAddress('${environment.value} Mobile App', email)]
        ..to = [MailAddress('Bag24 Support', recipient)]
        ..subject = subject
        ..buildMimeMessage();
      final MimeMessage mimeMessage = builder.buildMimeMessage();
      await mailClient.sendMessage(mimeMessage);
    } on MailException {
      rethrow;
    }
  }
}
