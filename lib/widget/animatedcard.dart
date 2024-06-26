import 'package:bytes/model/model.dart'; // Import the Product class from model.dart
import 'package:flutter/material.dart';
import 'package:flutter_tilt/flutter_tilt.dart';

class AnimationCard extends StatefulWidget {
  final Product product; // Use the Product class from model.dart
  const AnimationCard({Key? key, required this.product}) : super(key: key);

  @override
  State<AnimationCard> createState() => _AnimationCardState();
}

class _AnimationCardState extends State<AnimationCard>
    with SingleTickerProviderStateMixin {
  late AnimationController scaleAnimationController;
  late Animation<double> scaleAnimation;
  double opacity = 0;
  bool isHover = false;

  @override
  void initState() {
    super.initState();
    scaleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
      reverseDuration: const Duration(milliseconds: 1000),
    );
    scaleAnimation = Tween(begin: 1.2, end: 1.26).animate(
      CurvedAnimation(
        parent: scaleAnimationController,
        curve: const Cubic(0.16, 1, 0.3, 1),
        reverseCurve: Curves.easeInCirc,
      ),
    );
    scaleAnimationController.addListener(() {
      switch (scaleAnimationController.status) {
        case AnimationStatus.forward:
          if (opacity == 1) return;
          setState(() => opacity = 1);
          break;
        case AnimationStatus.reverse:
          if (opacity == 0) return;
          setState(() => opacity = 0);
          break;
        case AnimationStatus.dismissed:
        case AnimationStatus.completed:
      }
    });
  }

  @override
  void dispose() {
    scaleAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) {
        if (isHover) return;
        scaleAnimationController.forward();
      },
      onPointerUp: (_) {
        if (isHover) return;
        scaleAnimationController.reverse();
      },
      onPointerCancel: (_) {
        if (isHover) return;
        scaleAnimationController.reverse();
      },
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) {
          isHover = true;
          scaleAnimationController.forward();
        },
        onExit: (_) {
          isHover = true;
          scaleAnimationController.reverse();
        },
       
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Tilt(
            borderRadius: BorderRadius.circular(18),
            tiltConfig: const TiltConfig(
              angle: 6.0,
              enableReverse: true,
              enableOutsideAreaMove: false,
              leaveDuration: Duration(milliseconds: 400),
              filterQuality: FilterQuality.high,
            ),
            lightConfig: const LightConfig(disable: true),
            shadowConfig: const ShadowConfig(enableReverse: true),
            childLayout: ChildLayout(
              inner: [
                ScaleTransition(
                  scale: scaleAnimation,
                  alignment: Alignment.center,
                  filterQuality: FilterQuality.high,
                  child: TiltParallax(
                    child: FadeInImage(
                      placeholder:const AssetImage("assets/images/loading.gif"),
                       image:  NetworkImage(widget.product.imageUrl),   
                      filterQuality: FilterQuality.high,
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.7,
                       )
                  ),
                ),
                Positioned.fill(
                  child: AnimatedOpacity(
                    opacity: opacity,
                    duration: const Duration(milliseconds: 600),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black12, Colors.black87],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 28,
                          vertical: 20,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '₹ ${widget.product.price.toString()}',  
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                widget.product.type,
                                style: const TextStyle(
                                  color: Colors.white60,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            child: const SizedBox(),
          ),
        ),
      ),
    );
  }
}
