import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

class StampScreen extends ConsumerWidget {
  const StampScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('스탬프'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      '나의 스탬프',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _StampGrid(),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: 7 / 10,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.brown),
                    ),
                    const SizedBox(height: 8),
                    const Text('7 / 10'),
                    const SizedBox(height: 8),
                    const Text(
                      '3개 더 모으면 무료 음료!',
                      style: TextStyle(
                        color: Colors.brown,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      '멤버십 바코드',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    QrImageView(
                      data: 'USER_ID_12345',
                      version: QrVersions.auto,
                      size: 200.0,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'USER_12345',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      '스탬프 히스토리',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildHistoryItem('2024.01.15', '아메리카노', '+1'),
                    _buildHistoryItem('2024.01.14', '카페라떼', '+1'),
                    _buildHistoryItem('2024.01.13', '무료 음료 사용', '-10'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryItem(String date, String item, String stamps) {
    final isUsed = stamps.startsWith('-');
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(
            date,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 12,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(item),
          ),
          Text(
            stamps,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isUsed ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _StampGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: 10,
      itemBuilder: (context, index) {
        final isStamped = index < 7;
        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isStamped ? Colors.brown : Colors.grey.shade200,
            border: Border.all(
              color: isStamped ? Colors.brown.shade700 : Colors.grey.shade400,
              width: 2,
            ),
          ),
          child: Center(
            child: Icon(
              isStamped ? Icons.coffee : Icons.coffee_outlined,
              color: isStamped ? Colors.white : Colors.grey.shade400,
              size: 24,
            ),
          ),
        );
      },
    );
  }
}