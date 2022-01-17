import 'package:flutter/material.dart';
import 'package:kdh_homepage/_common/model/WidgetToGetSize.dart';
import 'package:kdh_homepage/_common/util/AppComponents.dart';
import 'package:kdh_homepage/_common/util/LogUtil.dart';
import 'package:kdh_homepage/_common/util/MediaQueryUtil.dart';

abstract class KDHState<T extends StatefulWidget> extends State<T> {
  List<WidgetToGetSize> widgetListToGetSize = [];

  Widget Function()? widgetToBuild;
  late Size screenSize;

  //호출순서 : super.initState->super.build->super.afterBuild->super.prepareRebuild
  //                                                       ->onLoad->mustRebuild->super.build

  void rebuild() {
    setState(() {});
  }

  @override
  void initState() {
    LogUtil.debug("super.initState");
    super.initState();

    widgetListToGetSize = makeWidgetListToGetSize();

    Future(afterBuild);
  }

  /*
  [
    WidgetToGetSize("maxContainer", maxContainerToGetSize)
  ];
  */
  List<WidgetToGetSize> makeWidgetListToGetSize();

  @override
  Widget build(BuildContext context) {
    LogUtil.debug("super.build");
    screenSize = MediaQueryUtil.getScreenSize(context);

    return widgetToBuild != null
        ? widgetToBuild!()
        : Stack(
            children: [
              ...(widgetListToGetSize.map((w) => w.makeWidget())),
              AppComponents.loadingWidget(),
            ],
          );
  }

  Future<void> afterBuild() async {
    LogUtil.debug("super.afterBuild");
    await prepareRebuild();
  }

  Future<void> prepareRebuild() async {
    LogUtil.debug("super.prepareRebuild");

    getSizeOfWidgetList();

    await onLoad();

    mustRebuild(context);
  }

  Future<void> onLoad();

  void mustRebuild(BuildContext context);

  Widget maxContainerToGetSize(GlobalKey key) {
    return Container(
      key: key,
      color: Colors.black,
    );
  }

  void getSizeOfWidgetList() {
    widgetListToGetSize.forEach((w) {
      w.calculateSize();
    });
  }
}
