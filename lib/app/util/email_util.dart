import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailUtil {
  final List<String> _recipients = ['wonhee0619@gmail.com'];

  Future<void> sendInqueryEmail() async {
    await _sendEmail('[티캣츠 문의하기]', '');
  }

  Future<void> sendReportEmail(String title, String body) async {
    await _sendEmail('[티캣츠 신고하기]', '');
  }

  Future<void> _sendEmail(String subject, String body) async {
    final Email email = Email(
      recipients: _recipients,
      subject: subject,
      body: body,
      cc: [],
      bcc: [],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }
}
