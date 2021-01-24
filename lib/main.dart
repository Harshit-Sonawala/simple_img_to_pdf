import 'dart:io';
//import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
//import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:open_file/open_file.dart';
import './customButton.dart';

//todo:
//remove spaces on pdf generation.
//fix deleteimg iconbutton causing improper page display.
//after delete animation.
//add page in between two pages.
//cropping images
//editing the order & delete all button.
//rename files.

//recent files screen: listviewbuilder(icon-title-date-no_pages).


void main() => runApp(SimpleImgToPdf());

class SimpleImgToPdf extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple Images To Pdf',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'ProductSans',
      ),
      routes: {},
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int pageIndex = 0;
  File _latestImage;
  List<File> imgList = [];
  final imgpicker = ImagePicker();

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Future getImageFromCamera() async {
    final pickedFile = await imgpicker.getImage(
      source: ImageSource.camera,
    );
    setState(() {
      if (pickedFile != null) {
        _latestImage = File(pickedFile.path);
        imgList.add(_latestImage);
      } else {
        print('No image selected.');
      }
      if(imgList.length > 1) {
        pageController.animateToPage(
          imgList.length - 1,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  Future getImageFromGallery() async {
    final pickedFile = await imgpicker.getImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        _latestImage = File(pickedFile.path);
        imgList.add(_latestImage);
      } else {
        print('No image selected.');
      }
      if(imgList.length > 1) {
        pageController.animateToPage(
          imgList.length - 1,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  deleteImage() {
    setState(() {
      imgList.removeAt(pageIndex);
      if (imgList.length == 0) {
        _latestImage = null;
      } else {
        _latestImage = imgList[imgList.length-1];
        pageController.animateToPage(
          imgList.length-1,
          duration: Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      }
    });
  }

  void createPDF() async {
    final pdf = pw.Document();
    for (int i = 0; i < imgList.length; i++) {
      //Uint8List imageData = File(thisImageInstance.toString()).readAsBytesSync();
      //var imgBytes = await Image.file(imgList[i]).image.toByteData();
      
      // final imageToPrint = PdfImage.file(
      //   pdf.document,
      //   bytes: thisImageInstance.readAsBytesSync(),
      // );
      
      var imageToPrint = pw.MemoryImage(imgList[i].readAsBytesSync());

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Expanded(
            child: pw.Expanded(
              child: pw.Image(
                imageToPrint,
              ),
            ),
          ),
        ),
      );
    }
    final outputDirectory = await getExternalStorageDirectory();
    final timeStamp = DateTime.now().toString();
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

//   class PdfPreviewScreen extends StatelessWidget {

//   //Path del pdf 
//   PdfPreviewScreen({this.path});

//   final String path;

//   @override
//   Widget build(BuildContext context) {
//     return PDFViewerScaffold(

//       path: path,
//     );
//   }
// }

  @override
  Widget build(BuildContext scaffoldContext) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Simple Images to PDF'),
        actions: [IconButton(icon: Icon(Icons.info), onPressed: (){})],
      ),
      body: Column(
        children: <Widget> [
          Expanded(
            flex: 7,
            child: imgList.length == 0// && _latestImage == null
            ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.photo,
                    size: 40,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Start adding images...',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                ],
              )
            )
            : Padding(
              padding: const EdgeInsets.fromLTRB(30, 10, 30, 0),
              child: PageView.builder(
                controller: pageController,
                itemCount: imgList.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 3,
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: <Widget> [
                        Center(
                          child: Image.file(
                            imgList[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: deleteImage,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onPageChanged: (getIndex) {
                  setState(() {
                    pageIndex = getIndex;
                    print('pageIndex: $pageIndex');
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Page ${imgList.length == 0 ? pageIndex : pageIndex+1} of ${imgList.length}',
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).accentColor
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: CustomButton(
                icon: Icons.add_a_photo,
                label: 'Add from camera',
                onTap: getImageFromCamera,
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: CustomButton(
                icon: Icons.wallpaper,
                label: 'Add from gallery',
                onTap: getImageFromGallery,
              )
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              child: CustomButton(
                icon: Icons.done,
                label: 'Finish and convert',
                onTap: createPDF,
              )
            ),
          ),
          SizedBox(
            height: 10,
          )
        ],
      ),
    );
  }
}

