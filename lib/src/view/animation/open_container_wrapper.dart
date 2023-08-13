import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:very_supply_api_client/models/catalogue/menu_section_entry.dart';

import '../screen/menu_section_entry_detail_screen.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    Key? key,
    required this.child,
    required this.menuSectionEntry,
  }) : super(key: key);

  final Widget child;
  final MenuSectionEntry menuSectionEntry;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedColor: const Color(0xFFE5E6E8),
      transitionType: ContainerTransitionType.fade,
      transitionDuration: const Duration(milliseconds: 300),
      closedBuilder: (_, VoidCallback openContainer) {
        return InkWell(onTap: openContainer, child: child);
      },
      openBuilder: (_, __) => MenuSectionEntryDetailScreen(menuSectionEntry: menuSectionEntry),
    );
  }
}
