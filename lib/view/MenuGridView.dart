import 'dart:ffi';

import 'package:flutter/material.dart';

import '../model/ListBoxState.dart';

class MenuGridView extends StatefulWidget {
  const MenuGridView({Key? key}) : super(key: key);

  @override
  _MenuGridViewState createState() => _MenuGridViewState();
}

class _MenuGridViewState extends State<MenuGridView> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        children: List.generate(4, (index) => image(list[index])),
      ),
    );
  }

  Widget image(ListBoxState item) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: GestureDetector(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: !item.value
                ? const BoxDecoration(
              color: Color(0xff181F55)
            )
                : BoxDecoration(
                    border: Border.all(color: const Color(0xff596BFC)),
                    borderRadius: BorderRadius.circular(20),
              color: const Color(0xff181F55)
                  ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    item.image,
                  ),
                ),
                Text(item.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white),)
              ],
            ),
          ),
        ),
        onTap: () {
          item.value = !item.value;
          setState(() {});
        },
      ),
    );
  }

  final list = [
    ListBoxState(title: "Reduce stress or anxiety", image: "assets/images/anexiety.png"),
    ListBoxState(title: "Trouble falling asleep", image: "assets/images/sleep.png"),
    ListBoxState(title: "Improve performance", image: "assets/images/productivity.png"),
    ListBoxState(title: "Create a healthy habit", image: "assets/images/relax.png"),
  ];
}
