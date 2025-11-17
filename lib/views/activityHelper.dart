import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

Future<void> exportCSVwithSAF(List<Map<String, String>> logs, String fileName) async {
  final headers = logs.first.keys.toList();
  String csv = "${headers.join(",")}\n";

  for (var row in logs) {
    csv += headers
        .map((key) => row[key]!.replaceAll(",", ";"))
        .join(",") + "\n";
  }

  final Uint8List csvBytes = Uint8List.fromList(csv.codeUnits);

  final savedPath = await FilePicker.platform.saveFile(
    dialogTitle: 'Simpan CSV',
    fileName: "$fileName.csv",
    type: FileType.custom,
    allowedExtensions: ['csv'],
    bytes: csvBytes,  
  );

  if (savedPath == null) {
    throw Exception("Penyimpanan dibatalkan");
  }
}
