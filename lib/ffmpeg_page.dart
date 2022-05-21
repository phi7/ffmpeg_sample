import 'package:ffmpeg_sample/ffmpeg_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FfmpegPage extends StatelessWidget {
  const FfmpegPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<FfmpegModel>(
      create: (_) => FfmpegModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ffmpeg sample"),
        ),
        body: Center(
          child: Consumer<FfmpegModel>(builder: (context, model, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(onPressed: (){

                  }, child: const Text("動画保存")),
                  ElevatedButton(onPressed: (){
                    model.videoFromGallery();

                  }, child: const Text("動画選択&速度変更"))
                ],
              );
            }
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){},
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
