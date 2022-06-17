import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ffmpeg_kit_flutter/ffmpeg_kit.dart';
import 'package:ffmpeg_kit_flutter/return_code.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class FfmpegModel extends ChangeNotifier {
  //動画を保存するための関数を作る
  //やっぱなしで

  //動画の速度を変更するための関数を作る
  //まずpathを取得する必要がありそう
  //image_pickerを使えばよいか
  videoFromGallery() async {
    //Galleryから画像を取得
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile =
        await _picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile == null) {
      return;
    }
    print(pickedFile.path);
    await changeSpeedVideo(pickedFile.path);
    return pickedFile.path;
    //SaveImageのsaveLocalImageを実行。
    // var savedFile = await SaveImage.saveLocalImage(pickedFile);
    // imageFile = savedFile;
  }

  Future<void> changeSpeedVideo(inputFilePath) async {
    //任意のデバイスにおいてとれるようにする
    // Dio dio = Dio();
    // var outputFilePath = "/Users/nt/Library/Developer/CoreSimulator/Devices/A181F53E-9B42-4E04-9C1A-E14CD16C6304/data/Containers/Data/Application/CFD4B7F9-2C2E-4427-9324-D0109D3EDA0E/tmp/hoge4.MOV";
    if (await Permission.storage.request().isGranted) {
      //ストレージのパスのためのディレクトリを作る
      var dir = await getTemporaryDirectory();
      final path = dir.path;
      final directory = Directory('$path/video/');
      await directory.create(recursive: true);
      // print(path);
      String commandToExecute =
          '-i $inputFilePath -vf setpts=PTS/2.0 -af atempo=2.0 -y $path/video/hoge.MOV';
      await FFmpegKit.execute(commandToExecute).then((session) async {
        final returnCode = await session.getReturnCode();
        if (ReturnCode.isSuccess(returnCode)) {
          // SUCCESS
          // notifyListeners();
          print('FFmpeg process exited with rc: $returnCode');
          await GallerySaver.saveVideo("$path/video/hoge.MOV");
          print("$path/video/hoge.MOV");
          directory.deleteSync(recursive: true);
        } else if (ReturnCode.isCancel(returnCode)) {
          // CANCEL
          print("キャンセル $returnCode");
        } else {
          // ERROR
          print("エラー $returnCode");
          // print(failStackTrace);

        }

        // notifyListeners();
        // print('FFmpeg process exited with rc: $rc');
        // controller = VideoPlayerController.asset(Constants.OUTPUT_PATH)
        //   ..initialize().then((_) {
        //     notifyListeners();
        //   });
        print(inputFilePath);
      });
    } else if (await Permission.storage.isPermanentlyDenied) {
      // loading = false;
      notifyListeners();
      openAppSettings();
    }
  }

  void deleteFile(File file) {
    file.exists().then((exists) {
      if (exists) {
        try {
          file.delete();
        } on Exception catch (e, stack) {
          print("Exception thrown inside deleteFile block. $e");
          print(stack);
        }
      }
    });

    // static Future saveLocalImage(PickedFile image) async {
    //   //ストレージパス取得
    //   final path = await localPath;
    //
    //   //basename(image.path)で.jpgを取得。
    //   final String fileName = basename(image.path);
    //   final imagePath = '$path/$fileName';
    //
    //   //SharePreferenceで画像のストレージパスを保存
    //   SharedPrefWrite(imagePath);
    //   File imageFile = File(imagePath);
    //
    //   //選択した画像をByteDataにしてリターン
    //   var saveFile = await imageFile.writeAsBytes(await image.readAsBytes());
    //   return saveFile;
    // }

    // static Future get localPath async {
    //
    //   //path_providerの機能でディレクトリを取得。
    //   Directory appDocDir = await getApplicationDocumentsDirectory();
    //
    //   //ディレクトリのパスを取得。
    //   String path = appDocDir.path;
    //   return path;
    // }

    //速度を変更した動画を保存する関数を作る
  }
}
