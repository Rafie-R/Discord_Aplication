import 'package:flutter/material.dart';
import '../models/message_model.dart';

class ReactionChip extends StatefulWidget {
  final EmojiReaction reaction;

  const ReactionChip({super.key, required this.reaction});

  @override
  State<ReactionChip> createState() => _ReactionChipState();
}

class _ReactionChipState extends State<ReactionChip> {
  @override
  Widget build(BuildContext context) {
    final isReacted = widget.reaction.isReacted;
    return InkWell(
      onTap: () {
        setState(() {
          if (widget.reaction.isReacted) {
            widget.reaction.isReacted = false;
            widget.reaction.count--;
          } else {
            widget.reaction.isReacted = true;
            widget.reaction.count++;
          }
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        margin: const EdgeInsets.only(right: 4, bottom: 4),
        decoration: BoxDecoration(
          color: isReacted
              ? const Color(0xFF5865F2).withValues(alpha: 0.15)
              : const Color(0xFFE3E5E8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isReacted
                ? const Color(0xFF5865F2)
                : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.reaction.emoji,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(width: 4),
            Text(
              '${widget.reaction.count}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: isReacted ? FontWeight.bold : FontWeight.w600,
                color: isReacted
                    ? const Color(0xFF5865F2)
                    : const Color(0xFF4F545C),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
