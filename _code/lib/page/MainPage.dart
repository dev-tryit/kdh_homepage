import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:kdh_homepage/Setting.dart';
import 'package:kdh_homepage/_common/abstract/KDHState.dart';
import 'package:kdh_homepage/_common/model/WidgetToGetSize.dart';
import 'package:kdh_homepage/_common/util/AppComponents.dart';
import 'package:kdh_homepage/_common/util/LogUtil.dart';

enum MainPageWidget {
  maxContainer,
  headerText1,
  headerText2,
  mainListView,
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends KDHState<MainPage> {
  late Size maxSize;
  double containerWidth = 1024;
  ScrollController scrollController = ScrollController();

  //screenSize, w, widgetToBuild를 잘 사용해야 한다.
  //makeWidgetListToGetSize->onLoad->mustRebuild->super.build

  @override
  List<WidgetToGetSize> makeWidgetListToGetSize() {
    return [
      WidgetToGetSize(
        MainPageWidget.maxContainer,
        (key) => Container(
          key: key,
          color: Colors.transparent,
        ),
      ),
      WidgetToGetSize(
        MainPageWidget.headerText1,
        (key) => AppComponents.text(
          key: key,
          fontSize: 52,
          text: "${Setting.appBuildNumber}, Fullstack Developer, 김동현입니다.",
        ),
      ),
      WidgetToGetSize(
        MainPageWidget.headerText2,
        (key) => AppComponents.text(
          key: key,
          fontSize: 37,
          text: "플루터 웹, 앱을 제작합니다. 스타트업의 시작을 도와드리겠습니다.",
        ),
      ),
      WidgetToGetSize(
        MainPageWidget.mainListView,
        (key) => Container(
          color: Colors.amberAccent,
          height: 426,
          child: AppComponents.horizontalScroll(
              useWheelScrool: true,
              children:
                  List.generate(30, (index) => eachWorkCard("파섹홈페이지 $index"))),
        ),
      ),
    ];
  }

  @override
  Future<void> onLoad() async {
    LogUtil.debug("onLoad");
    maxSize = w[MainPageWidget.maxContainer]!.size;
  }

  @override
  void mustRebuild(BuildContext context) {
    LogUtil.debug("mustRebuild");

    widgetToBuild = () {
      if (screenSize.width > containerWidth) {
        return desktop(screenSize);
      }
      return mobile(screenSize);
    };
    rebuild();
  }

  Widget desktop(Size screenSize) {
    double sizableHeight = -1 +
        w[MainPageWidget.maxContainer]!.height -
        (43 +
            14 +
            200 +
            426 +
            w[MainPageWidget.headerText1]!.height +
            w[MainPageWidget.headerText2]!.height +
            w[MainPageWidget.mainListView]!.height);

    return AppComponents.webPage(
      screenSize: screenSize,
      containerWidth: containerWidth,
      widgetList: [
        const SizedBox(height: 43),
        w[MainPageWidget.headerText1]!.makeWidget(),
        const SizedBox(height: 14),
        w[MainPageWidget.headerText2]!.makeWidget(),
        SizedBox(height: sizableHeight),
        w[MainPageWidget.mainListView]!.makeWidget(),
        const SizedBox(height: 200),
      ],
    );
  }

  Widget mobile(Size screenSize) {
    return desktop(screenSize);
  }

  Widget eachWorkCard(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 27, right: 27),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network('https://picsum.photos/250?image=9'),
          const SizedBox(height: 22),
          AppComponents.text(text: title),
          AppComponents.text(text: "포토그래퍼 포트폴리오용 홈페이지"),
          const SizedBox(height: 16),
          AppComponents.text(text: "500,000원"),
        ],
      ),
    );
  }
}
