import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:tesla_car/sprite.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TeslaCar(),
    );
  }
}

Color greyDark = Color(0xff383B49);
Color greyMedium = Color(0xff4B4D5B);
Color greyLight = Color(0xff6D707C);
Color lighTitle = Color(0xff797C89);

class TeslaCar extends StatefulWidget {
  @override
  _TeslaCarState createState() => _TeslaCarState();
}

class _TeslaCarState extends State<TeslaCar> with TickerProviderStateMixin {
  AnimationController _controller;
  AnimationController _switchCtrl;
  Animation<int> anim;

  double get w => MediaQuery.of(context).size.width;
  double get h => MediaQuery.of(context).size.height;

  double chx = 0;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 600))
          ..addListener(() {
            setState(() {});
          });
    _switchCtrl =
        AnimationController(vsync: this, duration: Duration(milliseconds: 6000))
          ..addListener(() {
            setState(() {});
          });
    anim = StepTween(begin: 0, end: 49).animate(_switchCtrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: greyDark,
      body: GestureDetector(
        onHorizontalDragUpdate: _onHorizontalDragUpdate,
        onHorizontalDragEnd: _onHorizontalDragEnd,
        behavior: HitTestBehavior.translucent,
        child: Container(
          width: w,
          height: h,
          child: Stack(
            children: [
              TopLayout(
                ctrl: _controller.value,
              ),
              TopLayoutBg(
                ctrl: _controller.value,
                onTap: _toggle,
              ),
              RightLayout(
                ctrl: _controller.value,
              ),
              Positioned(
                top: h * 0.11 + h * 0.07 * (1 - _controller.value) + 20,
                left: -w * 0.43 * (1 - _controller.value),
                child: Container(
                  width: w,
                  height: h - (h * 0.3 + 20),
                  child: Stack(
                    children: [
                      Container(
                        width: w,
                        height: h - (h * 0.3 + 20),
                        padding:
                            EdgeInsets.all(52 + 10 * (1 - _controller.value)),
                        child: Image.asset("assets/images/tesla.png"),
                      ),
                      ...List.generate(doorLocks.length, (index) {
                        return DoorLock(
                          isLeft:
                              index == doorLocks[0] || index == doorLocks[1],
                          isTop: index == doorLocks[0] || index == doorLocks[2],
                          ctrl: _controller.value,
                        );
                      }),
                    ],
                  ),
                ),
              ),
              BottomLayout(
                ctrl: _controller.value,
              ),
              SwitchButton(
                ctrl: _controller.value,
                anim: anim.value.toDouble(),
                chx: chx,
                onTap: () {
                  if (_switchCtrl.isAnimating) {
                    _switchCtrl.reset();
                    setState(() {
                      chx = 0;
                    });
                  } else {
                    _switchCtrl.repeat();
                    setState(() {
                      chx = 1;
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onHorizontalDragUpdate(DragUpdateDetails details) {
    _controller.value += details.primaryDelta / w;
  }

  void _onHorizontalDragEnd(DragEndDetails details) {
    if (_controller.isAnimating ||
        _controller.status == AnimationStatus.completed) return;

    _controller.fling(velocity: _controller.value < 0.5 ? -1.0 : 1.0);
  }

  void _toggle() {
    final bool isOpen = _controller.status == AnimationStatus.completed;

    _controller.fling(velocity: isOpen ? -1 : 1);
  }
}

List<int> doorLocks = [0, 1, 2, 3];

class DoorLock extends StatelessWidget {
  final double top;
  final double left;
  final double angle;
  final CustomPainter painter;
  final bool isLeft;
  final bool isTop;
  final double ctrl;

  const DoorLock({
    Key key,
    this.top,
    this.left,
    this.angle,
    this.painter,
    this.isLeft,
    this.isTop,
    this.ctrl,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Positioned(
      top: isTop ? w * 0.5 : w * 0.8,
      left: isLeft ? w * 0.05 : w - (w * 0.24),
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl > 0.8 ? 1 : 0,
        child: Container(
          width: w * 0.2,
          height: 80,
          child: Stack(
            children: [
              isLeft
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/lock.png",
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: lighTitle,
                          ),
                        ),
                        Transform.rotate(
                          angle: 0,
                          child: CustomPaint(
                            foregroundPainter: Painter1(),
                            child: Container(
                              width: (w * 0.2) - 44,
                              height: 80,
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Transform.rotate(
                          angle: 0,
                          child: CustomPaint(
                            foregroundPainter:
                                isLeft && isTop ? Painter1() : Painter2(),
                            child: Container(
                              width: (w * 0.2) - 44,
                              height: 80,
                            ),
                          ),
                        ),
                        Container(
                          width: 44,
                          height: 44,
                          padding: EdgeInsets.all(10),
                          child: Image.asset(
                            "assets/images/lock.png",
                            color: Colors.white,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: lighTitle,
                          ),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

class Painter1 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lighTitle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path()
      ..moveTo(0, size.height * 0.25)
      ..lineTo(size.width * 0.35, size.height * 0.25)
      ..lineTo(size.width - 2, size.height * 0.75)
      ..moveTo(size.width, size.height)
      ..moveTo(0, size.height)
      ..moveTo(0, size.height * 0.25)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Painter1 oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Painter1 oldDelegate) => false;
}

class Painter2 extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = lighTitle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    Path path = Path()
      ..moveTo(size.width, size.height * 0.25)
      ..lineTo(size.width * 0.65, size.height * 0.25)
      ..lineTo(2, size.height * 0.75)
      ..moveTo(0, size.height)
      ..moveTo(size.width, size.height)
      ..moveTo(size.width, size.height * 0.25)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(Painter2 oldDelegate) => false;

  @override
  bool shouldRebuildSemantics(Painter2 oldDelegate) => false;
}

class SwitchButton extends StatelessWidget {
  final double ctrl;
  final double anim;
  final Function onTap;
  final double chx;

  const SwitchButton({Key key, this.ctrl, this.anim, this.onTap, this.chx})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Positioned(
      bottom: -(w * 0.33 + 24) * (1 - ctrl) + 24,
      left: (w - w * 0.33) / 2,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl < 0.8 ? 0 : 1,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: w * 0.33,
            height: w * 0.33,
            child: Stack(
              children: [
                AnimatedPositioned(
                  duration: Duration(milliseconds: 240),
                  top: (w * 0.33 - 12) / 2 * (1 - chx),
                  left: 0,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: (1 - chx),
                    child: Container(
                      width: w * 0.33,
                      child: Text(
                        "Start Engine",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.purple[50],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                AnimatedPositioned(
                  duration: Duration(milliseconds: 240),
                  bottom: (w * 0.33 - 18) / 2 * chx,
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: chx,
                    child: Container(
                      width: w * 0.33,
                      child: Text(
                        "Switch Off",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.lightGreen[100],
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
                Sprite(
                  frameWidth: w * 0.33,
                  frameHeight: w * 0.33,
                  frame: 50,
                  anim: anim,
                  img: "assets/images/switch.png",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TopLayoutBg extends StatelessWidget {
  final double ctrl;
  final Function onTap;

  const TopLayoutBg({Key key, this.ctrl, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      top: -h * 0.13 * (1 - ctrl),
      left: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl < 0.8 ? 0 : 1,
        child: Container(
          width: w,
          height: h * 0.13,
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(left: 24, right: 24, top: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: onTap,
                child: Container(
                  width: 36,
                  height: 36,
                  child: Icon(
                    Icons.arrow_back_ios,
                    size: 20,
                    color: greyLight,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: greyMedium,
                      width: 2,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(),
                  Text(
                    "Your Model X",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Parked",
                    style: TextStyle(
                      color: greyLight,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                width: 36,
                height: 36,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RightLayout extends StatelessWidget {
  final double ctrl;

  const RightLayout({Key key, this.ctrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      top: (h * 0.18 + 20),
      right: -w * ctrl,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl > 0.2 ? 0 : 1,
        child: Container(
          width: w * 0.64,
          height: h - (h * 0.3 + 20),
          alignment: Alignment.center,
          child: Wrap(
            spacing: w * 0.06,
            runSpacing: w * 0.06,
            children: wrapItems.map((e) {
              return Container(
                width: w * 0.25,
                height: h * 0.15,
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        e.icn,
                        color: Colors.white,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: e.icnColor,
                      ),
                    ),
                    Spacer(),
                    Text(
                      e.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                decoration: BoxDecoration(
                  color: greyMedium,
                  borderRadius: BorderRadius.circular(16),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

class BottomLayout extends StatelessWidget {
  final double ctrl;

  const BottomLayout({Key key, this.ctrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      left: 0,
      bottom: -h * 0.12 * ctrl,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl > 0.2 ? 0 : 1,
        child: Container(
          width: w,
          height: h * 0.12,
          padding: EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            color: greyMedium,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/images/fan.png",
                  color: greyLight,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: greyMedium,
                  border: Border.all(
                    color: greyLight,
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/images/power.png",
                  color: greyLight,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: greyMedium,
                  border: Border.all(
                    color: greyLight,
                    width: 2,
                  ),
                ),
              ),
              Container(
                width: 50,
                height: 50,
                padding: EdgeInsets.all(12),
                child: Image.asset(
                  "assets/images/lock.png",
                  color: Colors.white,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: greyLight,
                  border: Border.all(
                    color: greyLight,
                    width: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class RowItem extends StatelessWidget {
  final String title;
  final String subtitle;

  const RowItem({Key key, this.title, this.subtitle}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 6),
        Text(
          subtitle,
          style: TextStyle(
            color: lighTitle,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class TopLayout extends StatelessWidget {
  final double ctrl;

  const TopLayout({Key key, this.ctrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Positioned(
      top: 20 + -h * 0.18 * ctrl,
      left: 0,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: 240),
        opacity: ctrl > 0.2 ? 0 : 1,
        child: Container(
          width: w,
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          height: h * 0.18,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/images/tesla_logo.png",
                    height: 24,
                  ),
                  SizedBox(width: 10),
                  Text(
                    "Your Model X",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.notifications,
                    size: 26,
                    color: lighTitle,
                  ),
                ],
              ),
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: TextStyle(),
                  children: [
                    TextSpan(
                      text: "Parked  ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    TextSpan(
                      text: "888 Boston City - Boston",
                      style: TextStyle(
                        color: lighTitle,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Divider(
                height: 3,
                color: lighTitle,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  RowItem(title: "150 mi", subtitle: "Range"),
                  RowItem(title: "80%", subtitle: "Charge"),
                  RowItem(title: "64º F", subtitle: "Temp"),
                  RowItem(title: "0 mph", subtitle: "Speed"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WrapModel {
  final Color icnColor;
  final String icn;
  final String title;

  WrapModel(this.icnColor, this.icn, this.title);
}

List<WrapModel> wrapItems = [
  WrapModel(Color(0xff7670EE), "assets/images/play.png", "Media"),
  WrapModel(Color(0xff2EAEFB), "assets/images/thermometer.png", "Climate"),
  WrapModel(Color(0xffFE7C00), "assets/images/compass.png", "Location"),
  WrapModel(Color(0xff26D670), "assets/images/technology.png", "Charging"),
  WrapModel(Color(0xffF9262C), "assets/images/transportation.png", "Controls"),
  WrapModel(Color(0xff1CD6B2), "assets/images/sports.png", "Summon"),
];
