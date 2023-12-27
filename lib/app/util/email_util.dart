import 'package:flutter_email_sender/flutter_email_sender.dart';

class EmailUtil {
  final List<String> _recipients = ['wonhee0619@gmail.com'];

  void sendInqueryEmail() {
    _sendEmail('[티캣츠 문의하기]', '');
  }

  void sendReportEmail(String title, String body) {
    _sendEmail('[티캣츠 신고하기]', '');
  }

  void _sendEmail(String subject, String body) {
    final Email email = Email(
      recipients: _recipients,
      subject: subject,
      body: body,
      cc: [],
      bcc: [],
      isHTML: false,
    );

    FlutterEmailSender.send(email);
  }
}
