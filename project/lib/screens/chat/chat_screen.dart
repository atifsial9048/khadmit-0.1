import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/extensions/context_extensions.dart';
import '../../models/message_model.dart';

class ChatScreen extends StatefulWidget {
  final String currentUserId;
  final String otherUserId;
  final String otherUserName;

  const ChatScreen({
    super.key,
    required this.currentUserId,
    required this.otherUserId,
    required this.otherUserName,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _msgCtrl = TextEditingController();
  final _scrollCtrl = ScrollController();
  bool _isOtherTyping = false;
  Timer? _typingTimer;

  final List<MessageModel> _messages = [
    MessageModel(
      id: 'm1',
      senderId: 'other',
      receiverId: 'me',
      text: 'Asalamu Alaikum, kya hal hai?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 10)),
      isRead: true,
      isDelivered: true,
    ),
    MessageModel(
      id: 'm2',
      senderId: 'me',
      receiverId: 'other',
      text: 'Walaikum Asalam! Main theek hoon. Aap ka service kab available hai?',
      timestamp: DateTime.now().subtract(const Duration(minutes: 8)),
      isRead: true,
      isDelivered: true,
    ),
    MessageModel(
      id: 'm3',
      senderId: 'other',
      receiverId: 'me',
      text: 'Aaj shaam 5 baje se available hoon. Rs. 800 per hour hoga.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
      isRead: true,
      isDelivered: true,
    ),
    MessageModel(
      id: 'm4',
      senderId: 'me',
      receiverId: 'other',
      text: 'Theek hai, booking confirm karta hoon.',
      timestamp: DateTime.now().subtract(const Duration(minutes: 2)),
      isRead: false,
      isDelivered: true,
    ),
  ];

  @override
  void dispose() {
    _msgCtrl.dispose();
    _scrollCtrl.dispose();
    _typingTimer?.cancel();
    super.dispose();
  }

  void _sendMessage() {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(MessageModel(
        id: 'm${_messages.length + 1}',
        senderId: widget.currentUserId,
        receiverId: widget.otherUserId,
        text: text,
        timestamp: DateTime.now(),
        isRead: false,
        isDelivered: true,
      ));
      _msgCtrl.clear();
    });

    // Scroll to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });

    // Simulate reply after 2 seconds
    _simulateReply();
  }

  void _simulateReply() {
    setState(() => _isOtherTyping = true);
    _typingTimer?.cancel();
    _typingTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() {
        _isOtherTyping = false;
        _messages.add(MessageModel(
          id: 'm${_messages.length + 1}',
          senderId: widget.otherUserId,
          receiverId: widget.currentUserId,
          text: 'Ji bilkul, shukriya! 👍',
          timestamp: DateTime.now(),
          isRead: false,
          isDelivered: true,
        ));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollCtrl.hasClients) {
          _scrollCtrl.animateTo(
            _scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    });
  }

  void _showBlockDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.tr('block_user')),
        content: Text('Block ${widget.otherUserName}?'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.tr('no'))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: Text(context.tr('yes')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.gold,
              child: Text(
                widget.otherUserName.isNotEmpty
                    ? widget.otherUserName[0].toUpperCase()
                    : '?',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreenDark,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.otherUserName,
                  style: GoogleFonts.poppins(
                      fontSize: 14, fontWeight: FontWeight.w600),
                ),
                if (_isOtherTyping)
                  Text(
                    context.tr('typing'),
                    style: GoogleFonts.poppins(
                        fontSize: 10, color: AppColors.success),
                  )
                else
                  Text(
                    'Online',
                    style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.white.withOpacity(0.7)),
                  ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call_outlined),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'block') _showBlockDialog();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'block',
                child: Row(
                  children: [
                    const Icon(Icons.block, color: AppColors.error),
                    const SizedBox(width: 8),
                    Text(context.tr('block_user')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isOtherTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (_isOtherTyping && i == _messages.length) {
                  return _TypingBubble(name: widget.otherUserName);
                }
                final msg = _messages[i];
                final isMe = msg.senderId == widget.currentUserId;
                return _MessageBubble(
                  message: msg,
                  isMe: isMe,
                  readLabel: context.tr('read'),
                  deliveredLabel: context.tr('delivered'),
                );
              },
            ),
          ),

          // Input bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: InputDecoration(
                        hintText: context.tr('type_message'),
                        filled: true,
                        fillColor: Theme.of(context).cardTheme.color,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(24),
                          borderSide: BorderSide.none,
                        ),
                        isDense: true,
                      ),
                      maxLines: 3,
                      minLines: 1,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.send_rounded,
                          color: Colors.white, size: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isMe;
  final String readLabel;
  final String deliveredLabel;

  const _MessageBubble({
    required this.message,
    required this.isMe,
    required this.readLabel,
    required this.deliveredLabel,
  });

  @override
  Widget build(BuildContext context) {
    final time =
        '${message.timestamp.hour}:${message.timestamp.minute.toString().padLeft(2, '0')}';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.72,
        ),
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isMe ? AppColors.primaryGreen : Theme.of(context).cardTheme.color,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isMe ? 16 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              message.text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isMe ? AppColors.white : null,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  time,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: isMe
                        ? AppColors.white.withOpacity(0.7)
                        : AppColors.grey500,
                  ),
                ),
                if (isMe) ...[
                  const SizedBox(width: 4),
                  Icon(
                    message.isRead
                        ? Icons.done_all
                        : Icons.done,
                    size: 14,
                    color: message.isRead
                        ? AppColors.gold
                        : AppColors.white.withOpacity(0.6),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingBubble extends StatelessWidget {
  final String name;
  const _TypingBubble({required this.name});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(16),
            bottomLeft: Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Dot(delay: 0),
            const SizedBox(width: 4),
            _Dot(delay: 200),
            const SizedBox(width: 4),
            _Dot(delay: 400),
          ],
        ),
      ),
    );
  }
}

class _Dot extends StatefulWidget {
  final int delay;
  const _Dot({required this.delay});

  @override
  State<_Dot> createState() => _DotState();
}

class _DotState extends State<_Dot> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _anim = Tween<double>(begin: 0, end: -6).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Transform.translate(
        offset: Offset(0, _anim.value),
        child: Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.grey400,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
