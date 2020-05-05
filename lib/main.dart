import 'package:flutter/material.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ome_scrollable_positioned_list',
      home: _MyHomePage(),
    );
  }
}

class _MyHomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<_MyHomePage> {
  final items = List<String>.generate(100, (i) => 'Item$i');
  // スクロールを司るコントローラ
  final ItemScrollController _itemScrollController = ItemScrollController();
  // リストアイテムのインデックスを司るリスナー
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();

  @override
  void initState() {
    super.initState();
    // 表示中のアイテムを知るためにリスナー登録
    _itemPositionsListener.itemPositions.addListener(_itemPositionsCallback);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('scrollable_positioned_list example'),
      ),
      body: ScrollablePositionedList.separated(
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: items.length,
        itemScrollController: _itemScrollController,    // コントローラ指定
        itemPositionsListener: _itemPositionsListener,  // リスナー指定
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _scroll,
        child: Icon(Icons.airplanemode_active),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  @override
  void dispose() {
    // 使い終わったら破棄
    _itemPositionsListener.itemPositions.removeListener(_itemPositionsCallback);
    super.dispose();
  }

  void _scroll() {
    // スムーズスクロールを実行する
    _itemScrollController.scrollTo(
      index: 50,
      duration: Duration(seconds: 1),
      curve: Curves.easeInOutCubic,
    );
  }

  void _itemPositionsCallback() {
    // 表示中のリストアイテムのインデックス情報を取得
    final visibleIndexes = _itemPositionsListener.itemPositions.value
        .toList()
        .map((itemPosition) => itemPosition.index);
    print('現在表示中アイテムのindexは $visibleIndexes');
  }
}
