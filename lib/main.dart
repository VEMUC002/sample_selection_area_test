import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Selection Widgets Comparison',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const SelectionComparisonDemo(),
    );
  }
}

class SelectionComparisonDemo extends StatefulWidget {
  const SelectionComparisonDemo({super.key});

  @override
  State<SelectionComparisonDemo> createState() =>
      _SelectionComparisonDemoState();
}

class _SelectionComparisonDemoState extends State<SelectionComparisonDemo> {
  // Track the current hover position and if we're showing a preview
  Offset? _hoverPosition;
  String? _hoveredLink;
  String? _selectedLink;
  bool _isTextSelected = false;

  // Focus nodes for each selection method
  final FocusNode _areaFocusNode = FocusNode();
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _regionFocusNode = FocusNode();

  @override
  void dispose() {
    _areaFocusNode.dispose();
    _textFocusNode.dispose();
    _regionFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Selection Widgets Comparison'),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: const Text('About this Demo'),
                        content: const SingleChildScrollView(
                          child: Text(
                            'This demo compares three Flutter selection widgets:\n\n'
                            '• SelectionArea: Enables text selection across multiple widgets\n'
                            '• SelectableText: Basic selectable text widget\n'
                            '• SelectionRegion: Custom selectable region implementation\n\n'
                            'Each section contains identical content for comparison.\n'
                            'Try selecting text across multiple elements, hovering over links, '
                            'and selecting images to compare behavior.',
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Close'),
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // SECTION 1: SelectionArea
                _buildSectionHeader('SelectionArea', Colors.blue.shade100),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue.shade50,
                  ),
                  child: _buildSelectionAreaSection(),
                ),
                const SizedBox(height: 32),

                // SECTION 2: SelectableText
                _buildSectionHeader('SelectableText', Colors.green.shade100),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.shade50,
                  ),
                  child: _buildSelectableTextSection(),
                ),
                const SizedBox(height: 32),

                // SECTION 3: SelectionRegion
                _buildSectionHeader('SelectionRegion', Colors.orange.shade100),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orange.shade300),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.orange.shade50,
                  ),
                  child: _buildSelectionRegionSection(),
                ),
              ],
            ),
          ),
        ),

        // Link preview popup
        floatingActionButton: _buildLinkPreviewPopup(),
      ),
    );
  }

  Widget _buildSectionHeader(String title, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  // SELECTION AREA SECTION
  Widget _buildSelectionAreaSection() {
    return SelectionArea(
      focusNode: _areaFocusNode,
      onSelectionChanged: (selection) {
        setState(() {
          _isTextSelected = selection != null;
          if (selection != null) {
            final urlRegExp = RegExp(
              r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
              caseSensitive: false,
            );
            final match = urlRegExp.firstMatch(selection.plainText);
            _selectedLink = match?.group(0);
          } else {
            _selectedLink = null;
          }
        });
      },
      child: MouseRegion(
        onHover: (PointerHoverEvent event) {
          setState(() {
            _hoverPosition = event.position;
          });
        },
        onExit: (PointerExitEvent event) {
          setState(() {
            _hoverPosition = null;
            _hoveredLink = null;
          });
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is a SelectionArea widget. It allows selecting text across multiple widgets.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Multiple text elements for testing cross-widget selection
            Row(
              children: [
                Expanded(child: _buildContentColumn1("SelectionArea")),
                const SizedBox(width: 20),
                Expanded(child: _buildContentColumn2("SelectionArea")),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Image selection test:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            _buildImageSection(Colors.blue.shade100),
          ],
        ),
      ),
    );
  }

  // SELECTABLE TEXT SECTION
  Widget _buildSelectableTextSection() {
    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        setState(() {
          _hoverPosition = event.position;
        });
      },
      onExit: (PointerExitEvent event) {
        setState(() {
          _hoverPosition = null;
          _hoveredLink = null;
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SelectableText(
            'This is a SelectableText widget. It allows selecting text only within a single text widget.',
            style: const TextStyle(fontSize: 16),
            focusNode: _textFocusNode,
            onSelectionChanged: (selection, cause) {
              setState(() {
                _isTextSelected =
                    selection.baseOffset != selection.extentOffset;
                if (_isTextSelected) {
                  final text =
                      'This is a SelectableText widget. It allows selecting text only within a single text widget.';
                  final selectedText = text.substring(
                    selection.baseOffset,
                    selection.extentOffset,
                  );

                  final urlRegExp = RegExp(
                    r'https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*)',
                    caseSensitive: false,
                  );
                  final match = urlRegExp.firstMatch(selectedText);
                  _selectedLink = match?.group(0);
                } else {
                  _selectedLink = null;
                }
              });
            },
          ),
          const SizedBox(height: 16),

          // Multiple text elements for testing selection limitations
          Row(
            children: [
              Expanded(child: _buildSelectableTextColumn1()),
              const SizedBox(width: 20),
              Expanded(child: _buildSelectableTextColumn2()),
            ],
          ),

          const SizedBox(height: 16),
          const Text('Image selection test:', style: TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          _buildImageSection(Colors.green.shade100),
        ],
      ),
    );
  }

  // SELECTION REGION SECTION
  Widget _buildSelectionRegionSection() {
    return MouseRegion(
      onHover: (PointerHoverEvent event) {
        setState(() {
          _hoverPosition = event.position;
        });
      },
      onExit: (PointerExitEvent event) {
        setState(() {
          _hoverPosition = null;
          _hoveredLink = null;
        });
      },
      child: SelectionArea(
        focusNode: _regionFocusNode,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'This is a SelectionRegion implementation. It provides a third way to handle text selection.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Multiple text elements for testing selection control
            Row(
              children: [
                Expanded(child: _buildSelectionRegionColumn1()),
                const SizedBox(width: 20),
                Expanded(child: _buildSelectionRegionColumn2()),
              ],
            ),

            const SizedBox(height: 16),
            const Text('Image selection test:', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            _buildImageSection(Colors.orange.shade100),
          ],
        ),
      ),
    );
  }

  // Image section with captions
  Widget _buildImageSection(Color bgColor) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: bgColor,
                ),
                child: const Icon(Icons.landscape, size: 80),
              ),
              const SizedBox(height: 8),
              const Text(
                'Nature landscape image with mountains and lakes',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: bgColor,
                ),
                child: const Icon(Icons.pets, size: 80),
              ),
              const SizedBox(height: 8),
              const Text(
                'Cute puppy playing in the grass on a sunny day',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Common content for first column
  Widget _buildContentColumn1(String sectionName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text block 1 for $sectionName',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            setState(() {
              _hoveredLink = isHovering ? 'https://flutter.dev' : null;
            });
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

  // Common content for second column
  Widget _buildContentColumn2(String sectionName) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Text block 2 for $sectionName',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
            setState(() {
              _hoveredLink = isHovering ? 'https://dart.dev' : null;
            });
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

  // SelectableText specific first column
  Widget _buildSelectableTextColumn1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text block 1 for SelectableText',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SelectableText(
          'This is a separate SelectableText that contains a ',
          style: const TextStyle(fontSize: 16),
        ),
        InkWell(
          onTap: () {
            launchUrl(Uri.parse('https://flutter.dev'));
          },
          onHover: (isHovering) {
            setState(() {
              _hoveredLink = isHovering ? 'https://flutter.dev' : null;
            });
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
        SelectableText(
          ' that you can hover over to see a preview.',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // SelectableText specific second column
  Widget _buildSelectableTextColumn2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text block 2 for SelectableText',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        SelectableText(
          'This is another SelectableText with a ',
          style: const TextStyle(fontSize: 16),
        ),
        InkWell(
          onTap: () {
            launchUrl(Uri.parse('https://dart.dev'));
          },
          onHover: (isHovering) {
            setState(() {
              _hoveredLink = isHovering ? 'https://dart.dev' : null;
            });
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
        SelectableText(
          '. Try selecting across widgets.',
          style: const TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // SelectionRegion specific first column
  Widget _buildSelectionRegionColumn1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text block 1 for SelectionRegion',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'This is a selectable text in SelectionRegion that contains a ',
          style: TextStyle(fontSize: 16),
        ),
        InkWell(
          onTap: () {
            launchUrl(Uri.parse('https://flutter.dev'));
          },
          onHover: (isHovering) {
            setState(() {
              _hoveredLink = isHovering ? 'https://flutter.dev' : null;
            });
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

  // SelectionRegion specific second column
  Widget _buildSelectionRegionColumn2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Text block 2 for SelectionRegion',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'This is another selectable text in SelectionRegion with a ',
          style: TextStyle(fontSize: 16),
        ),
        InkWell(
          onTap: () {
            launchUrl(Uri.parse('https://dart.dev'));
          },
          onHover: (isHovering) {
            setState(() {
              _hoveredLink = isHovering ? 'https://dart.dev' : null;
            });
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
          '. Try selecting across containers.',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Link preview popup that appears when hovering over links
  Widget? _buildLinkPreviewPopup() {
    if ((_hoveredLink != null || _selectedLink != null) &&
        (_hoverPosition != null || _isTextSelected)) {
      return Container(
        margin: const EdgeInsets.all(16),
        child: _buildLinkPreview(_hoveredLink ?? _selectedLink!),
      );
    }
    return null;
  }

  // Link preview card
  Widget _buildLinkPreview(String url) {
    return Positioned(
      left: _hoverPosition?.dx ?? (MediaQuery.of(context).size.width / 2 - 150),
      top: _hoverPosition?.dy ?? 300 + 20,
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              blurRadius: 10,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              child: Center(
                child: Icon(Icons.link, size: 40, color: Colors.grey[400]),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preview for: ${url.split('//').last}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This is a preview of the link content. In a real app, you would fetch metadata from the URL.',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    url,
                    style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
