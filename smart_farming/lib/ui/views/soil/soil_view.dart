import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'soil_viewmodel.dart';

class SoilView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SoilViewModel>.reactive(
      viewModelBuilder: () => SoilViewModel(),
      onModelReady: (model) => model.fetchSoils(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text('Soil Types'),
        ),
        body: model.isBusy
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: model.soils!.length,
                itemBuilder: (context, index) {
                  final soil = model.soils![index];
                  return GridTile(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.asset(
                                "assets/soils/${soil.img}",
                                fit: BoxFit.fill,
                                height: 200,
                                width: MediaQuery.of(context).size.width * 0.9,
                              ),
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              // color: Colors.black.withOpacity(0.7),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    soil.name,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      // color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    soil.about,
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Characteristics: ${soil.chara}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Found in: ${soil.found}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Crops: ${soil.crops}',
                                    style: TextStyle(
                                      fontSize: 14,
                                      // color: Colors.white,
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
                },
              ),
      ),
    );
  }
}
