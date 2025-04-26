import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime today = DateTime.now();
  
  List<DateTime> markedDates = [
    DateTime.utc(2025, 4, 10),
    DateTime.utc(2025, 4, 15),
    DateTime.utc(2025, 4, 20),
  ];

  List<Map<String, dynamic>> events = [
    {
      "title": "Ida na Orla",
      "description": "Descrição",
      "time": "10:00–13:00",
      "color": Colors.green,
    },
    {
      "title": "Noite do Hambúrguer",
      "description": "Descrição",
      "time": "14:00–15:00",
      "color": Colors.red,
    },
  ];

  String getMonthName(int month) {
    const months = [
      "Janeiro", "Fevereiro", "Março", "Abril",
      "Maio", "Junho", "Julho", "Agosto",
      "Setembro", "Outubro", "Novembro", "Dezembro"
    ];
    return months[month - 1];
  }

  void goToPreviousMonth() {
    setState(() {
      today = DateTime(today.year, today.month - 1, 1);
    });
  }

  void goToNextMonth() {
    setState(() {
      today = DateTime(today.year, today.month + 1, 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const SizedBox(height: 20),
          buildHeader(),
          buildCalendar(),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return EventCard(
                  title: event['title'],
                  description: event['description'],
                  time: event['time'],
                  color: event['color'],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, 
        children: [
          GestureDetector(
            onTap: goToPreviousMonth,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.arrow_back_ios_new, size: 15, color: Colors.grey.shade800),
            ),
          ),
          Column(
            children: [
              Text(
                getMonthName(today.month),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                "${today.year}",
                style: const TextStyle(fontSize: 14, color: Color(0x80000000)),
              ),
            ],
          ),
          GestureDetector(
            onTap: goToNextMonth,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.arrow_forward_ios, size: 15, color: Colors.grey.shade800),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCalendar() {
    return TableCalendar(
      locale: 'pt_BR',
      focusedDay: today,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      headerVisible: false,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(13), 
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(50),
              spreadRadius: 2,
              blurRadius: 6,
            ),
          ],
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(13),
        ),
        markerDecoration: BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
      selectedDayPredicate: (day) {
        return markedDates.any((markedDay) => isSameDay(markedDay, day));
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          today = selectedDay;
        });
      },
      onPageChanged: (newDate) {
        setState(() {
          today = newDate;
        });
      },
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final Color color;

  const EventCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 80,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text(
                time,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
              trailing: const Icon(Icons.more_vert),
            ),
          ),
        ],
      ),
    );
  }
}
