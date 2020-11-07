import 'package:flutter/material.dart';
import 'hsk_bottom_sheet.dart';
import 'package:photo/photo.dart';
import 'package:photo_manager/photo_manager.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

const double itemSpace = 10.0;
const double space = 5.0; //上下左右间距
const double deleBtnWH = 20.0;
const Color bgColor = Colors.white;

typedef CallBack = void Function(List imgData, List fileData);

class HskPhotoPickerTool extends StatefulWidget {
  final double lfPaddingSpace; //外部设置的左右间距
  final CallBack callBack;
  final int type;

  ///1 为单张选择   2 为多张选择
  HskPhotoPickerTool({
    this.lfPaddingSpace,
    this.callBack,
    this.type = 2,
  });

  @override
  _HskPhotoPickerToolState createState() => _HskPhotoPickerToolState();
}

class _HskPhotoPickerToolState extends State<HskPhotoPickerTool> {
  List imgData = List(); //图片list
  List fileData = List(); //file 数据
  List<AssetEntity> imgPicked = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgData.add("selectPhoto_add"); //先添加 加号按钮 的图片
  }

  @override
  void setState(fn) {
    // TODO: implement setState
    super.setState(fn);
    List data = List();
    List file = List();
    data.addAll(imgData);
    print(fileData);
    file.addAll(fileData);

    data.removeAt(imgData.length - 1);
    // file.removeAt(fileData.length);
    widget.callBack(data, file);
  }

  @override
  Widget build(BuildContext context) {
    var kScreenWidth = MediaQuery.of(context).size.width;

    var lfPadding = widget.lfPaddingSpace == null ? 0.0 : widget.lfPaddingSpace;
    var ninePictureW = (kScreenWidth - space * 2 - 2 * itemSpace - lfPadding);
    var itemWH = ninePictureW / 3;
    int columnCount = imgData.length > 6 ? 3 : imgData.length <= 3 ? 1 : 2;

    return Container(
        color: bgColor,
        width: kScreenWidth - lfPadding,
        height:
            columnCount * itemWH + space * 2 + (columnCount - 1) * itemSpace,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              //可以直接指定每行（列）显示多少个Item
              //一行的Widget数量
              crossAxisCount: 3,
              crossAxisSpacing: itemSpace, //水平间距
              mainAxisSpacing: itemSpace, //垂直间距
              childAspectRatio: 1.0, //子Widget宽高比例
            ),
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(space), //GridView内边距
            itemCount: imgData.length,
            itemBuilder: (context, index) {
              if (index == imgData.length - 1) {
                return addBtn(context, setState, imgData, imgPicked,
                    widget.type, fileData);
              } else {
                return imgItem(index, setState, imgData, imgPicked, fileData);
              }
            }));
  }
}

/** 添加按钮 */
Widget addBtn(context, setState, imgData, imgPicked, type, files) {
  return GestureDetector(
    child: Image.asset(
      'assets/addphoto@2x.png',
      fit: BoxFit.fill,
      // width: 90,
      //height: 90,
    ),
    onTap: () {
      //点击添加按钮
      HskBottomSheet.showText(context, dataArr: ["拍照", "相册"], title: "请选择",
          clickCallback: (index, str) async {
        print(index);
        if (index == 1) {
          var image = await ImagePicker.pickImage(source: ImageSource.camera);
          print(image);
          imgData.insert(imgData.length - 1, image.path);
          files.insert(files.length, File(image.path));
          setState(() {});
        }
        if (index == 2) {
          if (type == 2) {
            pickAsset(context, setState, imgData, imgPicked, files);
          } else {
            var image =
                await ImagePicker().getImage(source: ImageSource.gallery);
            imgData.insert(imgData.length - 1, image.path);
            files.insert(files.length, File(image.path));
            setState(() {});
          }
        }
      });
    },
  );
}

/** 图片和删除按钮 */
Widget imgItem(index, setState, imgData, imgPicked, files) {
  return GestureDetector(
    child: Container(
      color: Colors.transparent,
      child: Stack(alignment: Alignment.topRight, children: <Widget>[
        ConstrainedBox(
          child: Image.file(File(imgData[index]), fit: BoxFit.cover),
          constraints: BoxConstraints.expand(),
        ),
        GestureDetector(
          child: Image.asset(
            'assets/delete_select.png',
            fit: BoxFit.fitWidth,
            width: 25,
            height: 25,
          ),
          onTap: () {
            print(index);
            print('点击删除');
            //点击删除按钮
            setState(() {
              imgData.removeAt(index);
              files.removeAt(index);
//                    imgPicked.removeAt(index);
            });
          },
        )
      ]),
    ),
    onTap: () {
      print("点击第${index}张图片");
    },
  );
}

/** 多图选择 */
void pickAsset(context, setState, imgData, imgPicked, files) async {
  final result = await PhotoPicker.pickAsset(
      context: context,
//    pickedAssetList: imgPicked,
      maxSelected: 10 - imgData.length,
      pickType: PickType.onlyImage);

  if (result != null && result.isNotEmpty) {
    for (var e in result) {
      var file = await e.file;
//      print(file.absolute.path)
      if (!imgData.contains(file.absolute.path)) {
        imgData.insert(imgData.length - 1, file.absolute.path);
        files.insert(files.length, file);
      }
    }
  }
  setState(() {});
}
