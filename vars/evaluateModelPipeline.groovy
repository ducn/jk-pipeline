def call(Map parameters) {
  node {
    def API_DOMAIN = 'http://176.32.82.108:5000'
    stage ('Download datasets') {
      def response = httpRequest "$API_DOMAIN/api/datasets/fetch?ids=t9iy"
      print(response.content)
      datasets = readJSON text:response.content
      print(datasets)
      for (dataset in datasets.records) {
            print("$dataset.package_path")
            sh "wget $API_DOMAIN$dataset.package_path -P /data/model/"
      }
    }
    stage ('Saving accuracy score') {
      def body = [
          dataset_id:"t9iy",
          model_id:"222",
          version:"1.0.0",
          accuracy:"1",
      ]
      response = httpRequest consoleLogResponseBody: true, contentType: 'APPLICATION_JSON', httpMode: 'POST', requestBody: body, url: "$API_DOMAIN/api/models/save_result", validResponseCodes: '200'
      print(response)
    }
  }
}
