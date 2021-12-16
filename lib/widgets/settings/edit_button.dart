import 'package:flutter/material.dart';
import 'package:stronger/views/setting/tool_edit_view.dart';
import 'package:stronger/widgets/common/common_card.dart';

class EditButton extends StatelessWidget {
  const EditButton({
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: CommonCard(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.black,
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_outlined,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
