import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:selection_area_test/widgets/image_section_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class SelectionAreaWidget extends StatefulWidget {
  final Function(Offset position) onHoverUpdate;
  final Function() onHoverExit;
  final Function(String? link) onLinkHover;
  final Function(String? link) onLinkSelected;
  final Color backgroundColor;

  const SelectionAreaWidget({
    super.key,
    required this.onHoverUpdate,
    required this.onHoverExit,
    required this.onLinkHover,
    required this.onLinkSelected,
    required this.backgroundColor,
  });

  @override
  State<SelectionAreaWidget> createState() => _SelectionAreaWidgetState();
}

class _SelectionAreaWidgetState extends State<SelectionAreaWidget> {
  final FocusNode _focusNode = FocusNode();

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      focusNode: _focusNode,
      onSelectionChanged: (selection) {
        if (selection != null) {
          final urlRegExp = RegExp(
            r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
            caseSensitive: false,
          );
          final match = urlRegExp.firstMatch(selection.plainText);
          widget.onLinkSelected(match?.group(0));
        } else {
          widget.onLinkSelected(null);
        }
      },
      child: MouseRegion(
        onHover: (PointerHoverEvent event) {
          widget.onHoverUpdate(event.position);
        },
        onExit: (PointerExitEvent event) {
          widget.onHoverExit();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is a SelectionArea widget. It allows selecting text across multiple widgets.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(child: _buildContentColumn1()),
                const SizedBox(width: 20),
                Expanded(child: _buildContentColumn2()),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Image selection test:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            ImageSectionWidget(backgroundColor: widget.backgroundColor),
          ],
        ),
      ),
    );
  }

  Widget _buildContentColumn1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text block 1 for SelectionArea',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'This is a separate text element that contains a ',
          style: TextStyle(fontSize: 16),
        ),
        InkWell(
          onTap: () {
            launchUrl(Uri.parse('https://flutter.dev'));
          },
          onHover: (isHovering) {
            widget.onLinkHover(isHovering ? 'https://flutter.dev' : null);
          },
          child: const Text(
            'Flutter website link',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const Text(
          ' that you can hover over to see a preview.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Second column content
  Widget _buildContentColumn2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text block 2 for SelectionArea',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'This is another separate text element with a ',
          style: TextStyle(fontSize: 16),
        ),
        InkWell(
          onTap: () {
            launchUrl(Uri.parse('https://dart.dev'));
          },
          onHover: (isHovering) {
            widget.onLinkHover(isHovering ? 'https://dart.dev' : null);
          },
          child: const Text(
            'Dart website link',
            style: TextStyle(
              fontSize: 16,
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        const Text(
          '. Try selecting text across both columns.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }
}
