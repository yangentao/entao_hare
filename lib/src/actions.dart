part of '../entao_basic.dart';

class IconAcions {
  IconAcions._();

  static Widget refresh(VoidCallback onTap, {String? tooltip}) {
    return IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: onTap, tooltip: tooltip ?? "刷新");
  }

  static Widget add(VoidCallback onTap, {String? tooltip}) {
    return IconButton(icon: const Icon(Icons.add), onPressed: onTap, tooltip: tooltip ?? "新建");
  }

  static Widget delete(VoidCallback onTap, {String? tooltip}) {
    return IconButton(icon: const Icon(Icons.delete_forever_rounded), onPressed: onTap, tooltip: tooltip ?? "删除");
  }

  static Widget save(VoidCallback onTap, {String? tooltip}) {
    return IconButton(icon: const Icon(Icons.save_rounded), onPressed: onTap, tooltip: tooltip ?? "保存");
  }
}

Widget iconAction(Icon icon, VoidCallback onTap, {String? tooltip}) {
  return IconButton(icon: icon, onPressed: onTap, tooltip: tooltip);
}

Widget refreshAction(VoidCallback onTap, {String? tooltip}) {
  return IconButton(icon: const Icon(Icons.refresh_rounded), onPressed: onTap, tooltip: tooltip ?? "刷新");
}

Widget addAction(VoidCallback onTap, {String? tooltip}) {
  return IconButton(icon: const Icon(Icons.add), onPressed: onTap, tooltip: tooltip ?? "新建");
}

Widget deleteAction(VoidCallback onTap, {String? tooltip}) {
  return IconButton(icon: const Icon(Icons.delete_forever_rounded), onPressed: onTap, tooltip: tooltip ?? "删除");
}

Widget saveAction(VoidCallback onTap, {String? tooltip}) {
  return IconButton(icon: const Icon(Icons.save_rounded), onPressed: onTap, tooltip: tooltip ?? "保存");
}

Widget testAction(VoidCallback onTap, {String? tooltip}) {
  return IconButton(icon: const Icon(Icons.ac_unit_outlined), onPressed: onTap, tooltip: tooltip ?? " 测试");
}

Widget ExportChipAction(VoidCallback onPressed) {
  return ActionChip(
      label: "导出".text(),
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: globalTheme.textTheme.labelMedium?.color,
        child: Icons.download_rounded.icon(),
      ),
      onPressed: onPressed);
}

Widget RefreshChipAction(VoidCallback onPressed) {
  return ActionChip(
      label: "刷新".text(),
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: globalTheme.textTheme.labelMedium?.color,
        child: Icons.refresh_rounded.icon(),
      ),
      onPressed: onPressed);
}

Widget DeleteChipAction(VoidCallback onPressed) {
  return ActionChip(
      label: "删除".text(),
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: globalTheme.textTheme.labelMedium?.color,
        child: Icons.delete_forever.icon(),
      ),
      onPressed: onPressed);
}

Widget ChipAction(String label, Icon? icon, VoidCallback onPressed) {
  return ActionChip(
      label: label.text(),
      avatar: (icon == null
          ? null
          : CircleAvatar(
              backgroundColor: Colors.transparent,
              foregroundColor: globalTheme.textTheme.labelMedium?.color,
              child: icon,
            )),
      onPressed: onPressed);
}
