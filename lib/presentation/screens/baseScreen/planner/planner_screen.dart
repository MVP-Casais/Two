import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> eventsByDate = {};

  void goToPreviousMonth() {
    setState(() {
      focusedDate = DateTime(
        focusedDate.year,
        focusedDate.month - 1,
        focusedDate.day,
      );
    });
  }

  void goToNextMonth() {
    setState(() {
      focusedDate = DateTime(
        focusedDate.year,
        focusedDate.month + 1,
        focusedDate.day,
      );
    });
  }

  String getMonthName(int month) {
    const months = [
      "Janeiro",
      "Fevereiro",
      "Março",
      "Abril",
      "Maio",
      "Junho",
      "Julho",
      "Agosto",
      "Setembro",
      "Outubro",
      "Novembro",
      "Dezembro",
    ];
    return months[month - 1];
  }

  void showEventDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController startTimeController = TextEditingController();
    final TextEditingController endTimeController = TextEditingController();
    final TextEditingController dateController = TextEditingController();
    String? selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 24,
            right: 24,
            top: 30,
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              Center(
                child: Text(
                  "Adicionar novo evento",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 24),
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Nome do evento",
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Data Popup
              GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );

                  if (pickedDate != null && mounted) {
                    setState(() {
                      dateController.text = DateFormat(
                        "dd/MM/yyyy",
                      ).format(pickedDate);
                    });
                  }
                },
                child: AbsorbPointer(
                  child: TextField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: "Data",
                      labelStyle: TextStyle(color: Colors.grey.shade600),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey.shade400),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      suffixIcon: Icon(
                        Icons.calendar_today,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                ),
              ),

              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null && mounted) {
                          setState(() {
                            startTimeController.text = pickedTime.format(
                              context,
                            );
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: startTimeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Início",
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: Icon(
                              Icons.access_time,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        );
                        if (pickedTime != null && mounted) {
                          setState(() {
                            endTimeController.text = pickedTime.format(context);
                          });
                        }
                      },
                      child: AbsorbPointer(
                        child: TextField(
                          controller: endTimeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: "Término",
                            labelStyle: TextStyle(color: Colors.grey.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                              ),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                            suffixIcon: Icon(
                              Icons.access_time,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                onChanged: (String? newCategory) {
                  setState(() {
                    selectedCategory = newCategory;
                  });
                },
                decoration: InputDecoration(
                  labelText: "Categoria",
                  labelStyle: TextStyle(color: Colors.grey.shade600),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade400),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                items:
                    ["Trabalho", "Pessoal", "Estudo"].map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(category),
                      );
                    }).toList(),
              ),
              TextButton(
                onPressed: () {
                  // Lógica para adicionar nova categoria
                },
                child: Text(
                  "+ Adicionar categoria",
                  style: TextStyle(
                    color: const Color.fromARGB(255, 255, 17, 0),
                  ),
                ),
              ),
              SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty) {
                      setState(() {
                        eventsByDate[selectedDate] ??= [];
                        eventsByDate[selectedDate]!.add({
                          "title": nameController.text,
                          "description": descriptionController.text,
                          "startTime": startTimeController.text,
                          "endTime": endTimeController.text,
                          "category": selectedCategory ?? "Sem categoria",
                        });
                      });
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    "Criar evento",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
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
            child: ListView(
              padding: const EdgeInsets.all(16),
              children:
                  eventsByDate.entries.expand((entry) {
                    return entry.value.map((event) {
                      return Card(
                        margin: EdgeInsets.only(bottom: 16),
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
                                color: Colors.red,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  bottomLeft: Radius.circular(16),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  event['title'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  event['description'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black54,
                                  ),
                                ),
                                trailing: Icon(Icons.more_vert),
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                  }).toList(),
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
          // Botão para voltar ao mês anterior
          GestureDetector(
            onTap: goToPreviousMonth,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                size: 15,
                color: Colors.black,
              ),
            ),
          ),

          // Mês e ano centralizados, com o ano abaixo do mês
          Column(
            children: [
              
              SizedBox(height: 8),
              Text(
                getMonthName(focusedDate.month), // Nome do mês
                style: TextStyle(
                  
                  fontSize: 19, // Mantendo o mês maior
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Destacado
                ),
              ),
              Text(
                "${focusedDate.year}", // Ano abaixo do mês
                style: TextStyle(
                  fontSize: 13, // Ano menor
                  color:
                      Colors.grey.shade600, // Tom mais opaco sem usar Opacity
                ),
              ),
            ],
          ),

          // Botão para avançar ao próximo mês
          GestureDetector(
            onTap: goToNextMonth,
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade400, width: 1),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                size: 15,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCalendar() {
    return TableCalendar(
      locale: 'pt_BR',
      focusedDay: focusedDate,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      headerVisible: false,
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Colors.redAccent,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(13),
        ),
        selectedDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(13),
        ),
        todayTextStyle: TextStyle(color: Colors.white),
        selectedTextStyle: TextStyle(color: Colors.white),
        markersMaxCount: 3, // Limitando o número de bolinhas
        markerDecoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
        ),
      ),
      eventLoader: (day) {
        return eventsByDate[day] ?? [];
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          selectedDate = selectedDay;
          focusedDate = focusedDay;
        });
        showEventDialog(context);
      },
    );
  }
}
