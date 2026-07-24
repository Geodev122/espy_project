import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../theme/espy_theme.dart';

class ActivityHeatmapOverlay extends StatelessWidget {
  final List<LatLng> hotspots;
  final String label;
  final Color color;

  const ActivityHeatmapOverlay({
    super.key, 
    required this.hotspots, 
    required this.label, 
    this.color = Colors.redAccent
  });

  @override
  Widget build(BuildContext context) {
    return CircleLayer(
      circles: hotspots.map((pos) => CircleMarker(
        point: pos,
        radius: 100, // Large radius for heatmap effect
        useRadiusInMeter: true,
        color: color.withValues(alpha: 0.15),
        borderStrokeWidth: 0,
      )).toList(),
    );
  }
}

class HeatmapControl extends StatelessWidget {
  final bool active;
  final VoidCallback onTap;
  final String label;

  const HeatmapControl({super.key, required this.active, required this.onTap, required this.label});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: active ? EspyTheme.navyDeep : Colors.white.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: EspyTheme.navyDeep.withValues(alpha: 0.1)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.waves_rounded, size: 14, color: active ? Colors.white : EspyTheme.navyDeep),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.montserrat(fontSize: 10, fontWeight: FontWeight.bold, color: active ? Colors.white : EspyTheme.navyDeep)),
          ],
        ),
      ),
    );
  }
}
