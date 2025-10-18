import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
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
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  "Hola este es un pdf creado por Flutter! ",
                  style: pw.TextStyle(
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 32),
                pw.Text("Factura"),
                pw.Text("Cliente: Juanito Perez"),
                pw.Text("Fecha:  ${DateTime.now()}"),
                pw.Container(
                  height: 16,
                  width: 32,
                  decoration: pw.BoxDecoration(color: PdfColor(1, 1, 1)),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Obtener la ruta de almacenamiento local
    final output = await getApplicationDocumentsDirectory();

    // Uso path para generar correctamente la ruta
    final filePath = path.join(output.path, "example1.pdf");
    final file = File(filePath);

    // Guardar el archivo
    await file.writeAsBytes(await pdf.save());
    print("pdf guardado en ${file.path}");
    return file;
  }

  Future<File> generarTablaPdf() async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
            headers: ["Producto", "Cantidad", "Precio"],
            data: [
              ["Laptop", "1", "S/ 14500"],
              ["Mouse", "2", "S/ 50"],
              ["Teclado", "10", "S/ 300"],
            ],
          );
        },
      ),
    );
    // Obtener la ruta de almacenamiento local
    final output = await getApplicationDocumentsDirectory();

    // Uso path para generar correctamente la ruta
    final filePath = path.join(output.path, "example_tabla.pdf");
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
            ElevatedButton(
              onPressed: () {
                generarTablaPdf();
              },
              child: Text("Exportar a pdf con tabla "),
            ),
          ],
        ),
      ),
    );
  }
}
