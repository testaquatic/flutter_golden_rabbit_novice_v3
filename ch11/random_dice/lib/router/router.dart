import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/root_screen.dart';
import 'package:random_dice/screen/settings_screen.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootScreen(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/",
              builder: (context, state) => Center(child: HomeScreen()),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: "/setting",
              builder: (context, state) => Center(child: SettingsScreen()),
            ),
          ],
        ),
      ],
    ),
  ],
);
