import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool automaticallyImplyLeading;
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Color? backgroundColor;
  final double? elevation;
  final VoidCallback? onLeadingPressed;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actions,
    this.automaticallyImplyLeading = true,
    this.leading,
    this.bottom,
    this.backgroundColor,
    this.elevation,
    this.onLeadingPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      automaticallyImplyLeading: automaticallyImplyLeading,
      leading: leading ?? (automaticallyImplyLeading ? _buildLeadingButton(context) : null),
      actions: actions,
      bottom: bottom,
      backgroundColor: backgroundColor ?? Theme.of(context).appBarTheme.backgroundColor,
      elevation: elevation ?? 0,
      scrolledUnderElevation: 2,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black12,
    );
  }

  Widget? _buildLeadingButton(BuildContext context) {
    if (!Navigator.of(context).canPop()) {
      return null;
    }

    return IconButton(
      icon: const Icon(Icons.arrow_back_ios_new),
      onPressed: onLeadingPressed ?? () => Navigator.of(context).pop(),
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
    kToolbarHeight + (bottom?.preferredSize.height ?? 0.0)
  );
}

class AppBarActionButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? color;

  const AppBarActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      tooltip: tooltip,
      color: color ?? Theme.of(context).iconTheme.color,
    );
  }
}

class SearchAppBar extends AppBarWidget {
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmitted;
  final String searchHint;

  SearchAppBar({
    super.key,
    required super.title,
    this.searchController,
    this.onSearchChanged,
    this.onSearchSubmitted,
    this.searchHint = '검색',
    super.actions,
    super.automaticallyImplyLeading = true,
    PreferredSizeWidget? bottom,
  }) : super(
          bottom: bottom ?? _buildSearchBar(
            searchController,
            onSearchChanged,
            onSearchSubmitted,
            searchHint,
          ),
        );

  static PreferredSize _buildSearchBar(
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    VoidCallback? onSubmitted,
    String hint,
  ) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(56),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
        child: SearchBar(
          controller: controller,
          padding: const WidgetStatePropertyAll<EdgeInsets>(
            EdgeInsets.symmetric(horizontal: 16.0),
          ),
          onChanged: onChanged,
          onSubmitted: (_) => onSubmitted?.call(),
          leading: const Icon(Icons.search),
          hintText: hint,
        ),
      ),
    );
  }
}