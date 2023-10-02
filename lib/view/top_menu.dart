import 'package:flutter/material.dart';

class TopMenu extends StatefulWidget {
  final Function(String) onItemClicked;
  final List<String> listName;
  TopMenu({Key? key, required this.onItemClicked,required this.listName}) : super(key: key);

  late _TopMenuState a;


  void setList(List<String> list) {
    a.setState(() {

    });
  }
  @override
  _TopMenuState createState() => a = _TopMenuState(onItemClicked: onItemClicked);
}

class _TopMenuState extends State<TopMenu> {

  _TopMenuState({required this.onItemClicked});
  Function(String) onItemClicked;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Container(
        color: const Color(0xff16123D),
        child: Row(
          children: [
            for(var i in widget.listName)
              _getMenuItem(widget.listName.indexOf(i), i)

          ],
        ),
      ),
    );
  }

  Widget _getMenuItem(int index, String name) {
    return menuItem(index, name);
  }

  var selectedIndex = 0;

  Widget menuItem(int index, String text, ) {
    var isSame = selectedIndex == index;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Center(
        child: Container(
          decoration: isSame
              ? null
              : BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                primary:
                    isSame ? const Color(0xff596BFC) : const Color(0xff181F55),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20))),
            child: Row(
              children: [
                Text(
                  text,
                  style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white),
                ),
              ],
            ),
            onPressed: () {
              onItemClicked(text);
              if (isSame) {
                selectedIndex = 0;
              } else {
                selectedIndex = index;
              }
            },
          ),
        ),
      ),
    );
  }

  Widget fav() {
    return Center(
      child: Row(
        children: const [
          SizedBox(width: 5),
          Icon(Icons.favorite, color: Colors.red, size: 15,),
        ],
      ),
    );
  }
}
