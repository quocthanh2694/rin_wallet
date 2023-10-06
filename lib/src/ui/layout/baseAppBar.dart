import 'package:flutter/material.dart';

// Widget baseAppBar(String title) {
//   return Text(title);
// }

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BaseAppBar(
      {super.key, @required this.title, this.bgColor, this.actions});

  final String? title;
  final Color? bgColor;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  // @override
  // Size get preferredSize => const Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        '${this.title}',
      ),
      backgroundColor: bgColor != null
          ? bgColor
          : Theme.of(context).colorScheme.inversePrimary,
      actions: actions != null ? actions : [],
    );
  }
}
