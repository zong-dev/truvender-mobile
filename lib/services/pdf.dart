import 'dart:io';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:truvender/data/models/models.dart';
import 'package:truvender/utils/utils.dart';
import 'package:truvender/widgets/widgets.dart';

class PDFService {
  static Future<File> generate(
      {required Map<String, dynamic> data, required User user}) async {
    final pdf = Document();
    pdf.addPage(
      MultiPage(
        build: (context) => [
          buildHeader(),
          buildTitle(data, user),
          Divider(),
          buildData(data),
        ],
        footer: (context) => buildFooter(),
      ),
    );
    return PdfApi.saveDocument(name: '${data['ref']}.pdf', pdf: pdf);
  }

  static Widget buildHeader() {
    return Container(padding:  const EdgeInsets.only(bottom: 30, ), child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const LogoWidget(withText: true) as Widget,
      ]
    ));
  }

  static Widget buildTitle(Map data, User user) => Container(
        padding: const EdgeInsets.only(top: 10, bottom: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['type'],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                )
              ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${user.currency}${moneyFormat(data['amount'])}",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 6),
                Text(
                  data['status'].toString().toUpperCase(),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                )
              ],
            )
          ],
        ),
      );

  static Widget buildData(data) => Container(
      margin: const EdgeInsets.only(top: 12),
      child: Column(
        children: data.entries.forEach((entry) => KeyValue(
              name: entry.key,
              value: entry.value,
            ),
        ),
      )
    );
    
  static Widget buildFooter() => Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Customer Service: support@truvender.com", style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold
        ))
      ]
    )
  );
}

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
