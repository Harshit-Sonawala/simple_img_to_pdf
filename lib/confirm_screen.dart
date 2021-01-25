import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import './imglist_provider.dart';

class ConfirmScreen extends StatefulWidget {
  static const routeName = '/confirm_screen';
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {

    final loadedImgList = Provider.of<ImgListProvider>(context).imgList;
    final timeStamp = DateTime.now().toString();

    void createPDF() async {
      final pdf = pw.Document();
      for (int i = 0; i < loadedImgList.length; i++) {
        //ignore these other implementations.
        //Uint8List imageData = File(thisImageInstance.toString()).readAsBytesSync();
        //var imgBytes = await Image.file(imgList[i]).image.toByteData();
        
        // final imageToPrint = PdfImage.file(
        //   pdf.document,
        //   bytes: thisImageInstance.readAsBytesSync(),
        // );
        
        var imageToPrint = pw.MemoryImage(loadedImgList[i].readAsBytesSync(),);

        pdf.addPage(
          pw.Page(
            pageTheme: pw.PageTheme(
              margin: const pw.EdgeInsets.all(0),
            ),
            build: (pw.Context context) => pw.Center(
              child: pw.Image(
                imageToPrint,
                fit: pw.BoxFit.contain,
              ),
            ),
          ),
        );
      }

      final outputDirectory = await getExternalStorageDirectory();
      final file = File('${outputDirectory.path}/New Document $timeStamp.pdf');
      print('Successfully Saved pdf to: ${outputDirectory.path}/New Document $timeStamp.pdf');
      await file.writeAsBytes(await pdf.save());

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Saved pdf to: ${outputDirectory.path}/New Document $timeStamp.pdf'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              OpenFile.open('${outputDirectory.path}/New Document $timeStamp.pdf');
            },
          ),
        ),
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Save PDF'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                labelText: 'Rename File',
                hintText: 'New Document $timeStamp.pdf',
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: createPDF,
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Save",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Cancel",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: RaisedButton(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {},
                    color: Theme.of(context).primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Open",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              'File Preview: ',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: loadedImgList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Card(
                      elevation: 3,
                      clipBehavior: Clip.antiAlias,
                      child: Image.file(
                        loadedImgList[index],
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
