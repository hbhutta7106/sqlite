import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/controller/file_controller.dart';

class ChooseHeaderDialog extends StatelessWidget {
  final FileController _fileController = Get.find();
  ChooseHeaderDialog({super.key});
  final List<String> headers = const ['Name', 'Age  '];
  final List<String> row = const ['Hanan', '24'];
  final List<String> withOutHeaders = const ['column1', 'column2'];
  final List<List<String>> rows = const [
    ['Hanan', '24'],
    ['subhan', '15']
    

  ];

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListView(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Does File Contain Headers ?",
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          children: [
                            const Text(
                              "File with Headers",
                              style: TextStyle(fontSize: 14),
                            ),
                            DataTable(
                                border: TableBorder.all(),
                                columns: List.generate(headers.length, (index) {
                                  return DataColumn(
                                      label: Text(headers[index]));
                                }),
                                rows: List.generate(rows.length, (index) {
                                  return DataRow(
                                      cells: List.generate(rows[index].length,
                                          (valueIndex) {
                                    return DataCell(
                                        Text(rows[index][valueIndex]));
                                  }));
                                }))
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Column(
                          children: [
                            const Text(
                              "File without Headers",
                              style: TextStyle(fontSize: 14),
                            ),
                            DataTable(
                                border: TableBorder.all(),
                                columns: List.generate(withOutHeaders.length,
                                    (index) {
                                  return DataColumn(
                                      label: Text(withOutHeaders[index]));
                                }),
                                rows: List.generate(rows.length, (index) {
                                  return DataRow(
                                      cells: List.generate(rows[index].length,
                                          (valueIndex) {
                                    return DataCell(
                                        Text(rows[index][valueIndex]));
                                  }));
                                }))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GetBuilder<FileController>(
                builder: (controller) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        const Text(
                          "Yes",
                          style: TextStyle(fontSize: 14),
                        ),
                        Radio(
                            value: true,
                            groupValue: _fileController.isContainHeaders,
                            onChanged: (value) {
                              _fileController.checkContainHeaders(value!);
                            }),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Radio(
                            value: false,
                            groupValue: _fileController.isContainHeaders,
                            onChanged: (value) {
                              _fileController.checkContainHeaders(value!);
                            }),
                        const Text(
                          "No",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              GetBuilder<FileController>(
                builder: (controller) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back();
                          _fileController.pickFile();
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(10.0),
                          backgroundColor: Colors.black,
                        ),
                        child: const Center(
                          child: Text(
                            "Pick File",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          Get.back();
                          
                        },
                        child: const Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
