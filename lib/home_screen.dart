import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './imglist_provider.dart';
import './confirm_screen.dart';
import './customButton.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int pageIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Future<bool> _onBackPressed() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        elevation: 3,
        title: Text(
          'Are you sure you want to exit?',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
        content: Text('You will lose unsaved changes'),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: () => Navigator.pop(context, false),
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext scaffoldContext) {
    final loadedImgList = Provider.of<ImgListProvider>(context).imgList;
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Simple Images to PDF'),
          actions: [IconButton(icon: Icon(Icons.info), onPressed: (){})],
        ),
        body: Column(
          children: <Widget> [
            Expanded(
              flex: 7,
              child: loadedImgList.length == 0// && _latestImage == null
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
                      'Add one or more images...',
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
                  itemCount: loadedImgList.length,
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
                              loadedImgList[index],
                              fit: BoxFit.contain,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              icon: Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                //try changing to 'index' here incase of error.
                                Provider.of<ImgListProvider>(context, listen: false,).deleteImage(pageIndex);
                                if (loadedImgList.length > 0) {
                                  pageController.animateToPage(
                                    loadedImgList.length-1,
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.ease,
                                  );
                                }
                              },
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
                    'Page ${loadedImgList.length == 0 ? pageIndex : pageIndex+1} of ${loadedImgList.length}',
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
                  onTap: () async {
                    await Provider.of<ImgListProvider>(context, listen: false,).getImageFromCamera();
                    setState(() {
                      if(loadedImgList.length > 1) {
                        pageController.animateToPage(
                          loadedImgList.length - 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    });
                  },
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
                  onTap: () async{
                    await Provider.of<ImgListProvider>(context, listen: false,).getImageFromGallery();
                    setState(() {
                      if(loadedImgList.length > 1) {
                        pageController.animateToPage(
                          loadedImgList.length - 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease,
                        );
                      }
                    });
                  },
                )
              ),
            ),
            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: CustomButton(
                  icon: Icons.double_arrow,
                  label: 'Continue',
                  onTap: () {
                    if(loadedImgList.length > 0) {
                      Navigator.of(context).pushNamed(ConfirmScreen.routeName);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 3,
                          title: Text(
                            'No images added',
                            style: TextStyle(
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          content: Text('Please add atleast one image to proceed further.'),
                          actions: [
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      );
                    }
                  },
                )
              ),
            ),
            SizedBox(
              height: 10,
            )
          ],
        ),
      ),
    );
  }
}