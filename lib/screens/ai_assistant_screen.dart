import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/ai_provider.dart';
import '../utils/colors.dart';
import '../utils/typography.dart';
import '../widgets/common/loading_indicator.dart';
import '../widgets/ai/ai_chat_bubble.dart';
import '../widgets/ai/ai_tutor_card.dart';
import '../widgets/ai/ai_feature_card.dart';

class AIAssistantScreen extends StatefulWidget {
  const AIAssistantScreen({super.key});

  @override
  State<AIAssistantScreen> createState() =>
      _AIAssistantScreenState();
}

class _AIAssistantScreenState extends State<AIAssistantScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _showFeatures = true;

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final aiProvider = context.watch<AIProvider>();
    final messages = aiProvider.messages;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                gradient: ClarityColors.primaryGradient,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 16),
            ),
            const SizedBox(width: 10),
            const Text('ClarityBuddy'),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_outlined),
            onPressed: aiProvider.clearMessages,
            tooltip: 'Clear chat',
          ),
        ],
      ),
      body: Column(
        children: [
          if (!aiProvider.isConfigured && aiProvider.useMock)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: ClarityColors.warning.withOpacity(0.1),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: ClarityColors.warning),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI is in demo mode. Configure an API key for full functionality.',
                      style: ClarityTypography.labelSmall.copyWith(
                          color: ClarityColors.warning),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: _showFeatures && messages.isEmpty
                ? _buildFeatures(aiProvider)
                : _buildChat(messages, aiProvider),
          ),
          _buildInputBar(aiProvider),
        ],
      ),
    );
  }

  Widget _buildFeatures(AIProvider aiProvider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hi, I\'m ClarityBuddy!',
              style: ClarityTypography.displaySmall),
          const SizedBox(height: 8),
          Text('Your friendly learning companion. What can I help you with?',
              style: ClarityTypography.bodyMedium.copyWith(
                  color: ClarityColors.textSecondary)),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: ClarityColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Center(
                  child: Icon(Icons.auto_awesome,
                      color: Colors.white, size: 24),
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ClarityBuddy',
                      style: ClarityTypography.titleMedium),
                  Text('AI Learning Companion',
                      style: ClarityTypography.labelSmall.copyWith(
                          color: ClarityColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Try these features:',
              style: ClarityTypography.titleSmall),
          const SizedBox(height: 12),
          AIFeatureCard(
            title: 'Ask Questions',
            subtitle: 'Get help with any topic',
            icon: Icons.chat_outlined,
            color: ClarityColors.primary,
            onTap: () {
              _messageController.text = 'Can you help me understand this topic?';
              setState(() => _showFeatures = false);
            },
          ),
          const SizedBox(height: 8),
          AIFeatureCard(
            title: 'Simplify Content',
            subtitle: 'Make complex topics easier',
            icon: Icons.auto_fix_high_outlined,
            color: ClarityColors.accent,
            onTap: () {
              _messageController.text = 'Can you simplify this for me?';
              setState(() => _showFeatures = false);
            },
          ),
          const SizedBox(height: 8),
          AIFeatureCard(
            title: 'Generate Quiz',
            subtitle: 'Test your knowledge',
            icon: Icons.quiz_outlined,
            color: ClarityColors.secondary,
            onTap: () {
              _messageController.text = 'Generate a practice quiz for me';
              setState(() => _showFeatures = false);
            },
          ),
          const SizedBox(height: 8),
          AIFeatureCard(
            title: 'Create Study Plan',
            subtitle: 'Organize your learning',
            icon: Icons.calendar_month_outlined,
            color: ClarityColors.info,
            onTap: () {
              _messageController.text = 'Create a study plan for me';
              setState(() => _showFeatures = false);
            },
          ),
          const SizedBox(height: 8),
          AIFeatureCard(
            title: 'Explain & Summarize',
            subtitle: 'Get clear explanations',
            icon: Icons.summarize_outlined,
            color: Colors.purple,
            onTap: () {
              _messageController.text = 'Can you explain this topic simply?';
              setState(() => _showFeatures = false);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildChat(
      List<dynamic> messages, AIProvider aiProvider) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(20),
      itemCount: messages.length + (aiProvider.isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length && aiProvider.isLoading) {
          return const AITypingIndicator();
        }
        final msg = messages[index];
        return AIChatBubble(
          message: msg.content,
          isUser: msg.role == 'user',
          timestamp: msg.timestamp,
        );
      },
    );
  }

  Widget _buildInputBar(AIProvider aiProvider) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: ClarityColors.surface,
        boxShadow: [
          BoxShadow(
            color: ClarityColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              decoration: InputDecoration(
                hintText: 'Ask ClarityBuddy...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: ClarityColors.surfaceAlt,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
              ),
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(aiProvider),
              maxLines: 3,
              minLines: 1,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              gradient: ClarityColors.primaryGradient,
              borderRadius: BorderRadius.circular(14),
            ),
            child: IconButton(
              icon: aiProvider.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.send_rounded,
                      color: Colors.white),
              onPressed: aiProvider.isLoading
                  ? null
                  : () => _sendMessage(aiProvider),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(AIProvider aiProvider) {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _messageController.clear();
    setState(() => _showFeatures = false);

    aiProvider.sendMessage(text);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }
}
