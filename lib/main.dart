import 'package:flutter/material.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class ItemData {
  String key;
  String title;
  Color color;
  Color lineColor;

  ItemData(this.key, this.title, this.color, this.lineColor);

  @override
  String toString() {
    return 'Item{key: $key, title: $title, color: $color,lineColor: $lineColor}';
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final scaffoldState = GlobalKey<ScaffoldState>();
  GlobalKey<ScaffoldState> _key = GlobalKey(); // added
  final List listTemp = <ItemData>[
    ItemData('key1', 'item1', Colors.grey[200], Colors.grey[400]),
    ItemData('key2', 'item2', Colors.grey[200], Colors.grey[400]),
    ItemData('key3', 'item3', Colors.grey[200], Colors.grey[400]),
    ItemData('key4', 'item4', Colors.grey[200], Colors.grey[400]),
    ItemData('key5', 'item5', Colors.grey[200], Colors.grey[400]),
    ItemData('key6', 'item6', Colors.grey[200], Colors.grey[400]),
    ItemData('key7', 'item7', Colors.grey[200], Colors.grey[400]),
    ItemData('key8', 'item8', Colors.grey[200], Colors.grey[400]),
    ItemData('key9', 'item9', Colors.grey[200], Colors.grey[400]),
    ItemData('key10', 'item10', Colors.grey[200], Colors.grey[400]),
  ];

  @override
  void initState() {
    super.initState();
  }

  void onReorder(int oldIndex, int newIndex) {
    print("oldIndex = ${oldIndex} newIndex= ${newIndex}");
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    ItemData item = listTemp[oldIndex];
    if (newIndex < oldIndex) {
      setState(() {
        item.color = Colors.green[500];
        item.lineColor = Colors.green[700];
      });
    } else if (newIndex > oldIndex) {
      setState(() {
        item.color = Colors.red[500];
        item.lineColor = Colors.red[700];
      });
    }
    setState(() {
      listTemp.removeAt(oldIndex);
      listTemp.insert(newIndex, item);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Text("app"),
      ),
      body: ReorderableListView(
        onReorder: onReorder,
        children: _getListItems(),
      ),
    );
  }

  List<Widget> _getListItems() => listTemp
      .asMap()
      .map((i, item) => MapEntry(i, _buildTenableListTile(item, i)))
      .values
      .toList();

  Widget _buildTenableListTile(ItemData item, int index) {
    return Padding(
      key: Key(item.key),
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Card(
            color: item.color,
            child: Dismissible(
              key: Key(item.key),
              child: InkWell(
                  onTap: () async {
                    var result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Details(key: _key, itemData: item),
                      ),
                    );
                    if (result != null) {
                      scaffoldState.currentState.showSnackBar(
                        SnackBar(
                          content: Text('Playlist updated successfully'),
                        ),
                      );
                      setState(() {
                        listTemp.clear();
                        listTemp.addAll(result);
                      });
                    }
                  },
                  child: ListTile(
                      title: Text(
                    item.title,
                    style: TextStyle(fontSize: 18),
                  ))),
              background: Container(color: Colors.grey),
              onDismissed: (direction) {
                print("direction=======${direction}");
                if (direction == DismissDirection.startToEnd) {
                  setState(() {
                    listTemp[index].color = Colors.green[500];
                    listTemp[index].lineColor = Colors.green[700];

                    // added this block
                    ItemData deletedItem = listTemp.removeAt(index);
                    listTemp.insert(0, deletedItem);
                    _key.currentState
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content: Text("top replace \"${deletedItem.title}\""),
                        ),
                      );
                  });
                } else if (direction == DismissDirection.endToStart) {
                  setState(() {
                    listTemp[index].color = Colors.red[500];
                    listTemp[index].lineColor = Colors.red[700];

                    // added this block
                    ItemData deletedItem = listTemp.removeAt(index);
                    listTemp.insert(listTemp.length, deletedItem);
                    _key.currentState
                      ..removeCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          content:
                              Text("botom replace \"${deletedItem.title}\""),
                        ),
                      );
                  });
                }
              },
            ),
          ),
          Container(
            height: 2,
            color: listTemp[index].lineColor,
          )
        ],
      ),
    );
  }
}

class Details extends StatefulWidget {
  final ItemData itemData;

  const Details({Key key, this.itemData}) : super(key: key);

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: Container(
        color: widget.itemData.color,
        child: Center(
            child: Text(widget.itemData.title,
                style:
                    TextStyle(fontSize: 28, color: widget.itemData.lineColor))),
      ),
    );
  }
}
