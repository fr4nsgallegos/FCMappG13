import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path/path.dart' as path;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Exportación a PDF
  Future<File> generarPdf() async {
    // Crear un documento PDF
    final pdf = pw.Document();

    // Aggregar contenido al pdf
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(child: pw.Text("Hola esto es un pdf"));
        },
      ),
    );

    // Obtener la ruta de almacenamiento local
    final output = await getApplicationDocumentsDirectory();

    // Uso path para generar correctamente la ruta
    final filePath = path.join(output.path, "example.pdf");
    final file = File(filePath);

    // Guardar el archivo
    await file.writeAsBytes(await pdf.save());
    print("pdf guardado en ${file.path}");
    return file;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home Page")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
              onPressed: () {
                generarPdf();
              },
              child: Text("Exportar a pdf"),
            ),
          ],
        ),
      ),
    );
  }
}
