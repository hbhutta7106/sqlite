import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/controller/file_controller.dart';

import '../controller/data_saving_controller.dart';

// ignore: must_be_immutable
class HeadersDialog extends StatelessWidget {
  HeadersDialog({super.key, this.dialogFor});
  String? dialogFor;
  final DataSavingController _dataSaving = Get.put(DataSavingController());
  final FileController _fileController = Get.find();
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
          dialogFor != null ? dialogFor!.toUpperCase() : "Header Checking"),
      content: GetBuilder<FileController>(builder: (controller) {
        return SingleChildScrollView(
          child: dialogFor != null
              ? headerSeletion()
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: controller.isContainHeaders != null &&
                          controller.headers.isNotEmpty
                      ? [
                          ...List.generate(controller.headers.length, (index) {
                            return Row(
                              children: [
                                Checkbox(
                                    value: controller.selectedHeaders[index],
                                    onChanged: (value) {
                                      controller.selectHeadersAndTheirData(
                                          index, value!);
                                    }),
                                const SizedBox(width: 5),
                                SizedBox(
                                  width: 150,
                                  child: Text(
                                    controller.headers[index].isEmpty
                                        ? "Headers ${index + 1}"
                                        : controller.headers[index],
                                    softWrap: true,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          }),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.black),
                              onPressed: () {
                                Navigator.of(context).pop();
                                controller.showDataTable();
                              },
                              child: const Center(
                                child: Text(
                                  "Done",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ))
                        ]
                      : [
                          const Text("Does the file contain headers ?"),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text("Yes"),
                              Radio<bool>(
                                value: true,
                                groupValue: controller.isContainHeaders,
                                onChanged: (value) {
                                  controller.checkContainHeaders(value!);
                                },
                              ),
                              const Text("No"),
                              Radio<bool>(
                                value: false,
                                groupValue: controller.isContainHeaders,
                                onChanged: (value) {
                                  controller.checkContainHeaders(value!);
                                },
                              ),
                            ],
                          ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red),
                              onPressed: () {
                                Get.snackbar("Choose File",
                                    "You can choose Your File Now");
                              },
                              child: const Center(
                                child: Text("Back"),
                              ))
                        ],
                ),
        );
      }),
    );
  }

  Widget headerSeletion() {
    return GetBuilder<DataSavingController>(
      init: DataSavingController(),
      builder: (databaseController) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: DataTable(
                        columns: [
                          DataColumn(
                              label: _dataSaving.existingColumns.isEmpty
                                  ? const Text("No Existing Headers")
                                  : const Text("Existing Headers")),
                        ],
                        rows: List.generate(_dataSaving.existingColumns.length,
                            (index) {
                          return DataRow(cells: [
                            DataCell(Text(databaseController.existingColumns
                                .elementAt(index))),
                          ]);
                        })),
                  ),
                ),
                const SizedBox(width: 20),
                SizedBox(
                  width: 100,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: DataTable(
                        columns: [
                          DataColumn(
                              label: _dataSaving.newHeaders.isEmpty
                                  ? const Text("Headers Already exists")
                                  : const Text("New Headers")),
                        ],
                        rows: List.generate(_dataSaving.newHeaders.length,
                            (index) {
                          return DataRow(cells: [
                            DataCell(Text(databaseController.newHeaders
                                .elementAt(index))),
                          ]);
                        })),
                  ),
                )
              ],
            ),
            const Text("Do You want to store data with new headers?  "),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () async {
                          _dataSaving
                              .insertColumns(
                                  _fileController.choosenHeadersFromHeaderList,
                                  _dataSaving.selectedTableName)
                              .then((value) {
                            _dataSaving.insertDataIntoTable(
                                _dataSaving.selectedTableName,
                                _fileController.choosenHeadersFromHeaderList,
                                _fileController.choosenRows);
                            _dataSaving.clearController();
                            Get.back();
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: () async {
                           _dataSaving.insertIntoTableWithOutNewHeaders(
                        _fileController.choosenHeadersFromHeaderList,
                        _fileController.choosenRows,
                        _dataSaving.selectedTableName,
                        );
                          //_dataSaving.deleteDatabase();
                          await _dataSaving.getAllDataFromTable(
                              _dataSaving.selectedTableName.toString());
                          _dataSaving.clearController();
                          Get.back();
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.white),
                          ),
                        ))),
              ],
            )
          ]),
    );
  }
}
