import 'package:flutter/material.dart';

class RankingWidget extends StatelessWidget {
  final String title;
  final List<RankingItem> items;
  final bool showPeriodSelector;
  final ValueChanged<String>? onPeriodChanged;

  const RankingWidget({
    super.key,
    required this.title,
    required this.items,
    this.showPeriodSelector = true,
    this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              if (showPeriodSelector)
                DropdownButton<String>(
                  value: '이번 주',
                  items: ['이번 주', '이번 달', '전체']
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      onPeriodChanged?.call(newValue);
                    }
                  },
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final rank = index + 1;
              final isTopThree = rank <= 3;

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: _buildRankingBadge(context, rank),
                  title: Row(
                    children: [
                      if (item.profileImage != null)
                        CircleAvatar(
                          radius: 16,
                          backgroundImage: NetworkImage(item.profileImage!),
                        )
                      else
                        const CircleAvatar(
                          radius: 16,
                          child: Icon(Icons.person, size: 20),
                        ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.username,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Lv.${item.level}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${item.points} pt',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          if (item.pointDifference != 0)
                            Text(
                              item.pointDifference > 0
                                  ? '+${item.pointDifference}'
                                  : '${item.pointDifference}',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: item.pointDifference > 0
                                        ? Colors.green
                                        : Colors.red,
                                  ),
                            ),
                        ],
                      ),
                      if (isTopThree)
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.emoji_events,
                            color: _getTopRankColor(rank),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRankingBadge(BuildContext context, int rank) {
    final isTopThree = rank <= 3;
    final backgroundColor = isTopThree ? _getTopRankColor(rank) : Colors.grey[300];
    final textColor = isTopThree ? Colors.white : Colors.black87;

    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          rank.toString(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
        ),
      ),
    );
  }

  Color _getTopRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber;
      case 2:
        return Colors.grey[400]!;
      case 3:
        return Colors.brown[300]!;
      default:
        return Colors.grey[300]!;
    }
  }
}

class RankingItem {
  final String username;
  final int level;
  final int points;
  final int pointDifference;
  final String? profileImage;

  const RankingItem({
    required this.username,
    required this.level,
    required this.points,
    this.pointDifference = 0,
    this.profileImage,
  });
}