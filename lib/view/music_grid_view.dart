import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sound_app/model/MusicInfo.dart';
import 'package:sound_app/util/Routes.dart';

class MusicGridView extends StatefulWidget {
  final list;
  final Function(String, MusicInfo) clickedItem;

  const MusicGridView({Key? key, required this.list, required this.clickedItem})
      : super(key: key);

  @override
  _MusicGridViewState createState() =>
      _MusicGridViewState(list: list, clickedItem: clickedItem);
}

class _MusicGridViewState extends State<MusicGridView> {
  final List<MusicInfo> list;
  final Function(String, MusicInfo) clickedItem;

  _MusicGridViewState({required this.list, required this.clickedItem});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8),
        itemCount: list.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final item = list[index];
          return Container(
              alignment: Alignment.center,
              child: GestureDetector(
                child: ClipRect(
                  child: Column(
                    children: [
                      item.imageUrl.contains("https")
                          ? Image(image: NetworkImage(item.imageUrl))
                          : Image(
                              image: AssetImage(item.imageUrl),
                              fit: BoxFit.cover,
                            ),
                      Text(
                        item.name,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
                onTap: () async {
                  clickedItem(musicPlayerScreen, item);
                },
              ));
        });
  }
}
