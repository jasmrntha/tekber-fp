import 'package:flutter/material.dart';
import 'package:final_project_2/screens/home_screen.dart';

class FirstGuide extends StatefulWidget {
  final List<GlobalKey> bottomnavbarkeys;
  FirstGuide({required this.bottomnavbarkeys});

  @override
  State<FirstGuide> createState() => _firstguide1();
}

class _firstguide1 extends State<FirstGuide> {
  int _indextobehighlighted = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          IgnorePointer(
            child: RepaintBoundary(
              child: HomeScreen(), 
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            right: 0,
            bottom: 0,
            child: Container(
              color: Colors.black.withOpacity(0.3), 
              child: Center(
                child: Container(
                  color:
                      Colors.transparent, 
                ),
              ),
            ),
          ),
          ...List.generate(
            widget.bottomnavbarkeys.length,
            (index) {
              RenderBox rendering = widget
                  .bottomnavbarkeys[index].currentContext
                  ?.findRenderObject() as RenderBox;
              Offset position =
                  rendering.localToGlobal(Offset.zero); 
              Size size = rendering.size;
              return Positioned(
                left: position.dx-14, 
                top: position.dy-1, 
                width: size.width+27, 
                height: size.height+22,
                child: Container(
                  decoration: BoxDecoration(
                    color: index == _indextobehighlighted ? Colors.white.withOpacity(0.8)
                        .withOpacity(0.5) : Colors.transparent, 
                    border: Border.all(
                      color: index == _indextobehighlighted ? Colors.white.withOpacity(0.8)
                        .withOpacity(0.5) : Colors.transparent, 
                      width: 2, 
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              );
            },
          ),
          Positioned(
            bottom: 30,
            left: 20,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _indextobehighlighted++; 
                });
                debugPrint('Jumlah klik: $_indextobehighlighted');
                if (_indextobehighlighted >= widget.bottomnavbarkeys.length) {
                  Navigator.pop(context);
                }
              },
              child: Text('Next Highlight'),
            ),
          ),
        ],
      ),
    );
  }
}