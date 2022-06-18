import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sleeplearning/StartPage.dart';

import 'Strings.dart';
//80% of screen width

List<String> imgList = ["Assets/donotdisturb.png", "Assets/speaker.png"];
List<String> text = [
  StringsConstant.instructions,
  StringsConstant.headphoneInstruction
];

class InstructionPage extends StatefulWidget {
  @override
  State<InstructionPage> createState() => _InstructionPageState();
}

class _InstructionPageState extends State<InstructionPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final List<Widget> imageSliders = imgList
        .map((item) => SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                          text[imgList.indexOf(item)],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25, color: Colors.white70),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.width * 0.6,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Image.asset(item),
                    ),
                  ]),
            ))
        .toList();
    return Scaffold(
      backgroundColor: Colors.black,
      body: true
          ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              CarouselSlider(
                items: imageSliders,
                carouselController: _controller,
                options: CarouselOptions(
                    autoPlay: false,
                    enlargeCenterPage: true,
                    enableInfiniteScroll: false,
                    height: MediaQuery.of(context).size.height * 0.8,
                    //  aspectRatio: 2.0,
                    onPageChanged: (index, reason) {
                      setState(() {
                        _current = index;
                      });
                    }),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: imgList.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _controller.animateToPage(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: (Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.blue
                                  : Colors.blue)
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(
                height: 10,
              ),
              _current == imageSliders.length - 1
                  ? SizedBox(
                      height: 25,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => StartPage(),
                            ),
                          );
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.black),
                        ),
                        child: Text(
                          StringsConstant.Continue,
                          style: TextStyle(fontSize: 25, color: Colors.white70),
                        ),
                      ),
                    )
                  : SizedBox(
                      height: 25,
                    )
            ])
          : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 100),
                child: Text(
                  StringsConstant.instructions,
                  style: TextStyle(fontSize: 25, color: Colors.white70),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Image.asset('Assets/donotdisturb.png'),
              SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => StartPage(),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.black),
                ),
                child: Text(
                  StringsConstant.Continue,
                  style: TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ]),
    );
  }
}
