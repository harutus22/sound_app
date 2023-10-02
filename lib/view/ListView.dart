import 'package:flutter/material.dart';
import 'package:sound_app/model/CheckBoxState.dart';

class ListMenuView extends StatefulWidget {
  const ListMenuView({Key? key}) : super(key: key);

  @override
  _listMenuViewState createState() => _listMenuViewState();
}

class _listMenuViewState extends State<ListMenuView> {

  var selectedIndex = -1;
  final list = [
    CheckBoxState(title: "Sounds of the city"),
    CheckBoxState(title: "Nature sounds"),
    CheckBoxState(title: "Inhouse sounds"),
    CheckBoxState(title: "Animal sounds"),
    CheckBoxState(title: "Other"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
      shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (context, index) {
      return checkBoxItem(list[index]);
    });
  }

  Widget checkBoxItem(CheckBoxState checkBox) => Container(
    decoration: const BoxDecoration(
      color: Color(0xff181F55),
      borderRadius: BorderRadius.all(Radius.circular(20))
    ),
    child: CheckboxListTile(
      side: const BorderSide(
        width: 1,
        color: Colors.white,
      ),
      controlAffinity: ListTileControlAffinity.trailing,
        activeColor: const Color(0xff596BFC),
        checkColor: Colors.white,
        selectedTileColor: Colors.white,
        title: Text(checkBox.title,
        style: const TextStyle(fontSize: 16, color: Colors.white),),
      value: checkBox.value,
      onChanged: (value) => setState(() {
        checkBox.value = value!;
      })
    ),
  );
}


