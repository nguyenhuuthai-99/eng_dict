import 'dart:ui';

import 'package:eng_dict/view/utils/constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GlassAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  late final AppBar appBar;
  GlassAppBar({required this.title, super.key}) {
    appBar = AppBar(
      title: Text(title),
      backgroundColor: Colors.white.withAlpha(100),
      surfaceTintColor: Colors.white.withAlpha(100),
    );
  }

  @override
  PreferredSizeWidget build(BuildContext context) {
    return PreferredSize(
      preferredSize:
          Size(MediaQuery.of(context).size.width, appBar.preferredSize.height),
      child: ClipRRect(
          child: BackdropFilter(
              filter: ImageFilter.blur(
                  sigmaX: 25, sigmaY: 25, tileMode: TileMode.clamp),
              child: appBar)),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class DarkModeButton extends StatefulWidget {
  const DarkModeButton({super.key});

  @override
  State<DarkModeButton> createState() => _DarkModeButtonState();
}

class _DarkModeButtonState extends State<DarkModeButton> {
  bool isDarkMode = true;
  Icon darkModeIcon = const Icon(
    color: Colors.black87,
    Icons.brightness_4,
    size: 25,
  );
  Icon brightModeIcon = const Icon(
    color: Colors.grey,
    Icons.brightness_7,
    size: 25,
  );
  late Icon selectedIcon;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedIcon = darkModeIcon;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: selectedIcon,
      onTap: () {
        setState(() {
          if (selectedIcon == darkModeIcon) {
            selectedIcon = brightModeIcon;
          } else {
            selectedIcon = darkModeIcon;
          }
        });
      },
    );
  }
}
