import 'package:flutter/material.dart';
import 'package:myapp/src/features/doctor/doctor/camera_screen.dart';

final List<ToolsData> tools = [
  ToolsData(
    title: 'Dementia Prediction',
    severity: 'MRI',
    iconColor: Colors.red,
    icon: Icons.accessibility_new,
  ),
  ToolsData(
    title: 'Skin Lesions Classification',
    severity: 'Camera',
    iconColor: Colors.green,
    icon: Icons.face,
  ),
];

class DiagnosisTools extends StatefulWidget {
  const DiagnosisTools({super.key});

  @override
  State<DiagnosisTools> createState() => _DiagnosisToolsPageState();
}

class _DiagnosisToolsPageState extends State<DiagnosisTools> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF4081),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF4081),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Doctor Diagnosis Tools',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TabBar(
              controller: _tabController,
              indicator: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.white,
                    width: 5,
                  ),
                ),
              ),
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withOpacity(0.7),
              labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              unselectedLabelStyle: const TextStyle(fontSize: 16),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'EHR'),
                Tab(text: 'MRI'),
                Tab(text: 'CT Scan'),
                Tab(text: 'Camera'),
              ],
            ),
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildTopicsList(MediaQuery.of(context).size.width < 600),
                  const Center(child: Text('EHR Based Diagnosis Tools')),
                  const Center(child: Text('MRI Based Diagnosis Tools')),
                  const Center(child: Text('CT Scan Based Diagnosis Tools')),
                  const Center(child: Text('Camera Based Diagnosis Tools')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildTopicsList(bool isMobile) {
    return LayoutBuilder(
        builder: (context, constraints)
        {
          int crossAxisCount = isMobile ? 2 : (constraints.maxWidth ~/ 300).clamp(
              2, 4);

          return SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16.0 : 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'All Tools',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    mainAxisExtent: 120, // Fixed height for each card
                  ),
                  itemCount: tools.length,
                  itemBuilder: (context, index) {
                    return ToolsCard(
                      tool: tools[index],
                      onTap: () {
                        if (tools[index].severity == 'Camera') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CameraScreen(title: tools[index].title),
                            ),
                          );
                        } else {
                          print('Tapped on ${tools[index].title}');
                        }
                      },
                    );
                  },
                ),
              ],
            ),
          );
        }
    );
  }



  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class ToolsData {
  final String title;
  final String severity;
  final Color iconColor;
  final IconData icon;

  ToolsData({
    required this.title,
    required this.severity,
    required this.iconColor,
    required this.icon,
  });
}

class ToolsCard extends StatelessWidget {
  final ToolsData tool;
  final VoidCallback onTap;

  const ToolsCard({super.key, required this.tool, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: tool.iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(tool.icon, color: tool.iconColor, size: 18),
                  ),
                  const Icon(Icons.more_vert, size: 18),
                ],
              ),
              const Spacer(),
              Text(
                tool.title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                'Category: ${tool.severity}',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


