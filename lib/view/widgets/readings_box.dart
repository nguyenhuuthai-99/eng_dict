import 'package:eng_dict/view/screens/reading_screen.dart';
import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/material.dart';

class ReadingsBox extends StatelessWidget {
  const ReadingsBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text("Readings", style: Constant.kHeadingTextStyle,),
        Container(
          margin: const EdgeInsets.only(top: Constant.kMarginExtraSmall),
          child: GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ReadingScreen(),));
            },
            child: Stack(
              children: [
                AspectRatio(
                  aspectRatio: 2.2,
                  child: Container(
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(Constant.kMarginSmall)),
                        image: DecorationImage(
                            fit: BoxFit.fitWidth,
                            alignment: FractionalOffset(0,0.9),
                            image: AssetImage("assets/images/reading.jpg"))
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: Constant.kMarginSmall, left: Constant.kMarginLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Explore", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),),
                      Text("Stories and Articles", style: TextStyle(color: Colors.white, fontSize: 15, fontStyle: FontStyle.italic, fontWeight: FontWeight.w600),),

                    ],
                  ),
                ),

              ],
            ),
          ),
        )
      ],
    );
  }
}