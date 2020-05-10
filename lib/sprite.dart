import 'package:flutter/material.dart';

class Sprite extends StatefulWidget {
  final double frameHeight;
  final double frameWidth;
  final double anim;
  final String img;
  final int frame;

  const Sprite({
    this.frameHeight,
    this.frameWidth,
    this.anim,
    this.img,
    this.frame,
  });

  @override
  _SpriteState createState() => _SpriteState();
}

class _SpriteState extends State<Sprite> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.frameWidth,
      height: widget.frameHeight,
      child: Stack(
        overflow: Overflow.clip,
        children: <Widget>[
          Positioned(
            top: 0,
            left: -widget.frameWidth * widget.anim,
            child: Container(
              width: widget.frameWidth * widget.frame,
              height: widget.frameHeight,
              decoration: widget.img != null
                  ? BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.img),
                        fit: BoxFit.fitWidth,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
