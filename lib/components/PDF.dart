import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:login_screen/app/home/models/event.dart';
import 'package:login_screen/services/database.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

const bool kIsWeb = identical(0, 0.0);

class PDF extends StatefulWidget {
  const PDF({Key key, this.database, this.event}) : super(key: key);
  final Database database;
  final Event event;

  static Future<void> show(BuildContext context,
      {Database database, Event event}) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => PDF(database: database, event: event),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _PDFState createState() => _PDFState();
}

class _PDFState extends State<PDF> {
  final pdf = pw.Document();

  void _showPrintedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document printed successfully'),
      ),
    );
  }

  void _showSharedToast(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Document shared successfully'),
      ),
    );
  }

  Future<void> _saveAsFile(BuildContext context, LayoutCallback build,
      PdfPageFormat pageFormat) async {
    final bytes = await build(pageFormat);
    final appDocDir = await getApplicationDocumentsDirectory();
    final appDocPath = appDocDir.path;
    String filename = widget.event.name.toString();
    final file = File(appDocPath + '/' + '$filename.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    await OpenFile.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final actions = <PdfPreviewAction>[
      if (!kIsWeb)
        PdfPreviewAction(
          icon: const Icon(Icons.save),
          onPressed: _saveAsFile,
        )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("PDF Viewer"),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        build: (format) => generateDocument(format),
        actions: actions,
        onPrinted: _showPrintedToast,
        onShared: _showSharedToast,
      ),
    );
  }

  Future<Uint8List> generateDocument(PdfPageFormat format) async {
    final doc = pw.Document(pageMode: PdfPageMode.outlines);

    final String _name = widget.event.name.toString().toUpperCase();
    final String _place = widget.event.place.toString();
    final String _start = widget.event.start.toString();
    final String _budget = widget.event.budget.toString();

    doc.addPage(
      pw.MultiPage(
        pageFormat:
            PdfPageFormat.letter.copyWith(marginBottom: 1.5 * PdfPageFormat.cm),
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        header: (pw.Context context) {
          if (context.pageNumber == 1) {
            return pw.SizedBox();
          }
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              padding: const pw.EdgeInsets.only(bottom: 3.0 * PdfPageFormat.mm),
              decoration: const pw.BoxDecoration(
                  border: pw.Border(
                      bottom:
                          pw.BorderSide(width: 0.5, color: PdfColors.grey))),
              child: pw.Text('Portable Document Format',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        footer: (pw.Context context) {
          return pw.Container(
              alignment: pw.Alignment.centerRight,
              margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
              child: pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey)));
        },
        build: (pw.Context context) => <pw.Widget>[
          pw.Header(
              level: 0,
              title: 'PDF Report Of $_name Event.',
              child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: <pw.Widget>[
                    pw.Text('PDF Report Of $_name Event.', textScaleFactor: 2),
                    pw.PdfLogo()
                  ])),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Event Name :'),
              pw.Bullet(text: '$_name\n'),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Event Place :'),
              pw.Bullet(text: '$_place\n'),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Event Date & Time :'),
              pw.Bullet(text: '$_start\n'),
            ],
          ),
          pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: <pw.Widget>[
              pw.Paragraph(text: 'Event Budget :'),
              pw.Bullet(text: '$_budget\n'),
            ],
          ),
        ],
      ),
    );

    return await doc.save();
  }
}
