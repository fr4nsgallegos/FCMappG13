import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_filex/open_filex.dart';
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

  Future<File> generarPdfConImagen() async {
    final pdf = pw.Document();
    final image = pw.MemoryImage(
      (await rootBundle.load("assets/images/peru.jpeg")).buffer.asUint8List(),
    );

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              children: [
                pw.Text(
                  "PDF CON IMÁGEN",
                  style: pw.TextStyle(
                    fontSize: 30,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 32),
                pw.Text(
                  "Ejemplo de parrado para el pdf con imágenes",
                  style: pw.TextStyle(color: PdfColors.blue),
                ),
                pw.SizedBox(height: 32),
                pw.Image(image, width: 300, height: 300, fit: pw.BoxFit.cover),
              ],
            ),
          );
        },
      ),
    );
    // Obtener la ruta de almacenamiento local
    final output = await getApplicationDocumentsDirectory();

    // Uso path para generar correctamente la ruta
    final filePath = path.join(output.path, "example_imagen.pdf");
    final file = File(filePath);

    // Guardar el archivo
    await file.writeAsBytes(await pdf.save());
    print("pdf guardado en ${file.path}");
    return file;
  }

  void openPdfFile(File filePdf) async {
    try {
      print("Intentando abrir el archivo pdf");
      final result = await OpenFilex.open(filePdf.path);
      print("Resultado al abrir: $result");
    } catch (e) {
      print("Errrorrrr: $e");
    }
  }

  // EXPORTAR A EXCEL
  void exportExcel() async {
    // Crear el libro de excel
    var excel = Excel.createExcel(); //crear un archivo excel vacio

    // Obteniendo la hoja activa o crear una nueva hoja
    Sheet sheet = excel["MiHoja"];

    // Agregamos datos a la celdas
    sheet.cell(CellIndex.indexByString("A1")).value = TextCellValue("NOMBRE");
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        TextCellValue("EDAD");
    sheet.cell(CellIndex.indexByString("C1")).value = TextCellValue("PAÍS");

    // Agregando filas dinámicamente
    List<List<dynamic>> data = [
      ["Carlos", "25", "Perú"],
      ["Mathias", "32", "Mexico"],
      ["Isaías", "65", "España"],
    ];

    for (int i = 0; i < data.length; i++) {
      for (int j = 0; j < data[i].length; j++) {
        print(data[i][j]);
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: j, rowIndex: i + 1))
            .value = TextCellValue(
          data[i][j].toString(),
        );
      }
    }

    // gUARDAR EL EXCEL
    var bytes = excel.encode();

    // Obtengo el directorio de almancenmiento
    Directory? directory = await getExternalStorageDirectory();
    String filePath = "${directory!.path}/reporte.xlsx";

    // Guardar archivo
    File(filePath)
      ..createSync(recursive: true)
      ..writeAsBytes(bytes!);
    print("Archivo guardado en $filePath");

    OpenResult result = await OpenFilex.open(filePath);
    print("Estado de apertura: $result");
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
              onPressed: () async {
                final pdfFile = await generarPdf();
                openPdfFile(pdfFile);
              },
              child: Text("Exportar a pdf"),
            ),
            ElevatedButton(
              onPressed: () async {
                final pdfFile = await generarTablaPdf();
                openPdfFile(pdfFile);
              },
              child: Text("Exportar a pdf con tabla "),
            ),
            ElevatedButton(
              onPressed: () async {
                final pdfFile = await generarPdfConImagen();
                openPdfFile(pdfFile);
              },
              child: Text("Exportar a pdf con imágen "),
            ),
            ElevatedButton(
              onPressed: () {
                exportExcel();
              },
              child: Text("Exportar a excel"),
            ),
          ],
        ),
      ),
    );
  }
}
