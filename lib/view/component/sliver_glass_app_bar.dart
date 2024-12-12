import 'dart:ui';

import 'package:eng_dict/view/component/glass_app_bar.dart';
import 'package:eng_dict/view/component/search_bar.dart';
import 'package:flutter/material.dart';

class SliverGlassAppBar extends StatelessWidget{
  const SliverGlassAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return const SliverAppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      title: Text("Dictionary"),
    );
  }
}
