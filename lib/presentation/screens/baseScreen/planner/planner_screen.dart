import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:two/core/themes/app_colors.dart';
import 'package:two/presentation/widgets/custom_button.dart';

class PlannerScreen extends StatefulWidget {
  const PlannerScreen({super.key});

  @override
  State<PlannerScreen> createState() => PlannerScreenState();
}

class PlannerScreenState extends State<PlannerScreen> {
  // ===================== Variáveis =====================
  DateTime selectedDate = DateTime.now();
  DateTime focusedDate = DateTime.now();
  Map<DateTime, List<Map<String, dynamic>>> eventsByDate = {};
  List<Map<String, dynamic>> categories = [
    {"name": "Série/Filme", "color": AppColors.categoryOne},
    {"name": "Encontro", "color": AppColors.categorySix},
    {"name": "Jantar", "color": AppColors.categoryTwo},
    {"name": "Lazer", "color": AppColors.categoryEight},
    {"name": "Viagem", "color": AppColors.categoryTen},
  ];

  final List<Color> categoryColors = [
    AppColors.categoryOne,
    AppColors.categoryTwo,
    AppColors.categoryThree,
    AppColors.categoryFour,
    AppColors.categoryFive,
    AppColors.categorySix,
    AppColors.categorySeven,
    AppColors.categoryEight,
    AppColors.categoryNine,
    AppColors.categoryTen,
  ];

  // ===================== Métodos de Navegação =====================
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

