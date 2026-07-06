import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/task.dart';
import '../../models/energy_level.dart';
import '../auth/auth_repository.dart';
import 'task_repository.dart';
import 'hive_task_repository.dart';

class SyncedTaskRepository implements TaskRepository {
  final HiveTaskRepository _localRepository;
  final FirebaseFirestore _firestore;
  final AuthRepository _authRepository;

  SyncedTaskRepository(this._localRepository, this._firestore, this._authRepository);

  final Set<String> _dirtyTaskIds = {};
  Timer? _syncTimer;
  static const _syncDelay = Duration(seconds: 12);

  String? get _uid => _authRepository.currentUser?.uid;

  CollectionReference<Map<String, dynamic>>? get _remoteCollection {
    final uid = _uid;
    if (uid == null) return null;
    return _firestore.collection('users').doc(uid).collection('tasks');
  }

  void _markDirtyAndScheduleSync(String taskId) {
    _dirtyTaskIds.add(taskId);
    _syncTimer?.cancel();
    _syncTimer = Timer(_syncDelay, _flushToFirestore);
  }

  Future<void> _flushToFirestore() async {
    final collection = _remoteCollection;
    if (collection == null || _dirtyTaskIds.isEmpty) return;

    final idsToSync = Set<String>.from(_dirtyTaskIds);
    _dirtyTaskIds.clear();

    final batch = _firestore.batch();
    for (final id in idsToSync) {
      final task = _localRepository.getActiveTasks().firstWhere(
            (t) => t.id == id,
            orElse: () => _localRepository.getAllTasksIncludingDeleted().firstWhere((t) => t.id == id),
          );
      batch.set(collection.doc(id), task.toFirestoreMap());
    }

    try {
      await batch.commit();
    } catch (_) {
      // Sync failed (e.g. offline) — re-mark as dirty so the next
      // successful action retries these ids instead of losing them silently.
      _dirtyTaskIds.addAll(idsToSync);
    }
  }

  /// One-time pull on login — reconciles tasks that exist remotely
  /// but not yet locally (e.g. fresh install, second device).
  Future<void> pullFromRemote() async {
    final collection = _remoteCollection;
    if (collection == null) return;

    try {
      final snapshot = await collection.get();
      for (final doc in snapshot.docs) {
        final remoteTask = Task.fromFirestoreMap(doc.data());
        final localTasks = _localRepository.getAllTasksIncludingDeleted();
        final existsLocally = localTasks.any((t) => t.id == remoteTask.id);
        if (!existsLocally) {
          await _localRepository.addTask(remoteTask);
        }
      }
    } catch (_) {
      // No network on first login — local Hive box just stays empty
      // until the next successful pull; app remains fully usable offline.
    }
  }

  @override
  Future<void> addTask(Task task) async {
    await _localRepository.addTask(task);
    _markDirtyAndScheduleSync(task.id);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _localRepository.updateTask(task);
    _markDirtyAndScheduleSync(task.id);
  }

  @override
  Future<void> softDeleteTask(String id) async {
    await _localRepository.softDeleteTask(id);
    _markDirtyAndScheduleSync(id);
  }

  @override
  Future<void> restoreTask(String id) async {
    await _localRepository.restoreTask(id);
    _markDirtyAndScheduleSync(id);
  }

  @override
  Future<void> permanentlyDeleteTask(String id) async {
    await _localRepository.permanentlyDeleteTask(id);
    final collection = _remoteCollection;
    if (collection != null) {
      try {
        await collection.doc(id).delete();
      } catch (_) {
        // Best-effort — if offline, the remote doc just lingers;
        // acceptable since it's already gone from the user's active view.
      }
    }
  }

  @override
  List<Task> getActiveTasks() => _localRepository.getActiveTasks();

  @override
  List<Task> getTasksByEnergy(EnergyLevel level) => _localRepository.getTasksByEnergy(level);

  @override
  Task? getTopTask() => _localRepository.getTopTask();

  void dispose() {
    _syncTimer?.cancel();
  }
}