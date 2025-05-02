import 'package:flutter/material.dart';
import 'widgets/selection_area_widget.dart';
import 'widgets/selectable_text_widget.dart';
import 'widgets/selection_region_widget.dart';

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
      debugShowCheckedModeBanner: false,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      body: Stack(
        children: [
          // Main content
          SingleChildScrollView(
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
                    child: SelectionAreaWidget(
                      backgroundColor: Colors.blue.shade100,
                      onHoverUpdate: (position) {
                        setState(() {
                          _hoverPosition = position;
                        });
                      },
                      onHoverExit: () {
                        setState(() {
                          _hoverPosition = null;
                          _hoveredLink = null;
                        });
                      },
                      onLinkHover: (link) {
                        setState(() {
                          _hoveredLink = link;
                        });
                      },
                      onLinkSelected: (link) {
                        setState(() {
                          _selectedLink = link;
                          _isTextSelected = link != null;
                        });
                      },
                    ),
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
                    child: SelectableTextWidget(
                      backgroundColor: Colors.green.shade100,
                      onHoverUpdate: (position) {
                        setState(() {
                          _hoverPosition = position;
                        });
                      },
                      onHoverExit: () {
                        setState(() {
                          _hoverPosition = null;
                          _hoveredLink = null;
                        });
                      },
                      onLinkHover: (link) {
                        setState(() {
                          _hoveredLink = link;
                        });
                      },
                      onLinkSelected: (link) {
                        setState(() {
                          _selectedLink = link;
                          _isTextSelected = link != null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),

                  // SECTION 3: SelectionRegion
                  _buildSectionHeader(
                    'SelectionRegion',
                    Colors.orange.shade100,
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.orange.shade300),
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.orange.shade50,
                    ),
                    child: SelectionRegionWidget(
                      backgroundColor: Colors.orange.shade100,
                      onHoverUpdate: (position) {
                        setState(() {
                          _hoverPosition = position;
                        });
                      },
                      onHoverExit: () {
                        setState(() {
                          _hoverPosition = null;
                          _hoveredLink = null;
                        });
                      },
                      onLinkHover: (link) {
                        setState(() {
                          _hoveredLink = link;
                        });
                      },
                      onLinkSelected: (link) {
                        setState(() {
                          _selectedLink = link;
                          _isTextSelected = link != null;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Link preview popup - fixed at bottom right
          if (_hoveredLink != null || _selectedLink != null)
            Positioned(
              right: 20,
              bottom: 20,
              child: _buildLinkPreview(_hoveredLink ?? _selectedLink!),
            ),
        ],
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

  // Link preview card
  Widget _buildLinkPreview(String url) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(20),
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
            height: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Center(
              child: Icon(Icons.link, size: 50, color: Colors.grey[400]),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // In a real implementation, you would fetch the page title
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
                  // In a real implementation, you would fetch the page description
                  'This is a preview of the link content. In a real app, you would fetch and display metadata from the URL.',
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
    );
  }
}