  // ===================== Métodos de Categorias =====================
  void addNewCategory(String categoryName, Color categoryColor) {
    if (categories.length >= 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Você só pode adicionar até 10 categorias."),
        ),
      );
      return;
    }
    setState(() {
      categories.add({"name": categoryName, "color": categoryColor});
    });
  }

  void openEditCategoriesModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            String? errorMessage;
            return Container(
              padding: const EdgeInsets.all(16),
              height: MediaQuery.of(context).size.height * 0.8,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Editar Categorias",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: ListView.builder(
                      itemCount: categories.length,
                      itemBuilder: (context, index) {
                        final nameController = TextEditingController(
                          text: categories[index]['name'],
                        );
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Nome da Categoria",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildTextField(
                              nameController,
                              "Digite o nome da categoria",
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Cor da Categoria",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _buildColorPicker(
                              context,
                              index,
                              setModalState,
                              errorMessage,
                            ),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    ),
                  ),
                  CustomButton(
                    text: "Salvar Alterações",
                    onPressed: () {
                      setState(() {
                        categories = List.from(categories);
                      });
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.neutral,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildColorPicker(
    BuildContext context,
    int index,
    StateSetter setModalState,
    String? errorMessage,
  ) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: const Text("Editar Cor"),
                  content: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children:
                        categoryColors.map((color) {
                          return GestureDetector(
                            onTap: () {
                              setModalState(() {
                                if (categories.any(
                                  (cat) =>
                                      cat['color'] == color &&
                                      cat != categories[index],
                                )) {
                                  errorMessage =
                                      "Esta cor já está sendo usada.";
                                } else {
                                  categories[index]['color'] = color;
                                  errorMessage = null;
                                }
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      categories[index]['color'] == color
                                          ? Colors.black
                                          : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                );
              },
            );
          },
          child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: categories[index]['color'],
              shape: BoxShape.circle,
            ),
          ),
        ),
        const Icon(Icons.edit, color: Colors.white, size: 20),
      ],
    );
  }

  void _openAddCategoryDialog(BuildContext context) {
    final newCategoryController = TextEditingController();
    Color selectedColor = categoryColors.first;

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width:
                MediaQuery.of(context).size.width *
                0.9, // 90% da largura da tela
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Adicionar Nova Categoria",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildTextField(newCategoryController, "Nome da Categoria"),
                const SizedBox(height: 16),
                const Text(
                  "Selecione uma Cor",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      categoryColors.map((color) {
                        return GestureDetector(
                          onTap: () {
                            selectedColor = color;
                            setState(() {});
                          },
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color:
                                    selectedColor == color
                                        ? Colors.black
                                        : Colors.transparent,
                                width: 2,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Adicionar",
                  onPressed: () {
                    if (newCategoryController.text.isNotEmpty) {
                      setState(() {
                        addNewCategory(
                          newCategoryController.text,
                          selectedColor,
                        );
                      });
                      Navigator.pop(context);
                    }
                  },
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.neutral,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAddCategoryButton(BuildContext context) {
    return TextButton(
      onPressed: () => _openAddCategoryDialog(context),
      child: Text(
        "+ Adicionar Nova Categoria",
        style: TextStyle(color: AppColors.primary),
      ),
    );
  }

  // ===================== Métodos de Eventos =====================
  void _addEvent({
    required String title,
    required String description,
    required String startTime,
    required String endTime,
    required String category,
    required Color categoryColor,
    required DateTime date,
  }) {
    final normalizedDate = DateTime(
      date.year,
      date.month,
      date.day,
    ); // Normaliza a data
    setState(() {
      eventsByDate[normalizedDate] ??= [];
      eventsByDate[normalizedDate]!.add({
        "title": title,
        "description": description,
        "startTime": startTime,
        "endTime": endTime,
        "category": category,
        "categoryColor": categoryColor,
      });
    });
  }

  void openAddEventModal(BuildContext context) {
    final nameController = TextEditingController();
    final descriptionController = TextEditingController();
    final dateController = TextEditingController();
    final startTimeController = TextEditingController();
    final endTimeController = TextEditingController();
    String? selectedCategory;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(
                  left: 16,
                  right: 16,
                  top: 16,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildModalHeader("Adicionar Novo Evento"),
                    const SizedBox(height: 16),
                    _buildTextField(nameController, "Nome do Evento*"),
                    const SizedBox(height: 16),
                    _buildTextField(
                      descriptionController,
                      "Digite a descrição do evento aqui...",
                      maxLines: 4,
                    ),
                    const SizedBox(height: 16),
                    _buildDatePickerField(context, dateController, "Data"),
                    const SizedBox(height: 16),
                    _buildTimePickerRow(
                      context,
                      startTimeController,
                      endTimeController,
                    ),
                    const SizedBox(height: 40),
                    _buildCategorySelector(selectedCategory, (category) {
                      setModalState(() {
                        selectedCategory = category;
                      });
                    }),
                    const SizedBox(height: 16),
                    _buildAddCategoryButton(context),
                    const SizedBox(height: 16),
                    _buildCreateEventButton(
                      context,
                      nameController,
                      descriptionController,
                      dateController,
                      startTimeController,
                      endTimeController,
                      selectedCategory,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['title'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Descrição:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event['description'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Horário:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "${event['startTime']} - ${event['endTime']}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Categoria:",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  event['category'],
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.titlePrimary,
                  ),
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: "Fechar",
                  onPressed: () => Navigator.pop(context),
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.neutral,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ===================== Widgets Auxiliares =====================
  Widget _buildModalHeader(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.inputBackground),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.inputBackground),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
    BuildContext context,
    TextEditingController controller,
    String label,
  ) {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (pickedDate != null) {
          setState(() {
            controller.text = DateFormat("dd/MM/yyyy").format(pickedDate);
          });
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: label,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBackground),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.inputBackground),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.primary),
            ),
            suffixIcon: const Icon(
              Icons.calendar_today,
              color: AppColors.icons,
            ), // Ícone de calendário
          ),
        ),
      ),
    );
  }

  Widget _buildTimePickerRow(
    BuildContext context,
    TextEditingController startController,
    TextEditingController endController,
  ) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );
              if (pickedTime != null) {
                setState(() {
                  startController.text = pickedTime.format(context);
                });
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: startController,
                decoration: InputDecoration(
                  labelText: "Início",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.inputBackground),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.inputBackground),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  suffixIcon: const Icon(
                    Icons.access_time,
                    color: AppColors.icons,
                  ), // Ícone de relógio
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: GestureDetector(
            onTap: () async {
              TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(
                      context,
                    ).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  );
                },
              );
              if (pickedTime != null) {
                setState(() {
                  endController.text = pickedTime.format(context);
                });
              }
            },
            child: AbsorbPointer(
              child: TextField(
                controller: endController,
                decoration: InputDecoration(
                  labelText: "Término",
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.inputBackground),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.inputBackground),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                  suffixIcon: const Icon(
                    Icons.access_time,
                    color: AppColors.icons,
                  ), // Ícone de relógio
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySelector(
    String? selectedCategory,
    Function(String) onCategorySelected,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Selecione uma Categoria",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            TextButton(
              onPressed: () => openEditCategoriesModal(context),
              child: const Text(
                "Editar",
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children:
              categories.map((category) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategory = category['name'];
                    });
                    onCategorySelected(category['name']);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selectedCategory == category['name']
                              ? category['color']
                              : category['color'].withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color:
                                selectedCategory == category['name']
                                    ? AppColors.neutral
                                    : category['color'],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          category['name'],
                          style: TextStyle(
                            fontSize: 16,
                            color:
                                selectedCategory == category['name']
                                    ? AppColors.neutral
                                    : AppColors.titlePrimary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
        ),
      ],
    );
  }

  Widget _buildCreateEventButton(
    BuildContext context,
    TextEditingController nameController,
    TextEditingController descriptionController,
    TextEditingController dateController,
    TextEditingController startTimeController,
    TextEditingController endTimeController,
    String? selectedCategory,
  ) {
    return CustomButton(
      text: "Criar Evento",
      onPressed: () {
        if (nameController.text.isNotEmpty && dateController.text.isNotEmpty) {
          final eventDate = DateFormat("dd/MM/yyyy").parse(dateController.text);
          final category = selectedCategory ?? "Sem categoria";
          final categoryColor =
              categories.firstWhere(
                    (cat) => cat['name'] == category,
                    orElse: () => {"color": Colors.grey},
                  )['color']
                  as Color;

          _addEvent(
            title: nameController.text,
            description: descriptionController.text,
            startTime: startTimeController.text,
            endTime: endTimeController.text,
            category: category,
            categoryColor: categoryColor,
            date: eventDate,
          );
          Navigator.pop(context);
        }
      },
      backgroundColor: AppColors.primary,
      textColor: AppColors.neutral,
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      locale: 'pt_BR',
      focusedDay: focusedDate,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      headerVisible: false,
      calendarStyle: CalendarStyle(
        markersMaxCount: 3,
        markerDecoration: const BoxDecoration(shape: BoxShape.circle),
        defaultTextStyle: const TextStyle(fontSize: 18),
        weekendTextStyle: const TextStyle(
          fontSize: 18,
          color: AppColors.primary,
        ),
        todayDecoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(8),
        ),
        todayTextStyle: const TextStyle(
          color: AppColors.neutral,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      eventLoader: (day) {
        final normalizedDay = DateTime(
          day.year,
          day.month,
          day.day,
        ); // Normaliza a data
        return eventsByDate[normalizedDay] ?? [];
      },
      calendarBuilders: CalendarBuilders(
        defaultBuilder: (context, date, _) {
          return Center(
            child: Text('${date.day}', style: const TextStyle(fontSize: 18)),
          );
        },
        todayBuilder: (context, date, _) {
          return Center(
            child: Container(
              width: 36,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${date.day}',
                style: const TextStyle(
                  color: AppColors.neutral,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          );
        },
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              top: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:
                    events.map((event) {
                      final eventMap = event as Map<String, dynamic>;
                      return Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        decoration: BoxDecoration(
                          color: eventMap['categoryColor'] ?? Colors.grey,
                          shape: BoxShape.circle,
                        ),
                      );
                    }).toList(),
              ),
            );
          }
          return null;
        },
      ),
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          selectedDate = selectedDay;
          focusedDate = focusedDay;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildHeader(),
          _buildCalendar(),
          Expanded(
            child: Column(
              children: [
                // Linha indicativa de página rolável
                Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(top: 8, bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child:
                      (eventsByDate.values.expand((e) => e).isNotEmpty)
                          ? ListView(
                            padding: const EdgeInsets.all(16),
                            children:
                                eventsByDate.values.expand((e) => e).map((
                                  event,
                                ) {
                                  return _buildEventCard(event);
                                }).toList(),
                          )
                          : Center(
                            child: Text(
                              "Nenhum evento adicionado.",
                              style: TextStyle(
                                color: AppColors.titlePrimary,
                                fontSize: 16,
                              ),
                            ),
                          ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildMonthNavigationButton(
            Icons.arrow_back_ios_new,
            goToPreviousMonth,
          ),
          Column(
            children: [
              Text(
                getMonthName(focusedDate.month),
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text("${focusedDate.year}", style: const TextStyle(fontSize: 13)),
            ],
          ),
          _buildMonthNavigationButton(Icons.arrow_forward_ios, goToNextMonth),
        ],
      ),
    );
  }

  Widget _buildMonthNavigationButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.background,
          border: Border.all(color: AppColors.borderNavigation),
          borderRadius: BorderRadius.circular(13),
        ),
        child: Icon(icon, size: 15, color: AppColors.icons),
      ),
    );
  }

  Widget _buildEventCard(Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () => _showEventDetails(context, event),
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Container(
              width: 8,
              height: 120,
              decoration: BoxDecoration(
                color: event['categoryColor'],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                color: event['categoryColor'],
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "${event['startTime']} - ${event['endTime']}",
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.titlePrimary,
                              ),
                            ),
                          ],
                        ),
                        PopupMenuButton<String>(
                          icon: const Icon(
                            Icons.more_horiz,
                            color: AppColors.icons,
                          ),
                          onSelected: (value) {
                            if (value == 'Editar') {
                              _openEditEventModal(context, event);
                            } else if (value == 'Excluir') {
                              _deleteEvent(event);
                            }
                          },
                          itemBuilder:
                              (context) => [
                                const PopupMenuItem(
                                  value: 'Editar',
                                  child: Text('Editar'),
                                ),
                                const PopupMenuItem(
                                  value: 'Excluir',
                                  child: Text('Excluir'),
                                ),
                              ],
                          padding: EdgeInsets.zero, // Remove padding extra
                          constraints:
                              const BoxConstraints(), // Restringe o tamanho
                        ),
                      ],
                    ),
                    Text(
                      event['title'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      event['description'],
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.titlePrimary,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openEditEventModal(BuildContext context, Map<String, dynamic> event) {
    final nameController = TextEditingController(text: event['title']);
    final descriptionController = TextEditingController(
      text: event['description'],
    );
    final startTimeController = TextEditingController(text: event['startTime']);
    final endTimeController = TextEditingController(text: event['endTime']);
    String? selectedCategory = event['category'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildModalHeader("Editar Evento"),
                  const SizedBox(height: 16),
                  _buildTextField(nameController, "Nome do Evento*"),
                  const SizedBox(height: 16),
                  _buildTextField(
                    descriptionController,
                    "Digite a descrição do evento aqui...",
                    maxLines: 4,
                  ),
                  const SizedBox(height: 16),
                  _buildTimePickerRow(
                    context,
                    startTimeController,
                    endTimeController,
                  ),
                  const SizedBox(height: 40),
                  _buildCategorySelector(selectedCategory, (category) {
                    setModalState(() {
                      selectedCategory = category;
                    });
                  }),
                  const Spacer(),
                  CustomButton(
                    text: "Salvar Alterações",
                    onPressed: () {
                      setState(() {
                        event['title'] = nameController.text;
                        event['description'] = descriptionController.text;
                        event['startTime'] = startTimeController.text;
                        event['endTime'] = endTimeController.text;
                        event['category'] = selectedCategory ?? "Sem categoria";
                        event['categoryColor'] =
                            categories.firstWhere(
                              (cat) => cat['name'] == selectedCategory,
                              orElse: () => {"color": Colors.grey},
                            )['color'];
                      });
                      Navigator.pop(context);
                    },
                    backgroundColor: AppColors.primary,
                    textColor: AppColors.neutral,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _deleteEvent(Map<String, dynamic> event) {
    setState(() {
      // Lista temporária para armazenar as datas a serem removidas
      final datesToRemove = <DateTime>[];

      // Itera sobre todas as datas para encontrar e remover o evento
      eventsByDate.forEach((date, events) {
        events.remove(event);
        if (events.isEmpty) {
          datesToRemove.add(date); // Marca a data para remoção
        }
      });

      // Remove as datas marcadas fora da iteração
      for (final date in datesToRemove) {
        eventsByDate.remove(date);
      }
    });
  }
}
