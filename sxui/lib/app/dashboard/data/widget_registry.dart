// lib/app/dashboard/data/widget_registry.dart
import 'package:flutter/material.dart';
import 'package:sxui/app/dashboard/models/widget_kind.dart';
import 'package:sxui/app/features/billing/billing.dart';
import 'package:sxui/app/features/salesSummary/salesSum.dart';
import 'package:sxui/app/features/search/search.dart';
import 'package:sxui/app/features/integrations/integrations.dart';
import 'package:sxui/app/features/calendar/calendar.dart';
import 'package:sxui/app/features/log/log.dart';
import 'package:sxui/app/features/drivers/driver.dart' show DriverWidget;

/// Signature each catalog entry uses to build a widget tile:
/// builder(ctx, instanceId) => Widget
typedef WidgetBuilderWithId = Widget Function(BuildContext, String);

class WidgetOption {
  final WidgetKind kind;
  final IconData icon;
  final String label;
  final WidgetBuilderWithId builder;

  const WidgetOption({
    required this.kind,
    required this.icon,
    required this.label,
    required this.builder,
  });
}

/// Build the picker catalog. We pass [logMessages] to widgets that need it.
List<WidgetOption> buildWidgetOptions(
  ValueNotifier<List<Map<String, dynamic>>> logMessages,
) {
  return <WidgetOption>[
    // Driver — you also handle name prompting in DashboardPage before add.
    WidgetOption(
      kind: WidgetKind.driver,
      icon: Icons.local_shipping,
      label: 'Driver',
      builder: (ctx, id) => DriverWidget(
        driverId: id,
        initialName: null, // DashboardPage can override with provided name
        logMessages: logMessages,
      ),
    ),

    WidgetOption(
      kind: WidgetKind.calendar,
      icon: Icons.calendar_today,
      label: 'Calendar',
      builder: (ctx, _) => Calendar(logMessages: logMessages),
    ),

    WidgetOption(
      kind: WidgetKind.billing,
      icon: Icons.receipt_long,
      label: 'Billing',
      builder: (ctx, _) => const Billing(),
    ),

    WidgetOption(
      kind: WidgetKind.salesSummary,
      icon: Icons.bar_chart,
      label: 'Sales Summary',
      builder: (ctx, _) => const SalesSum(),
    ),

    WidgetOption(
      kind: WidgetKind.search,
      icon: Icons.search,
      label: 'Search',
      builder: (ctx, _) => const Search(),
    ),

    WidgetOption(
      kind: WidgetKind.log,
      icon: Icons.list_alt,
      label: 'Log',
      builder: (ctx, _) => Log(logMessages: logMessages),
    ),

    WidgetOption(
      kind: WidgetKind.integrations,
      icon: Icons.hub,
      label: 'Integrations',
      builder: (ctx, _) => Integrations(),
    ),
  ];
}
