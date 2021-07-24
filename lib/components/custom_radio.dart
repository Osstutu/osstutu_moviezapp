import 'package:flutter/material.dart';
import 'package:moviex/util.dart';

typedef GenreTapCallback = void Function(int);

class CustomRadio extends StatefulWidget {
  final List<RadioModel> radioItems;
  final GenreTapCallback onTap;

  CustomRadio({@required this.radioItems, this.onTap});

  @override
  createState() => CustomRadioState();
}

class CustomRadioState extends State<CustomRadio> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.radioItems.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            splashColor: Colors.blueAccent,
            onTap: () {
              setState(() {
                if (widget.radioItems[index].isSelected == true) {
                  return;
                }
                // print('tapped');
                widget.onTap(widget.radioItems[index].genreId);

                widget.radioItems
                    .forEach((element) => element.isSelected = false);
                widget.radioItems[index].isSelected = true;
              });
            },
            child: RadioItem(widget.radioItems[index]),
          );
        },
      ),
    );
  }
}

class RadioItem extends StatelessWidget {
  final RadioModel _item;
  RadioItem(this._item);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: Material(
        borderRadius: BorderRadius.circular(5.0),
        color: _item.isSelected ? darkBlue : Colors.white,
        elevation: _item.isSelected ? 8.0 : 0.0,
        child: Container(
          width: 100.0,
          child: Center(
            child: Text(
              _item.text,
              style:
                  TextStyle(color: _item.isSelected ? Colors.white : darkBlue),
            ),
          ),
        ),
      ),
    );
  }
}

class RadioModel {
  bool isSelected;
  final String text;
  final int genreId;

  RadioModel(this.isSelected, this.text, this.genreId);
}
