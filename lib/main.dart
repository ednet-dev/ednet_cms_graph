import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // Set up the SettingsController, which will glue user settings to multiple
  // Flutter Widgets.
  final settingsController = SettingsController(SettingsService());

  // Load the user's preferred theme while the splash screen is displayed.
  // This prevents a sudden theme change when the app is first displayed.
  await settingsController.loadSettings();

  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  runApp(MyApp(settingsController: settingsController));
}

import 'dart:math';
import 'package:flutter/material.dart';

class CMSCanvas extends StatelessWidget {
  final List<Node> nodes;
  final List<Edge> edges;

  CMSCanvas({
    this.nodes,
    this.edges,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CMSGraphPainter(nodes, edges),
      child: Container(),
    );
  }
}

class CMSGraphPainter extends CustomPainter {
  final List<Node> nodes;
  final List<Edge> edges;

  CMSGraphPainter(
      this.nodes,
      this.edges,
      );

  @override
  void paint(Canvas canvas, Size size) {
    // Render nodes and edges
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2;

    for (var i = 0; i < nodes.length; i++) {
      final angle = 2 * pi * i / nodes.length;
      final x = center.dx + radius * cos(angle);
      final y = center.dy + radius * sin(angle);
      final node = nodes[i];
      // Render node
      canvas.drawCircle(Offset(x, y), node.size, node.paint);
      // Render node label
      final textSpan = TextSpan(
        text: node.label,
        style: node.textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - textPainter.width / 2, y - textPainter.height / 2));
    }

    for (var edge in edges) {
      final sourceNode = nodes[nodes.indexWhere((node) => node.id == edge.source)];
      final targetNode = nodes[nodes.indexWhere((node) => node.id == edge.target)];
      final sourceX = center.dx + radius * cos(sourceNode.angle);
      final sourceY = center.dy + radius * sin(sourceNode.angle);
      final targetX = center.dx + radius * cos(targetNode.angle);
      final targetY = center.dx + radius * sin(targetNode.angle);
      // Render edge
      canvas.drawLine(Offset(sourceX, sourceY), Offset(targetX, targetY), edge.paint);
      // Render edge label
      final textSpan = TextSpan(
        text: edge.label,
        style: edge.textStyle,
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();
      final x = (sourceX + targetX) / 2;
      final y = (sourceY + targetY) /
