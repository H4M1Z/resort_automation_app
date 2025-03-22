// control_tab.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:resort_automation_app/pages/control_tab/widgets/stram.dart';
import 'package:resort_automation_app/pages/qr_scanning_page/controller/qr_scanning_controller.dart';
import 'package:resort_automation_app/utils/screen_meta_data.dart';

import 'widgets/sliver_header.dart'; // Custom Sliver header

class ControlTab extends ConsumerStatefulWidget {
  static const pageName = "/controlTab";
  const ControlTab({super.key});

  @override
  ConsumerState<ControlTab> createState() => _ControlTabState();
}

class _ControlTabState extends ConsumerState<ControlTab> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: CustomSliverDelegate(
                expandedHeight: ScreenMetaData.getHeight(context) * 0.20,
                controller: ref.read(qrScanningProvider.notifier),
              ),
            ),
            const SliverToBoxAdapter(
              child: DevicesStream(),
            )
          ],
        ),
      ),
    );
  }
}
