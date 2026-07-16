import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../domain/models/entity_kind.dart';

/// Creation dialog used from the dashboard FAB, list screens and the
/// command palette. Returns the new entity's id (and navigates to it).
Future<String?> showNewEntityDialog(
  BuildContext context,
  WidgetRef ref,
  String worldId, {
  EntityKind? initialKind,
}) async {
  final nameController = TextEditingController();
  var kind = initialKind ?? EntityKind.character;

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => StatefulBuilder(
      builder: (context, setState) => AlertDialog(
        title: const Text('New Entry'),
        content: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<EntityKind>(
                value: kind,
                decoration: const InputDecoration(labelText: 'Type'),
                items: [
                  for (final k in EntityKind.values)
                    DropdownMenuItem(
                      value: k,
                      child: Row(
                        children: [
                          Icon(k.icon, size: 17, color: k.color),
                          const SizedBox(width: 8),
                          Text(k.label),
                        ],
                      ),
                    ),
                ],
                onChanged: (value) =>
                    setState(() => kind = value ?? EntityKind.character),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: const InputDecoration(labelText: 'Name'),
                onSubmitted: (_) => Navigator.pop(context, true),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Create')),
        ],
      ),
    ),
  );

  final name = nameController.text.trim();
  if (confirmed != true || name.isEmpty) return null;

  final result = await ref
      .read(entityServiceProvider)
      .create(worldId: worldId, kind: kind, name: name);

  return result.fold(
    (entity) {
      if (context.mounted) {
        context.go(Routes.entity(worldId, entity.id));
      }
      return entity.id;
    },
    (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.userMessage)));
      }
      return null;
    },
  );
}
