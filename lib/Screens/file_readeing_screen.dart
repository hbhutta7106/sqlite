import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqlite_crud/Screens/data_saving_screen.dart';
import 'package:sqlite_crud/Widgets/file_header_dialog.dart';
import 'package:sqlite_crud/controller/file_controller.dart';

class FileDisplay extends StatefulWidget {
  const FileDisplay({super.key});

  @override
  State<FileDisplay> createState() => _FileDisplayState();
}

class _FileDisplayState extends State<FileDisplay> {
  final FileController _fileController = Get.put(FileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("File and its Data"),
        centerTitle: true,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GetBuilder<FileController>(
          builder: (controller) => SizedBox(
            height: 110,
            child: controller.showTable
                ? Column(
                    children: [
                      if (_fileController.choosenHeadersFromHeaderList.isEmpty)
                        const SizedBox(
                          height: 50,
                        ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black),
                          onPressed: () {
                            _fileController.clearData();
                          },
                          child: const Center(
                            child: Text(
                              "Clear Screen",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          )),
                      if (_fileController
                          .choosenHeadersFromHeaderList.isNotEmpty)
                        const SizedBox(
                          height: 5,
                        ),
                      if (_fileController
                          .choosenHeadersFromHeaderList.isNotEmpty)
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black),
                            onPressed: () {
                              Get.to(() => DataSavingSreen());
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(10.0),
                              child: Center(
                                child: Text(
                                  "Are You want to Save Data ?",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )),
                    ],
                  )
                : const SizedBox(),
          ),
        ),
      ),
      body: GetBuilder<FileController>(
        builder: (fileController) => SafeArea(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Picked File:",
                    ),
                    SizedBox(
                      width: 100,
                      child: Text(
                          overflow: TextOverflow.ellipsis,
                          _fileController.fileName ?? "No File Selected Yet"),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                _fileController.isloading
                    ? const Center(
                        child: Text(
                          "Loading Data...",
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    : _fileController.csvData.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  splashColor: Colors.green,
                                  onTap: () {
                                    Get.dialog(
                                      ChooseHeaderDialog(),
                                      barrierDismissible: false,
                                    );
                                  },
                                  child: Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.7,
                                    height:
                                        MediaQuery.of(context).size.width * 0.4,
                                    decoration: BoxDecoration(
                                      color: Colors.green[100],
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: Center(
                                      child: IconButton(
                                          onPressed: () {
                                            Get.dialog(
                                              ChooseHeaderDialog(),
                                              barrierDismissible: false,
                                            );
                                          },
                                          icon: const Icon(
                                            Icons.upload_file,
                                            color: Colors.black26,
                                            size: 65,
                                          )),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          )
                        : _fileController.showTable
                            ? SizedBox(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height,
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  child: InteractiveViewer(
                                    panEnabled: true,
                                    // Enable panning
                                    scaleEnabled: true, // Enable zooming
                                    minScale: 0.5,
                                    maxScale: 3,

                                    child: SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: DataTable(
                                          border: TableBorder.all(
                                              color: Colors.black, width: 1),
                                          columns: _fileController
                                                  .choosenHeadersFromHeaderList
                                                  .isEmpty
                                              ? List.generate(
                                                  _fileController.rows[0].length,
                                                  (index) {
                                                  return DataColumn(
                                                      label: Text(
                                                    "Column ${index + 1}",
                                                    overflow:
                                                        TextOverflow.visible,
                                                  ));
                                                })
                                              : List.generate(
                                                  _fileController
                                                      .choosenHeadersFromHeaderList
                                                      .length, (index) {
                                                  return DataColumn(
                                                      label: SizedBox(
                                                    width: 50,
                                                    child: Text(
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        _fileController
                                                            .choosenHeadersFromHeaderList[
                                                                index]
                                                            .toString()),
                                                  ));
                                                }),
                                          rows: fileController.choosenRows
                                                  .every((subList) =>
                                                      subList.isEmpty)
                                              ? _fileController.rows
                                                  .map((element) {
                                                  return DataRow(
                                                      cells: List.generate(
                                                          element.length,
                                                          (index) {
                                                    return DataCell(SizedBox(
                                                      width: 50,
                                                      child: Text(
                                                          overflow:
                                                              TextOverflow.clip,
                                                          element[index]
                                                              .toString()),
                                                    ));
                                                  }));
                                                }).toList()
                                              : _fileController.choosenRows
                                                  .map((element) {
                                                  return DataRow(
                                                      cells: List.generate(
                                                          element.length,
                                                          (index) {
                                                    return DataCell(Text(
                                                        overflow: TextOverflow
                                                            .visible,
                                                        element[index]
                                                            .toString()));
                                                  }));
                                                }).toList()),
                                    ),
                                  ),
                                ),
                              )
                            : const Text("Waiting for Data to Load"),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
