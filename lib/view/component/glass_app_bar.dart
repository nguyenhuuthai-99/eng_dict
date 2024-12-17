import 'dart:ui';

import 'package:flutter/material.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  late final AppBar appBar;
  GlassAppBar({required this.title, super.key}) {
    appBar = AppBar(
      title: Text(title),
      backgroundColor: Colors.white.withOpacity(0.6),
      surfaceTintColor: Colors.white.withOpacity(0.6),
    );
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return PreferredSize(
      child: ClipRRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 25, sigmaY: 25, tileMode: TileMode.mirror),
              child: appBar)),
      preferredSize:
          Size(MediaQuery.of(context).size.width, appBar.preferredSize.height),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
