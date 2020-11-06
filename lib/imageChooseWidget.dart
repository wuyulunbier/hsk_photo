import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:image_picker/image_picker.dart';

//选择头像底部弹出框
class ImageChooseWidget extends StatefulWidget {
  ImageChooseWidget({
    Key key,
    this.chooseImgCallBack,
    this.type = 2,
    this.isCamear = false, //选择图片时是否选择相机
  }) : super(key: key);

  final ValueChanged<PickedFile> chooseImgCallBack;
  final int type;
  final bool isCamear;

  ///1 为单张选择   2 为多张选择
  @override
  ImageChooseWidgetState createState() => ImageChooseWidgetState();
}

class ImageChooseWidgetState extends State<ImageChooseWidget> {
  PickedFile _imageFile;
  dynamic _pickImageError;
  List<Asset> images = List<Asset>();
  String _error;
  final ImagePicker _picker = ImagePicker();

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List resultList;
    String error;

    // try {
    resultList = await MultiImagePicker.pickImages(
      maxImages: 9,
      enableCamera: widget.isCamear,
      selectedAssets: images,
      cupertinoOptions: CupertinoOptions(takePhotoIcon: "chat"),
      materialOptions: MaterialOptions(
        actionBarColor: "#abcdef",
        actionBarTitle: "Example App",
        allViewTitle: "All Photos",
        useDetailsView: true,
        selectCircleStrokeColor: "#000000",
      ),
    );
    // } on PlatformException catch (e) {
    //   // error = e.message;
    // }
    if (!mounted) return;

    // setState(() {
    //   images = resultList;
    //   if (error == null) _error = 'No Error Dectected';
    // });
  }

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min, //wrap_content
      children: <Widget>[
        Material(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          color: Colors.white,
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
                Future<PickedFile> imageFile =
                    ImagePicker().getImage(source: ImageSource.camera);
                imageFile.then((result) {
                  print(result);
                  widget.chooseImgCallBack(result);
                });
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Center(
                  child: Text('立即拍照',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              )),
        ),
        Container(
          height: 1,
          color: Color(0xffEFF1F0),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                Navigator.pop(context);

                if (widget.type == 1) {
                  //选择单张图片
                  Future<PickedFile> imageFile =
                      ImagePicker().getImage(source: ImageSource.gallery);
                  imageFile.then((result) {
                    widget.chooseImgCallBack(result);
                  });
                } else {
                  //默认选择多张图片
                  loadAssets();
                }
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Center(
                  child: Text('从相册选择',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              )),
        ),
        Container(
          height: 5,
          color: Color(0xffEFF1F0),
        ),
        Material(
          color: Colors.white,
          child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(
                  vertical: 15.0,
                ),
                child: Center(
                  child: Text('取消',
                      style: TextStyle(fontSize: 16, color: Colors.black)),
                ),
              )),
        ),
      ],
    ));
  }
}
