import 'dart:math';

import 'package:flutter/material.dart';
import 'package:animator/controllers/theme_controller.dart';
import 'package:provider/provider.dart';

import '../../controllers/planet_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int currentIndex = 0;

  late AnimationController animationController;

  late Animation rotate;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();

    rotate = Tween(begin: 0.0, end: pi * 2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    dynamic pf = Provider.of<PlanetController>(context, listen: false);
    dynamic pt = Provider.of<PlanetController>(context);
    dynamic themePro = Provider.of<ThemeController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Our planets",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: themePro.isLight ? Colors.black : Colors.black,
        leading: IconButton(
          onPressed: () {
            setState(() {
              Navigator.of(context).pushNamed(
                'detail_page',
                arguments: pt.allPlanets[currentIndex],
              );
            });
          },
          icon: const Icon(Icons.arrow_forward_ios),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                themePro.isLight = !themePro.isLight;
              });
            },
            icon: Icon(
              themePro.isLight ? Icons.dark_mode : Icons.light_mode,
            ),
            color: Colors.white,
          ),
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.75),
                  BlendMode.darken,
                ),
                image: themePro!.isLight
                    ? const AssetImage('assets/images/bg2.jpg')
                    : const AssetImage('assets/images/bg1.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: const Alignment(0.5, 0.8),
            child: AnimatedDefaultTextStyle(
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
              duration: const Duration(milliseconds: 350),
              child: Text(
                pf.allPlanets[currentIndex]['name'],
              ),
            ),
          ),
          AnimatedDefaultTextStyle(
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
            duration: Duration(milliseconds: 350),
            child: Text(
              "                    Discover your planet",
              style: TextStyle(color: Colors.white70),
            ),
          ),
          ListWheelScrollView.useDelegate(
            itemExtent: 200,
            physics: const FixedExtentScrollPhysics(),
            offAxisFraction: 0.0,
            onSelectedItemChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            squeeze: 0.68,
            childDelegate: ListWheelChildBuilderDelegate(
              childCount: pt.allPlanets.length,
              builder: (context, index) => AnimatedBuilder(
                  animation: animationController,
                  builder: (context, child) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          Navigator.of(context).pushNamed('detail_page',
                              arguments: pf.allPlanets[index]);
                        });
                      },
                      child: Transform.rotate(
                        angle: rotate.value,
                        child: Hero(
                          tag: pt.allPlanets[index]['name'],
                          child: Image.asset(
                            pt.allPlanets[index]['image'],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
