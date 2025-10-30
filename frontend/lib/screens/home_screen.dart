import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/task_provider.dart';
import '../widgets/task_list_item.dart';
import 'add_task_screen.dart';
import '../services/preferences_service.dart';
import '../providers/settings_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showExpiredBannerPref = true;
  TaskFilter _filter = TaskFilter.all;

  @override
  void initState() {
    super.initState();
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    final value = await PreferencesService.getShowExpiredBanner();
    if (mounted) setState(() => _showExpiredBannerPref = value);
    // Load last filter
    final last = await PreferencesService.getLastFilter();
    if (mounted && last != null) {
      switch (last) {
        case 'active':
          _filter = TaskFilter.active;
          break;
        case 'completed':
          _filter = TaskFilter.completed;
          break;
        default:
          _filter = TaskFilter.all;
      }
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TaskProvider>();
    final tasks = provider.tasks;

    final hasExpired = tasks.any((t) => t.minutesUntilExpiration == 0);
    final showBanner = hasExpired && _showExpiredBannerPref;

    final filtered = switch (_filter) {
      TaskFilter.all => tasks,
      TaskFilter.active => tasks.where((t) => !t.isCompleted).toList(),
      TaskFilter.completed => tasks.where((t) => t.isCompleted).toList(),
    };

    final list = tasks.isEmpty
        ? const _EmptyState()
        : (filtered.isEmpty
            ? const _EmptyFilterState()
            : ListView.builder(
                itemCount: filtered.length,
                padding: const EdgeInsets.only(top: 8, bottom: 88),
                itemBuilder: (context, index) => TaskListItem(task: filtered[index]),
              ));

    return Scaffold(
      appBar: AppBar(
        title: const Text('TaskCloud'),
        actions: [
          // Connection status indicator
          if (provider.error != null)
            Tooltip(
              message: provider.error!,
              child: Icon(
                provider.isOnline ? Icons.cloud_done : Icons.cloud_off,
                color: provider.isOnline ? Colors.green : Colors.orange,
              ),
            ),
          const SizedBox(width: 8),
          _ThemeMenuButton(),
        ],
      ),
      body: SafeArea(
        child: Column(
        children: [
          if (showBanner)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Server removes items after ~1 hour. Your local copy stays until you delete it.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _showExpiredBannerPref = false;
                              });
                            },
                            child: const Text('Got it'),
                          ),
                          TextButton(
                            onPressed: () async {
                              await PreferencesService.setShowExpiredBanner(false);
                              if (mounted) setState(() => _showExpiredBannerPref = false);
                            },
                            child: const Text("Don't show again"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                _buildFilterChip(context, label: 'All', value: TaskFilter.all),
                const SizedBox(width: 8),
                _buildFilterChip(context, label: 'Active', value: TaskFilter.active),
                const SizedBox(width: 8),
                _buildFilterChip(context, label: 'Completed', value: TaskFilter.completed),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: list),
        ],
      ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => const AddTaskScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildFilterChip(BuildContext context, {required String label, required TaskFilter value}) {
    final selected = _filter == value;
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) {
        setState(() => _filter = value);
        // Persist last filter selection
        final key = switch (value) {
          TaskFilter.active => 'active',
          TaskFilter.completed => 'completed',
          _ => 'all',
        };
        PreferencesService.setLastFilter(key);
      },
    );
  }
}

enum TaskFilter { all, active, completed }

class _EmptyFilterState extends StatelessWidget {
  const _EmptyFilterState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text(
          'No tasks in this filter',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
        ),
      ),
    );
  }
}



class _EmptyState extends StatelessWidget {
  const _EmptyState();
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.task_alt_outlined, size: 48, color: Colors.grey),
          SizedBox(height: 12),
          Text('No tasks yet', style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
  }
}

class _ThemeMenuButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final mode = settings.themeMode;
    return PopupMenuButton<String>(
      tooltip: 'Theme',
      icon: const Icon(Icons.brightness_6_outlined),
      onSelected: (value) {
        final settings = context.read<SettingsProvider>();
        switch (value) {
          case 'system':
            settings.setThemeMode(ThemeMode.system);
            break;
          case 'light':
            settings.setThemeMode(ThemeMode.light);
            break;
          case 'dark':
            settings.setThemeMode(ThemeMode.dark);
            break;
        }
      },
      itemBuilder: (ctx) => [
        const PopupMenuItem<String>(
          enabled: false,
          child: Text(
            'Theme',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        const PopupMenuDivider(),
        CheckedPopupMenuItem<String>(
          value: 'system',
          checked: mode == ThemeMode.system,
          child: const Text('System'),
        ),
        CheckedPopupMenuItem<String>(
          value: 'light',
          checked: mode == ThemeMode.light,
          child: const Text('Light'),
        ),
        CheckedPopupMenuItem<String>(
          value: 'dark',
          checked: mode == ThemeMode.dark,
          child: const Text('Dark'),
        ),
      ],
    );
  }
}
