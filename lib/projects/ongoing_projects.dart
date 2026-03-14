// lib/projects/ongoing_projects.dart
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

/// ===============================
/// PROJECT MODEL
/// ===============================
class Project {
  final String title;
  final String description;
  final double progress;

  Project({
    required this.title,
    required this.description,
    required this.progress,
  });
}

/// ===============================
/// ONGOING PROJECTS PAGE
/// ===============================
class OngoingProjectsPage extends StatelessWidget {
  const OngoingProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Project> projects = [
      Project(
        title: 'Orphanage Renovation',
        description: 'Renovating the main hall and classrooms',
        progress: 0.6,
      ),
      Project(
        title: 'School Supplies Distribution',
        description: 'Providing books and stationery to children',
        progress: 0.8,
      ),
      Project(
        title: 'Healthcare Program',
        description: 'Monthly health check-ups for sponsored children',
        progress: 0.4,
      ),
      Project(
        title: 'Community Outreach',
        description: 'Engaging local volunteers for mentorship programs',
        progress: 0.7,
      ),
    ];

    final width = MediaQuery.of(context).size.width;
    final bool isWide = width > 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ongoing Projects'),
        backgroundColor: const Color(0xFF4C29F4),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: isWide
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.3,
                ),
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(project: projects[index]);
                },
              )
            : ListView.builder(
                itemCount: projects.length,
                itemBuilder: (context, index) {
                  return ProjectCard(project: projects[index]);
                },
              ),
      ),
    );
  }
}

/// ===============================
/// PROJECT CARD WITH CIRCULAR CHART
/// ===============================
class ProjectCard extends StatefulWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final project = widget.project;
    final progressPercent = (project.progress * 100).toStringAsFixed(0);

    // Determine color based on progress
    Color progressColor;
    if (project.progress >= 0.75) {
      progressColor = Colors.green;
    } else if (project.progress >= 0.5) {
      progressColor = Colors.orange;
    } else {
      progressColor = Colors.red;
    }

    // Status text
    String statusText;
    if (project.progress >= 0.75) {
      statusText = "Almost Done";
    } else if (project.progress >= 0.5) {
      statusText = "In Progress";
    } else {
      statusText = "Just Started";
    }

    // Card content
    Widget cardContent = Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Circular animated chart
          CircularPercentIndicator(
            radius: 60,
            lineWidth: 10,
            percent: project.progress,
            animation: true,
            animationDuration: 1200,
            center: Text(
              "$progressPercent%",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            progressColor: progressColor,
            backgroundColor: Colors.grey[300] ?? Colors.grey,
            circularStrokeCap: CircularStrokeCap.round,
          ),

          const SizedBox(width: 16),

          // Project info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  project.description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
                const SizedBox(height: 12),
                Chip(
                  label: Text(
                    statusText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: progressColor,
                  visualDensity: VisualDensity.compact,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    // Hover effect for desktop / ripple effect for mobile
    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isHovered ? Colors.grey[100] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: isHovered ? 10 : 5,
              offset: Offset(0, isHovered ? 6 : 3),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // Optional: handle project tap
          },
          child: cardContent,
        ),
      ),
    );
  }
}