import 'package:appflowy_editor/appflowy_editor.dart';
import 'package:flutter/material.dart';

final List<CommandShortcutEvent> arrowUpKeys = [
  moveCursorUpCommand,
  moveCursorTopSelectCommand,
];

/// Arrow up key events.
///
/// - support
///   - desktop
///   - web
///

// arrow up key
// move the cursor backward one character
CommandShortcutEvent moveCursorUpCommand = CommandShortcutEvent(
  key: 'move the cursor upward',
  command: 'arrow up',
  handler: _moveCursorUpCommandHandler,
);

CommandShortcutEventHandler _moveCursorUpCommandHandler = (editorState) {
  if (PlatformExtension.isMobile) {
    assert(false, 'arrow up key is not supported on mobile platform.');
    return KeyEventResult.ignored;
  }

  final selection = editorState.selection;
  if (selection == null) {
    return KeyEventResult.ignored;
  }

  final upPosition = selection.end.moveVertical(editorState);
  editorState.updateSelectionWithReason(
    upPosition == null ? null : Selection.collapsed(upPosition),
    reason: SelectionUpdateReason.uiEvent,
  );

  return KeyEventResult.handled;
};

/// arrow up + shift + ctrl or cmd
/// cursor top select
CommandShortcutEvent moveCursorTopSelectCommand = CommandShortcutEvent(
  key: 'cursor top select', // TODO: rename it.
  command: 'ctrl+shift+arrow up',
  macOSCommand: 'cmd+shift+arrow up',
  handler: _moveCursorTopSelectCommandHandler,
);

CommandShortcutEventHandler _moveCursorTopSelectCommandHandler = (editorState) {
  final selection = editorState.selection;
  if (selection == null) {
    return KeyEventResult.ignored;
  }
  final selectable = editorState.document.root.children
      .firstWhereOrNull((element) => element.selectable != null)
      ?.selectable;
  if (selectable == null) {
    return KeyEventResult.ignored;
  }
  final end = selectable.start();
  editorState.updateSelectionWithReason(
    selection.copyWith(end: end),
    reason: SelectionUpdateReason.uiEvent,
  );
  return KeyEventResult.handled;
};
