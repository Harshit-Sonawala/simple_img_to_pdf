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
  final _docNameController = TextEditingController();
  var _saved = false;

  @override
  Widget build(BuildContext context) {

    final loadedImgList = Provider.of<ImgListProvider>(context).imgList;
    final timeStamp = DateTime.now().toString();
    String lastSavedFilePath;

    void createPDF(String fileName) async {
      final pdf = pw.Document();
      for (int i = 0; i < loadedImgList.length; i++) {
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
      final file = File('${outputDirectory.path}/$fileName');
      print('Successfully Saved PDF to: ${outputDirectory.path}/$fileName');
      await file.writeAsBytes(await pdf.save());
      lastSavedFilePath = '${outputDirectory.path}/$fileName';

      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text('Saved PDF to: ${outputDirectory.path}/$fileName'),
          action: SnackBarAction(
            label: 'View',
            onPressed: () {
              OpenFile.open('${outputDirectory.path}/$fileName');
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.note_add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'Save File As: ',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'If not specified, it takes the timestamp as the name',
                style: TextStyle(
                  fontSize: 16,
                  //color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                controller: _docNameController,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.edit),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: lastSavedFilePath == null ? 'New Document $timeStamp.pdf' : lastSavedFilePath,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: RaisedButton(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        setState(() {
                          if (_docNameController.text.isEmpty) {
                            createPDF('New Document $timeStamp.pdf');
                          } else {
                            if(_docNameController.text.length > 4 && _docNameController.text.substring(_docNameController.text.length-4) == '.pdf') {
                              createPDF(_docNameController.text);
                            } else {
                              createPDF('${_docNameController.text}.pdf');
                            }
                          }
                          _saved = true;
                        });
                      },
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Save",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                _saved ? Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: RaisedButton(
                      onPressed: () {
                        OpenFile.open('$lastSavedFilePath');
                      },
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Open",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                : Container(),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                'File Preview: ',
                style: TextStyle(
                  fontSize: 18,
                  color: Theme.of(context).primaryColor,
                ),
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
                      child: Container(
                        height: 500,
                        child: Image.file(
                          loadedImgList[index],
                          fit: BoxFit.contain,
                        ),
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
