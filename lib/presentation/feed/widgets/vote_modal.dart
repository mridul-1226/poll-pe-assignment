import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:poll_pe_assignment/domain/models/post_model.dart';
import 'package:poll_pe_assignment/presentation/feed/bloc/post_cubit.dart';

class VoteModal extends StatelessWidget {
  final PostCubit postCubit;
  final PageController _pageController = PageController();

  VoteModal({
    super.key,
    required this.postCubit,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PostCubit, Post>(
      bloc: postCubit,
      builder: (context, post) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  children: [
                    _buildVotingOptionsPage(context, post),
                    _buildBarGraphPage(post),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVotingOptionsPage(BuildContext context, Post post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (post.imageUrl != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              post.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(height: 16),
        Text(
          post.text,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        ...post.voteOptions.map((option) => _buildVoteOption(
              context,
              option,
            )),
        const Spacer(),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _pageController.nextPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Text("Show Graph"),
          ),
        ),
      ],
    );
  }

  Widget _buildVoteOption(BuildContext context, VoteOption option) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: InkWell(
        onTap: () {
          postCubit.voteForOption(option.label);
        },
        child: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Row(
            children: [
              Radio<String>(
                value: option.label,
                groupValue: null,
                onChanged: (_) {
                  postCubit.voteForOption(option.label);
                },
              ),
              Expanded(
                child: Text(
                  option.label,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  option.value.toStringAsFixed(0),
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBarGraphPage(Post post) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        const Text(
          "Vote Distribution",
        ),
        const SizedBox(height: 16),
        Expanded(child: _buildBarChart(post.voteOptions)),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _pageController.previousPage(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
            child: const Text("Back to Options"),
          ),
        ),
      ],
    );
  }

  Widget _buildBarChart(List<VoteOption> voteOptions) {
    final totalValue =
        voteOptions.fold<double>(0, (sum, option) => sum + option.value);

    final optionsWithPercentage = voteOptions.map((option) {
      final percentage = totalValue > 0 ? (option.value / totalValue) * 100 : 0;
      return VoteOption(
        label: option.label,
        value: double.parse(percentage.toStringAsFixed(1)),
      );
    }).toList();

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 100,
        barGroups: optionsWithPercentage.asMap().entries.map((entry) {
          final index = entry.key;
          final option = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: option.value,
                color: Colors.blueAccent,
                width: 20,
                borderRadius: BorderRadius.circular(14),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }).toList(),
        titlesData: FlTitlesData(
          show: true,
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(
              showTitles: false,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: 20,
              getTitlesWidget: (value, meta) => Text('${value.toInt()}%'),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final option = voteOptions[value.toInt()];
                return Text(option.label);
              },
            ),
          ),
        ),
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: true),
      ),
    );
  }
}
